// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api/funtion.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController last_nameController = TextEditingController();
  TextEditingController first_nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController vaccine_implantedController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getdata();
    datadelete(id);
    update(id);
    obj.datacreated(last_nameController.text, first_nameController.text,addressController.text, genderController.text, vaccine_implantedController.text, ageController.text);
  }

  List data = [];
  String? id;

  Future getdata() async {
    final responce =
    await http.get(Uri.parse('http://192.168.254.185:8000/api/vaccinations'));

    if (responce.statusCode == 200) {
      setState(() {
        data = jsonDecode(responce.body);
      });
      print('Add data-> $data');
    } else {
      print('error');
    }
  }

  Future datadelete(id) async {
    final responce = await http
        .delete(Uri.parse('http://192.168.254.185:8000/api/vaccinations/$id'));
    print('outside');
    print(responce.statusCode);
    final responceShow = await http
        .get(Uri.parse('http://192.168.254.185:8000/api/vaccinations/$id'));
    print(responceShow.body);
    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
      print(responceShow.body);
    } else {
      print('Not delete!');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://192.168.254.185:8000/api/vaccinations/$id'),
        body: jsonEncode({
          "last_name":last_nameController.text,
          "first_name":first_nameController.text,
          "address":addressController.text,
          "gender":genderController.text,
          "vaccine_implanted":vaccine_implantedController.text,
          "age":ageController.text,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Successfully');
      print(responce.body);
      last_nameController.clear();
      first_nameController.clear();
      addressController.clear();
      genderController.clear();
      vaccine_implantedController.clear();
      ageController.clear();
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: last_nameController,
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                  ),
                ),
                TextField(
                  controller: first_nameController,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(
                    hintText: 'Gender',
                  ),
                ),
                TextField(
                  controller: vaccine_implantedController,
                  decoration: InputDecoration(
                    hintText: 'Vaccine Implanted',
                  ),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    hintText: 'Age',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                                last_nameController.text,
                                first_nameController.text,
                                addressController.text,
                                genderController.text,
                                vaccine_implantedController.text,
                                ageController.text
                            );
                            print('submit btn is pressed!');
                          });
                        },
                        child: Text('Submit')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            update(7);
                          });
                        },
                        child: Text('Update')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            title: Text(data[index]['last_name']),
                            subtitle: Text(data[index]['first_name']),
                            trailing: Container(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        last_nameController.text =
                                        data[index]['last_name'];
                                        first_nameController.text =
                                        data[index]['first_name'];
                                        addressController.text =
                                        data[index]['address'];
                                        genderController.text =
                                        data[index]['gender'];
                                       vaccine_implantedController.text =
                                        data[index]['vaccine_implanted'];
                                        ageController.text =
                                        data[index]['age'];
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          datadelete(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(7);
                                        });
                                      },
                                      icon: Icon(Icons.update)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
