import 'dart:convert';

import 'package:http/http.dart' as http;



class Createddata {



  Future datacreated(last_nametext, first_nametext, addresstext, gendertext, vaccine_implantedtext, agetext) async {
    final responce =
    await http.post(Uri.parse('http://192.168.254.185:8000/api/vaccinations'),
        body: jsonEncode({
          "last_name":last_nametext,
          "first_name":first_nametext,
          "address":addresstext,
          "gender":gendertext,
          "vaccine_implanted":vaccine_implantedtext,
          "age":agetext,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {

      print('Data Created Successfully');
      print(responce.body);
    } else {
      print('error from create');
    }
  }

}

