import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/app_export.dart';

class AgendaWisataGridItemWidget extends StatelessWidget {
  const AgendaWisataGridItemWidget({Key? key}) : super(key: key);

  Future<List<Entry>> fetchAgendaWisataEntries() async {
    final response = await http.get(Uri.parse('http://demo.technophoria.co.id/simparta_pekalongan/api/rest_data?thisref=event'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Entry.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load agenda wisata entries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Entry>>(
      future: fetchAgendaWisataEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final entries = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    imagePath: entry.imagePath,
                    height: 150.h,
                    width: double.maxFinite,
                    radius: BorderRadius.circular(10.h),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    entry.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              );
            },
          );
        } else {
          return Center(child: Text('No entries found'));
        }
      },
    );
  }
}

class Entry {
  final String name;
  final String imagePath;

  Entry({required this.name, required this.imagePath});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }
}
