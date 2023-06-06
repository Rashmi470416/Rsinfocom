import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/display_utils.dart';
import '../constant/image_const.dart';
import '../model/profile_res.dart';
import '../resources/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String? _namePref;
String? _locationPref; 
String? _emailPref;
String? _dobPref;
String? _regPref;
String? _imagePref;

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileRes ? _profileRes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Screen",
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               vGap(85),
              profileData(),
            
              ElevatedButton(onPressed: thedataFromProfile, child: Text("tap"))
            ],
          ),
        ),
      ),
    );
  }



   thedataFromProfile() async {
    var ProfileReportUrl =
        "https://randomuser.me/api/";

    Response ProfileReportResponse = await Dio().get(
      ProfileReportUrl,
    );
    final profilereportResult = ProfileRes.fromJson(ProfileReportResponse.data);
    print(ProfileReportResponse);
    setState(() {
      _profileRes = profilereportResult;
    });
  }
  

 Widget profileData() {
    return ListView.builder(
        itemCount: 1,
        // _profileRes?.results?.length ?? 0,
        shrinkWrap: true,
        primary: false,
        itemBuilder: ((context, index) {
          final attendanceReport = _profileRes?.results?[index];
          return 
             Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

              Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  ImageConstant.empProfilePng,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 80,
                  top: -80,
                  child:
                       CircleAvatar(
                        radius:84,
                        child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                NetworkImage(
                                  attendanceReport?.picture?.medium.toString() ?? "",
                                  ),
                          ),
                      ),
                ),
                Stack(
                  children: [
                    vGap(50),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 85, horizontal: 16),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                vGap(25),
                                Row(
                                  children: [
                                    hGap(10),
                                    const Text(
                                      "Name:",
                                      style: TextStyle(
                                          color: cWhiteColor, fontSize: 16),
                                    ),
                                    hGap(10),
                                    Text(
                                      attendanceReport?.name?.first ?? "",
                                      style: const TextStyle(
                                          color: cYellowColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                vGap(8),
                                Row(
                                  children: [
                                    hGap(10),
                                    const Text(
                                      "Location:",
                                      style: TextStyle(
                                          color: cWhiteColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16),
                                    ),
                                    hGap(10),
                                    Text(
                                      attendanceReport?.location?.street?.name ?? "",
                                        style: const TextStyle(
                                            color: cWhiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16))
                                  ],
                                ),
                                vGap(8),
                                Row(
                                  children: [
                                    hGap(6),
                                    const Text(
                                      "Email:",
                                      style: TextStyle(
                                          color: cWhiteColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16),
                                    ),
                                    hGap(2),
                                    Text(
                                      attendanceReport?.email ?? "",
                                        style: const TextStyle(
                                            color: cWhiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16))
                                  ],
                                ),
                                vGap(8),
                                Row(
                                  children: [
                                    hGap(10),
                                    const Text(
                                      "DOB:",
                                      style: TextStyle(
                                          color: cWhiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    hGap(10),
                                    Text(
                                      attendanceReport?.dob?.age.toString() ?? "",
                                        style: const TextStyle(
                                            color: cWhiteColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16))
                                  ],
                                ),
                                vGap(8),
                                Row(
                                  children: [
                                    hGap(10),
                                    const Text(
                                      "Registered :  ",
                                      style: TextStyle(
                                          color: cWhiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    Expanded(
                                      child: Text(
                                        attendanceReport?.registered?.date ?? "",
                                          style: const TextStyle(
                                              color: cWhiteColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16)),
                                    )
                                  ],
                                ),
                                vGap(8),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

                ]),
              );
            
          
        }));
  }


}

  
