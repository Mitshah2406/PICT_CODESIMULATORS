import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:pict_frontend/models/BioWaste.dart';
import 'package:http/http.dart' as http;
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/logging/logger.dart';

class BioWasteService {
  static Future<List<BioWaste>> getVideosResource() async {
    try {
      var response = await http.get(
        Uri.parse("${AppConstants.IP}/getVideoResources"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];

      List<BioWaste> videos = [];

      for (var videoJSON in result) {
        BioWaste video = BioWaste.fromJson(videoJSON);
        videos.add(video);
      }

      return videos;
    } catch (e) {
      print(e);
      throw Exception("Failed to get videos resource" + e.toString());
    }
  }

  static Future<List<BioWaste>> getBlogResources() async {
    try {
      var response = await http.get(
        Uri.parse("${AppConstants.IP}/getBlogResources"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      var result = jsonDecode(response.body)["result"];

      List<BioWaste> blogs = [];

      for (var blogJSON in result) {
        BioWaste blog = BioWaste.fromJson(blogJSON);
        blogs.add(blog);
      }

      return blogs;
    } catch (e) {
      print(e);
      throw Exception("Failed to get blog resource" + e.toString());
    }
  }
}
