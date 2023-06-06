import 'package:dio/dio.dart';
import 'package:fininfocom/Screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../model/randomImage_res.dart';
import '../resources/colors.dart';
import '../routes/app_routes.dart';
import 'blutooth_screen.dart';

class RandomImageScreen extends StatefulWidget {
  @override
  _RandomImageScreenState createState() => _RandomImageScreenState();
}

class _RandomImageScreenState extends State<RandomImageScreen> {
  RandomImageRes ? _randomImageRes;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text(
          "RandomImage Screen",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: cWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: cBgColor,
        leading: IconButton(
          icon:const  Icon(
            Icons.arrow_back,
            color: cWhiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      actions: [
        IconButton(
            icon: const Icon(Icons.bluetooth, color: cWhiteColor,),
            onPressed: () {
                // Navigator.pushNamed(context, AppRoutes.blutoothSCtreen);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  BlutoothScreen()),
              );
            },
          ),
    
      ],
        
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _randomImageRes != null
                  ? Image.network(_randomImageRes?.message.toString() ?? "")
                  : CircularProgressIndicator(),
            ),
          ),
          ElevatedButton(
            onPressed: fetchImage,
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }


    fetchImage() async {
    var randomImageUrl =
        "https://dog.ceo/api/breeds/image/random";

    Response ImageResponse = await Dio().get(
      randomImageUrl,
    );
    final randomImageResult = RandomImageRes.fromJson(ImageResponse.data);
    print(ImageResponse);
    setState(() {
      _randomImageRes = randomImageResult;
    });
  }
}
