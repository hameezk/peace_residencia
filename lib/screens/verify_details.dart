import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:peace_residencia/constants/colors.dart';

class VerifyDetails extends StatefulWidget {
  const VerifyDetails({Key? key}) : super(key: key);

  @override
  State<VerifyDetails> createState() => _VerifyDetailsState();
}

class _VerifyDetailsState extends State<VerifyDetails> {
  LocationData? _locationData;
  Position? position;
  String? location = '';
  String? city = '';
  String? latitude = '';
  String? longitude = '';
  TextEditingController fileNumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: BackButton(color: AppColors.lightBlueColor),
      // ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Verify File Details',
                    style: GoogleFonts.cairo(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: fileNumController,
                    style: GoogleFonts.cairo(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 18),
                      labelText: 'File Number',
                      labelStyle: GoogleFonts.cairo(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                      fillColor: Colors.white54,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 0.3),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _searchDetails(
                        context,
                        fileNumController.text.trim(),
                      );
                    },
                    child: const Text('Search Details'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchDetails(context, String id) async {
    _showLoadingDialouge(context);
    position = await getLocation(context).then((value) async {
      if (_locationData != null) {
        longitude = _locationData!.longitude.toString();
        print("location longitude: $longitude");
        latitude = _locationData!.latitude.toString();
        print("location latitude: $latitude");
      }

      // position = Position(
      //   longitude: _locationData!.longitude!,
      //   latitude: _locationData!.latitude!,
      //   timestamp: DateTime.now(),
      //   accuracy: _locationData!.accuracy!,
      //   altitude: _locationData!.altitude!,
      //   heading: _locationData!.heading!,
      //   speed: _locationData!.speed!,
      //   speedAccuracy: _locationData!.speedAccuracy!,
      // );

      // await getAddressFromLatLong(position!);
      // print("location: $location");
    });

    await getDetails(id);
  }

  void _showLoadingDialouge(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Searching For Details",
                style: GoogleFonts.cairo(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> getDetails(String id) async {
    Map formData = {"Query": id};
    var body = jsonEncode(formData);
    try {
      http.Response response = await http.post(
        Uri.parse(
            'https://peace.stellardigitaldesign.com/server/index.php/form_api/verify'),
        body: body,
      );
      print('SERVER RESPONSE: ${response.statusCode}');
      print('SERVER RESPONSE: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> mapobject = json.decode(response.body);
        var success = mapobject['Success'];
        if (success) {
          String formNum = mapobject['Details']['form_number'];
          String regNum = mapobject['Details']['registeration_number'];
          String securityNum = mapobject['Details']['security_code'];
          String plotCategory = mapobject['Details']['PlotCategory'];
          String plotSize = mapobject['Details']['PlotSize'];
          print('data Loaded');
          Navigator.pop(context);
          showDetails(
              context, formNum, regNum, plotCategory, securityNum, plotSize);
        } else {
          print('data not Loaded');
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Results Found'),
            ),
          );
        }
      } else {
        print('response code not 200');
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An Error occoured! Please try again'),
          ),
        );
      }
    } catch (e) {
      print("error ${e.toString()}");
      print("data client closed");
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An Error occoured! Please try again'),
        ),
      );
    }
  }

  Future<void> getLocation(context) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Enable Location Services for your device')));
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  void showDetails(
      context, formNum, regNum, plotCategory, securityNum, plotSize) {
    showDialog(
      context: context,
      builder: ((context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    'assets/images/bg2.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Form #: ',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '$formNum',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Registration #: ',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '$regNum',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Security Code: ',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '$securityNum',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Category: ',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '$plotCategory',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                'Plot Size: ',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkBlueColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '$plotSize',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Future<void> getAddressFromLatLong(Position position) async {
  //   List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
  //       position.latitude, position.longitude);
  //   print(placemarks);
  //   geo.Placemark place = placemarks[0];
  //   location =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   city = '${place.locality}';
  //   setState(() {});
  // }
}
