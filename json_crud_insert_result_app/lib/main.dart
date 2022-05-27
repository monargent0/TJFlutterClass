import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // property
  late TextEditingController codeController;
  late TextEditingController nameController;
  late TextEditingController deptController;
  late TextEditingController phoneController;

  late String code;
  late String name;
  late String dept;
  late String phone;
  late String result;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    nameController = TextEditingController();
    deptController = TextEditingController();
    phoneController = TextEditingController();

    result = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD insert & result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: '학번을 입력하세요'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '성명을 입력하세요'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: deptController,
                decoration: const InputDecoration(labelText: '전공을 입력하세요'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: '전화번호를 입력하세요'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    code = codeController.text;
                    name = nameController.text;
                    dept = deptController.text;
                    phone = phoneController.text;

                    insertAction();
                  },
                  child: const Text('입력')),
            ],
          ),
        ),
      ),
    );
  }

//--- Function
  Future<String> insertAction() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/student_insert_return_flutter.jsp?code=$code&name=$name&dept=$dept&phone=$phone'
        // get 방식으로 데이터 받아와서 넘기기
        );
    var response = await http.get(url);
    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
      
      if (result == 'OK') {
        _showDialog(context);
      } else {
        errorSnackBar(context);
      }
    });

    return result;
  } // insert

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('입력 결과'),
            content: const Text('입력이 완료 되었습니다.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  } //showDialog

  errorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사용자 정보 입력에 문제가 생겼습니다'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  } // error

} // end