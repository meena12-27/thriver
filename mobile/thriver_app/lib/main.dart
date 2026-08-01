import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'dart:async';

import 'models/mall.dart';
import 'models/parking_slot.dart';
import 'models/recommendation.dart';
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

  Recommendation? recommendation;

String? errorMessage;
Timer? timer;

List<ParkingSlot> availability = [];

List<Mall> malls = [];

int selectedMallId = 1;

List<ParkingSlot> parkingMap = [];

int selectedFloor = 1;
ParkingSlot? selectedSlot;
bool showAvailableOnly = false;

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

  try {

    setState(() {
      errorMessage = null;
    });

    final data =
        await ApiService.getRecommendation(selectedMallId);

    setState(() {
      recommendation = data;
    });

  } catch (e) {

    setState(() {
      errorMessage =
          "Unable to connect to parking server";
    });

  }

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
  elevation: 2,

  title: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Text(
        "Good Morning 👋",
        style: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),


      Text(
        "🚗 Thriver",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),


    ],

  ),

  actions: [

    Padding(
      padding: EdgeInsets.only(right: 16),

      child: CircleAvatar(
        backgroundColor: Colors.white,

        child: Icon(
          Icons.person,
          color: Colors.blue,
        ),

      ),

    ),

  ],

),


      body: errorMessage != null

    ? Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.cloud_off,
              size: 60,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(

              onPressed: () {

                loadRecommendation();
                loadAvailability();
                loadParkingMap();

              },

              icon: const Icon(
                Icons.refresh,
              ),

              label: const Text(
                "Retry",
              ),

            ),

          ],

        ),

      )


    : recommendation == null

    ? const Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            CircularProgressIndicator(),

            SizedBox(height: 20),

            Text(
              "🚗 Finding your parking spot...",
              style: TextStyle(
                fontSize: 18,
              ),
            ),

          ],

        ),

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
                value: mall.id,

                child: Text(
                  mall.name,
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

  elevation: 6,

  color: Colors.blue.shade50,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),

  child: Padding(

    padding: const EdgeInsets.all(18),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "📊 Parking Overview",

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

          ),

        ),


        const SizedBox(height: 15),


        Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: [


            Column(

              children: [

                const Icon(
                  Icons.local_parking,
                  color: Colors.green,
                  size: 35,
                ),

                const SizedBox(height: 5),


                Text(

                  "${availability.length}",

                  style: const TextStyle(

                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const Text(
                  "Available",
                ),

              ],

            ),



            Column(

              children: [

                const Icon(
                  Icons.directions_car,
                  color: Colors.blue,
                  size: 35,
                ),


                const SizedBox(height: 5),


                Text(

                  "${parkingMap.length}",

                  style: const TextStyle(

                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const Text(
                  "Total Slots",
                ),

              ],

            ),



            Column(

              children: [

                Icon(

                  Icons.traffic,

                  color: availability.length > 5

                      ? Colors.green

                      : Colors.orange,

                  size: 35,

                ),


                const SizedBox(height: 5),


                Text(

                  availability.length > 5

                      ? "Low"

                      : "Busy",

                  style: const TextStyle(

                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const Text(
                  "Traffic",
                ),

              ],

            ),

          ],

        ),

      ],

    ),

  ),

),
        const SizedBox(height: 15),

Card(
  elevation: 5,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),

  color: Colors.blue.shade50,

  child: Padding(
    padding: const EdgeInsets.all(18),

    child: Row(

      children: [

        Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),

          child: const Icon(
            Icons.local_parking,
            color: Colors.white,
            size: 30,
          ),
        ),


        const SizedBox(width: 15),


        Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome to Thriver",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 5),


            Text(
              "Finding the best parking spot for you",
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

          ],

        ),

      ],

    ),
  ),
),

      Card(
  elevation: 6,

  color: Colors.blue.shade50,

  child: Padding(
    padding: const EdgeInsets.all(20),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          "🏬 ${recommendation!.mall}",
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),


        const SizedBox(height: 15),


        Row(
          children: [

            const Icon(
              Icons.local_parking,
              color: Colors.green,
            ),

            const SizedBox(width: 8),

            Text(
              availability.isNotEmpty
                  ? "${availability.length} parking slots available"
                  : "No parking available",

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),

            ),

          ],
        ),


        const Divider(
          height: 30,
        ),


        const Text(
          "⭐ Recommended Spot",

          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),

        ),


        const SizedBox(height: 8),


        Text(
          recommendation!.parking.slotNumber,

          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),

        ),


        const SizedBox(height: 8),


        Text(
          "Floor ${recommendation!.parking.floor} • ${recommendation!.parking.zone} Zone",

          style: const TextStyle(
            fontSize: 16,
          ),

        ),


        const SizedBox(height: 8),


        Text(
          "📍 ${recommendation!.distance} m away",

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


      if (availability .isNotEmpty)

        Card(
  elevation: 4,

  child: Padding(
    padding: const EdgeInsets.all(16),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: availability.isNotEmpty
                    ? Colors.green
                    : Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 8),

            const Text(
              "LIVE STATUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

          ],
        ),


        const SizedBox(height: 12),


        Row(
          children: [

            const Icon(
              Icons.local_parking,
              color: Colors.blue,
              size: 35,
            ),

            const SizedBox(width: 15),


            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  "Available Parking",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                Text(
                  availability.isNotEmpty
                      ? "🟢 ${availability.length} slots ready"
                      : "🔴 No slots available",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

              ],
            ),

          ],
        ),


        const SizedBox(height: 10),


        Text(
          "Updated automatically every 10 seconds",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),

      ],
    ),

  ),
),



      const SizedBox(height: 20),


      Card(
  elevation: 8,
  color: Colors.blue.shade50,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),

  child: Padding(
    padding: const EdgeInsets.all(20),

    child: Column(

      children: [

        const Text(
          "⭐ AI RECOMMENDED PARKING",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),


        const SizedBox(height: 15),


        Container(

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(

            children: [

              Text(
                recommendation!.parking.slotNumber,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),


              const SizedBox(height: 10),


              Text(
                "🏢 Floor ${recommendation!.parking.floor}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),


              Text(
                "📍 ${recommendation!.parking.zone} Zone",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),


              const SizedBox(height: 10),


              Text(
                "🚶 ${recommendation!.distance} m away",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],

          ),

        ),


        const SizedBox(height: 20),


        const Align(

          alignment: Alignment.centerLeft,

          child: Text(
            "Why this spot?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

        ),


        const SizedBox(height: 8),


        const Align(

          alignment: Alignment.centerLeft,

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text("✓ Closest available slot"),

              Text("✓ Low walking distance"),

              Text("✓ Best route selected"),

            ],

          ),

        ),


        const SizedBox(height: 15),


        Container(

          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),

          decoration: BoxDecoration(

            color: Colors.green.shade100,

            borderRadius:
                BorderRadius.circular(20),

          ),

          child: const Text(

            "AI Confidence: 94%",

            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),

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
Row(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    const Text(
      "Available Only",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),


    Switch(

      value: showAvailableOnly,

      onChanged: (value){

        setState((){

          showAvailableOnly = value;

        });

      },

    ),

  ],

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
const Text(
  "Legend",
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Wrap(
  spacing: 20,
  children: const [

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.square, color: Colors.green),
        SizedBox(width: 5),
        Text("Available"),
      ],
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.square, color: Colors.red),
        SizedBox(width: 5),
        Text("Occupied"),
      ],
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.square, color: Colors.blue),
        SizedBox(width: 5),
        Text("Recommended"),
      ],
    ),
  ],
),

const SizedBox(height: 20),

Card(
  elevation: 4,

  child: SizedBox(
    height: 350,
child:Container(
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(10),
  ),
    child: Stack(

  children: [

    Positioned(
      top: 10,
      left: 20,
      child: Text(
        "🚪 Entrance",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    ),

    Positioned(
      top: 160,
      left: 0,
      right: 0,
      child: Container(
        height: 35,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Text(
          "Driving Lane",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    Positioned(
      bottom: 10,
      left: 20,
      child: Text(
        recommendation!.parking.zone,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ),

    ...parkingMap
    .where(
      (slot) =>
          slot.floor == selectedFloor &&
          (!showAvailableOnly ||
           slot.status == "available"),
    )
        .map<Widget>((slot) {

      Color color;

      if (slot.status == "available") {
        color = Colors.green;
      } else {
        color = Colors.red;
      }

      if (recommendation != null &&
          recommendation!.parking.slotNumber == slot.slotNumber) {
        color = Colors.blue;
      }
      final bool isRecommended =
    recommendation!.parking.slotNumber == slot.slotNumber;

      return Positioned(
  left: (slot.xCoordinate * 8.0) - 20,
  top: (slot.yCoordinate * 6.0) - 20,

  child: GestureDetector(

    onTap: () {

      setState(() {

        selectedSlot = slot;

      });

    },

        child: Container(
          width: 60,
          height: 45,

          decoration: BoxDecoration(

  color: color,

  borderRadius: BorderRadius.circular(8),


  border: selectedSlot != null &&
          selectedSlot!.slotNumber == slot.slotNumber

      ? Border.all(
          color: Colors.yellow,
          width: 4,
        )

      : isRecommended
          ? Border.all(
              color: Colors.blueAccent,
              width: 3,
            )

          : null,


  boxShadow:

      selectedSlot != null &&
              selectedSlot!.slotNumber == slot.slotNumber

          ? [

              BoxShadow(
                color: Colors.yellow.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 3,
              )

            ]

          : isRecommended

              ? [

                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 4,
                  )

                ]

              : null,

),

          child: Stack(
  alignment: Alignment.center,

  children: [

    Text(
      slot.slotNumber,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),


    if (isRecommended)

      const Positioned(
        top: -10,
        right: -5,

        child: Text(
          "⭐",
          style: TextStyle(
            fontSize: 18,
          ),
        ),

      ),

  ],
),
        ),
  )
      );

    }),

  ],

),
  ),

  ),

),


const SizedBox(height: 20),
if (selectedSlot != null)

  Card(

    elevation: 6,

    color: Colors.white,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),

    child: Padding(

      padding: const EdgeInsets.all(16),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(

            "🚗 Selected Parking Slot",

            style: TextStyle(

              fontSize: 18,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 15),


          Center(

            child: Text(

              selectedSlot!.slotNumber,

              style: const TextStyle(

                fontSize: 45,

                fontWeight: FontWeight.bold,

                color: Colors.blue,

              ),

            ),

          ),


          const SizedBox(height: 10),


          Text(

            selectedSlot!.status == "available"

                ? "🟢 Available"

                : "🔴 Occupied",

            style: TextStyle(

              fontSize: 17,

              color: selectedSlot!.status == "available"

                  ? Colors.green

                  : Colors.red,

              fontWeight: FontWeight.bold,

            ),

          ),


          const SizedBox(height: 8),


          Text(

            "🏢 Floor ${selectedSlot!.floor}",

            style: const TextStyle(

              fontSize: 16,

            ),

          ),


          Text(

            "📍 Zone ${selectedSlot!.zone}",

            style: const TextStyle(

              fontSize: 16,

            ),

          ),


          const SizedBox(height: 15),


          SizedBox(

            width: double.infinity,

            child: ElevatedButton.icon(

              onPressed: selectedSlot!.status == "available"

                  ? () {

                      ScaffoldMessenger.of(context)

                          .showSnackBar(

                        SnackBar(

                          content: Text(

                            "Slot ${selectedSlot!.slotNumber} reserved!",

                          ),

                        ),

                      );

                    }

                  : null,


              icon: const Icon(

                Icons.bookmark,

              ),


              label: const Text(

                "Reserve Slot",

              ),

            ),

          ),

        ],

      ),

    ),

  ),
      Card(

  elevation: 5,

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),

  child: Padding(

    padding: const EdgeInsets.all(18),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(

          "🧭 Navigation",

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

          ),

        ),


        const SizedBox(height: 15),



        ...recommendation!.navigation
            .asMap()
            .entries
            .map<Widget>((entry) {


          int index = entry.key;

          String step = entry.value;


          return Padding(

            padding:
                const EdgeInsets.only(bottom: 15),


            child: Row(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [


                Column(

                  children: [


                    CircleAvatar(

                      radius: 16,

                      backgroundColor:
                          index == recommendation!.navigation.length - 1

                              ? Colors.green

                              : Colors.blue,


                      child: Icon(

                        index == recommendation!.navigation.length - 1

                            ? Icons.flag

                            : Icons.arrow_forward,

                        color: Colors.white,

                        size: 18,

                      ),

                    ),



                    if(index != recommendation!.navigation.length - 1)

                    Container(

                      width: 2,

                      height: 35,

                      color: Colors.blue.shade200,

                    ),

                  ],

                ),



                const SizedBox(width: 15),



                Expanded(

                  child: Text(

                    step,

                    style: const TextStyle(

                      fontSize: 16,

                      fontWeight: FontWeight.w500,

                    ),

                  ),

                ),


              ],

            ),

          );


        }),

      ],

    ),

  ),

),


      


      const SizedBox(height: 20),


      ElevatedButton.icon(

        onPressed: () {
  loadRecommendation();
  loadAvailability();
  loadParkingMap();
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