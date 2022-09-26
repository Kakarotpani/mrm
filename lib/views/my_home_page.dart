import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mrm/services/http_services.dart';
import 'package:mrm/utils/app_colors.dart';
import 'package:mrm/utils/app_constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Timer? timer;
  bool _isloading = true;
  List<dynamic> apiData= [];

  @override
  void initState() {
    _getBeer();
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer t) => _getBeer()
    );
    super.initState();
  }

  void _getBeer() async {
    final data = await HttpServices().getService();
    apiData = data;
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Center(
          child: Text(appBarTitle)
        )
      ),
      body: _isloading == true
      ? const Center(
          child: CircularProgressIndicator()
        )
      : ListView.builder(
        padding: const EdgeInsets.all(screenPadding),
        itemCount: apiData.length,
        itemBuilder: (context, index) {
          return Container(
            height: 80,
            margin: const EdgeInsets.all(itemPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apiData[index]['name'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: double.parse(apiData[index]['alcohol'].split("%")[0]) < 5
                    ? Colors.green
                    : Colors.red
                  ),
                ),
                const SizedBox(height: 4),
                Text("(${apiData[index]['alcohol'].toString()} alcohol)",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[900]
                  ),
                ),
                const SizedBox(height: 4),
                Text(apiData[index]['brand'].toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}