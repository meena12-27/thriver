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

  @override
  void initState() {
    super.initState();

    loadRecommendation();
    loadAvailability();

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
        await ApiService.getRecommendation();

    setState(() {
      recommendation = data;
    });

  }
  void loadAvailability() async {

    final data =
        await ApiService.getAvailableSlots();

    setState(() {
      availability = data;
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Thriver"),
      ),


      body: recommendation == null

          ? const Center(
              child: CircularProgressIndicator(),
            )


          : Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,


                children: [

                  const Text(
                    "Nearby Mall",
                    style: TextStyle(
                      fontSize:18,
                      color:Colors.grey,
                    ),
                  ),


                  Text(
                    recommendation!["mall"]??'Loading..',
                    style: const TextStyle(
                      fontSize:28,
                      fontWeight:FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height:30),


                  if (availability != null)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.local_parking),
                        title: const Text(
                          "Available Parking",
                        ),
                        subtitle: Text(
                          "${availability!["slots"].length} slots available",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                        Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "⭐ Recommended Parking",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "${recommendation!["parking"]["slot"]}"
                            " • Floor "
                            "${recommendation!["parking"]["floor"]}"
                            " • "
                            "${recommendation!["parking"]["zone"]??'Unknown'}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Distance: ${recommendation!["distance"]??0} m",
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                    const Text(
                      "🧭 Navigation",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ...recommendation!["navigation"]
                        .map<Widget>(
                          (step) => Text(
                            "→ $step",
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
                      label: const Text("Refresh Parking"),
                    ),


                ],

              ),

            ),

    );

  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}