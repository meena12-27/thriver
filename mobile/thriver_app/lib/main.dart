import 'package:flutter/material.dart';
import 'services/api_service.dart';

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


  @override
  void initState() {
    super.initState();
    loadRecommendation();
  }


  void loadRecommendation() async {

    final data =
        await ApiService.getRecommendation();

    setState(() {
      recommendation = data;
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
                    recommendation!["mall"],
                    style: const TextStyle(
                      fontSize:28,
                      fontWeight:FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height:30),


                  Card(

                    child: ListTile(

                      leading:
                          const Icon(Icons.local_parking),


                      title:
                          const Text(
                            "Recommended Parking",
                          ),


                      subtitle: Text(

                        "${recommendation!["parking"]["slot"]}"
                        " • Floor "
                        "${recommendation!["parking"]["floor"]}"
                        " • "
                        "${recommendation!["parking"]["zone"]}",

                      ),

                    ),

                  ),


                ],

              ),

            ),

    );

  }
}