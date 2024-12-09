import 'package:flutter/material.dart';
import 'package:flutter_simparta/core/app_export.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model Data
class UserProfile {
  final String date;
  final String event;

  UserProfile({required this.date, required this.event});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      date: json['date'],
      event: json['event'],
    );
  }
}

// Fungsi untuk Fetch Data
Future<UserProfile> fetchUserProfile() async {
  final response = await http.get(Uri.parse('https://api.example.com/userprofile'));

  if (response.statusCode == 200) {
    return UserProfile.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load user profile');
  }
}

// Widget untuk Menampilkan Data
class UserprofileItemWidget extends StatelessWidget {
  const UserprofileItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: fetchUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          final userProfile = snapshot.data!;
          return SizedBox(
            width: 280.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.maxFinite,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgRectangle21,
                        height: 180.h,
                        width: 240.h,
                        radius: BorderRadius.circular(10.h),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.img4,
                        height: 180.h,
                        width: double.maxFinite,
                        radius: BorderRadius.circular(10.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  userProfile.date,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  userProfile.event,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
