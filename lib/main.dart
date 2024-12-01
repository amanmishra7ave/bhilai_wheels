import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Scaffold(
        extendBodyBehindAppBar:true,
        appBar: AppBar(
          leading:IconButton(
            onPressed: (){},
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Jhola'),
          
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace:Container(
            decoration:BoxDecoration(
              gradient:LinearGradient(
                begin:Alignment.centerLeft,
                end:Alignment.centerRight,
                colors:[
                  Colors.green.withOpacity(0.5),
                  Colors.blue.withOpacity(0.7),
                  Colors.purple.withOpacity(0.7),
                ]
              ),
            )
          )
        ),
        body:BottomSheet(),
        // body: GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   initialCameraPosition: const CameraPosition(
        //     target: LatLng(0, 0),
        //     zoom: 2,
        //   ),
        //   markers: _markers.values.toSet(),
        // ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:ElevatedButton(
        child:const Text("Book the ride"),
        onPressed:(){
          showModalBottomSheet<void>(
            context:context,
            builder:(BuildContext context) {
              return Stack(
               children: [
                 GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
                  Container(
                height:200,
                color:Colors.amber,
                child:  Column(


                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
              )
              ]
              );
        
          
            }
          );
        }
      )
    );
  }
}