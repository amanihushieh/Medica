// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, unnecessary_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/Direction_Widget.dart';
import 'package:medica_app/widgets/Doctor_List.dart';
import 'package:provider/provider.dart';

class SpecializationList extends StatelessWidget {
  final String hospitalId;
  final String hospitalName;
  final double distance;
  final double sLatitude;
  final double sLongitude;

  const SpecializationList(
      {required this.hospitalId,
      required this.hospitalName,
      required this.distance,
      required this.sLatitude,
      required this.sLongitude});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 40,
          ),
        ),
        title: Text("${AppLocalizations.of(context)?.translate('hospitalD')}"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Hospitals')
                    .doc(hospitalId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: Text('Document does not exist'),
                    );
                  }
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var name = data['Name_$locale'];
                  var photoUrl = data['Picture'];
                  int phoneNumber = data['Phone Number'];
                  var location = data['Location_$locale'];
                  double dLatitude = data['Latitude'];
                  double dLongitude = data['Longitude'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: sLatitude == 0 && sLongitude == 0
                            ? Text("")
                            : distance != double.infinity
                                ? RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${distance.toString()}${AppLocalizations.of(context)?.translate('km')} ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 58, 139, 148)),
                                        ),
                                        TextSpan(
                                            text:
                                                '${AppLocalizations.of(context)?.translate('away')}'),
                                      ],
                                    ),
                                  )
                                : Text(
                                    '${AppLocalizations.of(context)?.translate('dnotfound')}',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 58, 139, 148),
                                      fontSize: 16,
                                    ),
                                  ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DirectionWidget(
                                          sLatitude: sLatitude,
                                          sLongitude: sLongitude,
                                          dLatitude: dLatitude,
                                          dLongitude: dLongitude,
                                        )),
                              );
                            },
                            child: Text(
                              '${AppLocalizations.of(context)?.translate('getD')}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 58, 139, 148),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.location,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.phone,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                '0${phoneNumber.toString()}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Mon-Wed (10:00 AM-11:00 PM)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              DoctorList(
                hospitalId: hospitalId,
                distance: distance,
                sLatitude: sLatitude,
                sLongitude: sLongitude,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
