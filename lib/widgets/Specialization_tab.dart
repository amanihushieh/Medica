// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_collection_literals, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/model/specialization_model.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/DoctorListS.dart';
import 'package:provider/provider.dart';

class SpecializationTab extends StatelessWidget {
  final String searchText;
  final double sLatitude;
  final double sLongitude;

  const SpecializationTab({
    required this.searchText,
    required this.sLatitude,
    required this.sLongitude,
  });

  @override
  Widget build(BuildContext context) {
     final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('Specializations')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }

        List<specializationModel> Specializations = [];
        Set<String> specializationIds = Set();

        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (!specializationIds.contains(doc['Picture'])) {
            if (data != null && data.containsKey('Picture')) {
              Specializations.add(specializationModel(
                name: doc['Name_$locale'],
                photoUrl: doc['Picture'],
                sId: doc.id,
              ));
            }
            specializationIds.add(doc['Picture']);
          }
        });
        Specializations = Specializations.where((specialization) {
          String name = specialization.name.toLowerCase();
          return name.contains(searchText.toLowerCase());
        }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < Specializations.length; i += 2)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorListS(
                                specializationName: Specializations[i].photoUrl,
                                sLatitude: sLatitude,
                                sLongitude: sLongitude,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 130,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                padding: EdgeInsets.all(10),
                                child: Image.network(
                                  Specializations[i].photoUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  Specializations[i].name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 58, 139, 148),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (i + 1 < Specializations.length)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListS(
                                  specializationName:
                                      Specializations[i + 1].photoUrl,
                                  sLatitude: sLatitude,
                                  sLongitude: sLongitude,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 130,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  padding: EdgeInsets.all(10),
                                  child: Image.network(
                                    Specializations[i + 1].photoUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    Specializations[i + 1].name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 58, 139, 148),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
