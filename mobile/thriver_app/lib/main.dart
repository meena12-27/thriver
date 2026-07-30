import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:async';

void main() {
  runApp(const ThriverApp());
}

class ThriverApp extends StatelessWidget {
  const ThriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thriver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  Map<String, dynamic>? recommendation;
  Timer? timer;
  Map<String, dynamic>? availability;
  List<dynamic> malls = [];
int selectedMallId = 1;
List<dynamic> parkingMap = [];
int selectedFloor = 1;

  @override
  void initState() {
    super.initState();

    loadMalls();
loadRecommendation();
loadAvailability();
loadParkingMap();

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) {
        loadRecommendation();
        loadAvailability();
      },
    );
  }


  void loadRecommendation() async {

    final data =
        await ApiService.getRecommendation(selectedMallId);

    setState(() {
      recommendation = data;
    });

  }
  void loadAvailability() async {

    final data =
        await ApiService.getAvailableSlots(selectedMallId);

    setState(() {
      availability = data;
    });

  }
  void loadParkingMap() async {

  final data =
      await ApiService.getParkingMap(selectedMallId);

  setState(() {
    parkingMap = data;
  });

}
  void loadMalls() async {

  final data =
      await ApiService.getMalls();

  setState(() {
    malls = data;
  });

}


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
  title: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "🚗 Thriver",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "Smart Parking Assistant",
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    ],
  ),
),


      body: recommendation == null || recommendation!['parking'] == null

          ? const Center(
              child: CircularProgressIndicator(),
            )


          : Padding(
  padding: const EdgeInsets.all(20),

  child: ListView(

    children: [
      if (malls.isNotEmpty)

        DropdownButton<int>(

          value: selectedMallId,

          items: malls.map<DropdownMenuItem<int>>(
            (mall) {

              return DropdownMenuItem<int>(
                value: mall["id"],

                child: Text(
                  mall["name"],
                ),
              );

            },
          ).toList(),


          onChanged: (value) {

            if (value != null) {

              setState(() {
                selectedMallId = value;
              });

              loadRecommendation();
              loadAvailability();
              loadParkingMap();
            }

          },

        ),

      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                "🏬 Nearby Mall",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                recommendation!["mall"] ?? "Loading...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Smart Parking Assistant",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

            ],
          ),
        ),
      ),


      const SizedBox(height: 20),


      if (availability != null)

        Card(
  elevation: 4,

  child: ListTile(

    leading: Icon(
      Icons.local_parking,
      color: availability!["slots"].length > 5
          ? Colors.green
          : availability!["slots"].length > 0
              ? Colors.orange
              : Colors.red,
      size: 35,
    ),

    title: const Text(
      "Available Parking",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    subtitle: Text(
      availability!["slots"].length > 5
          ? "🟢 ${availability!["slots"].length} slots ready"
          : availability!["slots"].length > 0
              ? "🟠 ${availability!["slots"].length} slots ready"
              : "🔴 No slots available",
    ),

  ),
),



      const SizedBox(height: 20),


      Card(
  elevation: 6,
  color: Colors.blue.shade50,

  child: Padding(
    padding: const EdgeInsets.all(20),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [

        const Text(
          "⭐ YOUR PARKING SPOT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),


        const SizedBox(height: 15),


        Text(
          recommendation!["parking"]["slot"]??'N/A',
          style: const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),


        const SizedBox(height: 10),


        Text(
          "Floor ${recommendation!["parking"]["floor"]??'N/A'}",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),


        Text(
          "${recommendation!["parking"]["zone"]??'N/A'} Zone",
          style: const TextStyle(
            fontSize: 18,
          ),
        ),


        const SizedBox(height: 12),


        Text(
          "📍 ${recommendation!["distance"]??0} m away",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),
  ),
),



      const SizedBox(height: 20),
      const Text(
  "🗺️ Parking Map",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
DropdownButton<int>(

  value: selectedFloor,

  items: [1, 2].map(
    (floor) {

      return DropdownMenuItem<int>(
        value: floor,

        child: Text(
          "Floor $floor",
        ),

      );

    },

  ).toList(),


  onChanged: (value) {

    if (value != null) {

      setState(() {
        selectedFloor = value;
      });

    }

  },

),

const SizedBox(height: 10),


Card(
  elevation: 4,

  child: SizedBox(
    height: 350,

    child: Stack(

      children: parkingMap
        .where(
          (slot) =>
              slot["floor"] == selectedFloor,
        )
        .map<Widget>((slot) {
        Color color;

        if (slot["status"] == "available") {
          color = Colors.green;
        } else {
          color = Colors.red;
        }


        if (
          recommendation != null &&
          recommendation!["parking"]["slot"] == slot["slot"]
        ) {
          color = Colors.blue;
        }


        return Positioned(

          left: (slot["x"] * 8.0) - 20,
top: (slot["y"] * 6.0) - 20,


          child: Container(

            width: 60,
            height: 45,


            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(8),
            ),


            child: Center(

              child: Text(
                slot["slot"],

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),

              ),

            ),

          ),

        );

      }).toList(),

    ),

  ),

),


const SizedBox(height: 20),

      const Text(
        "🧭 Route",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),


      ...recommendation!["navigation"]
          .map<Widget>(
            (step) => Padding(
              padding:
                  const EdgeInsets.only(top: 5),

              child: Text(
                step,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
          .toList(),


      const SizedBox(height: 20),


      ElevatedButton.icon(

        onPressed: () {
          loadRecommendation();
          loadAvailability();
        },

        icon: const Icon(Icons.refresh),

        label: const Text(
          "Refresh Parking",
        ),

      ),

    ],
  ),
)

    );

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}