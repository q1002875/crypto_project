import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class coinbaseApi {
  static Future<String> downloadAndSaveImage(
      String iconUrl, String symbol) async {
    final response = await http.get(Uri.parse(iconUrl));
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$symbol.png';

    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await saveImagePath(symbol, filePath);
      return filePath;
    } else {
      throw Exception('Failed to download image');
    }
  }

  static Future<Widget> fetchCoinIcon(String symbol) async {
    final response = await http.get(
      Uri.parse(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=$symbol&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136'),
    );

    if (response.statusCode == 200) {
      // 如果伺服器回傳 200 OK 響應，那麼將響應的 JSON 結構解析為字串。
      var jsonResponse = jsonDecode(response.body);
      String iconUrl = jsonResponse['data'][symbol]['logo'];

      return Image.network(iconUrl);
    } else {
      // 如果響應的狀態碼不是 200，則丟出一個異常。
      throw Exception('Failed to load icon');
    }
  }

  static Widget getImageFromPath(String symbol) {
    return FutureBuilder<String?>(
      future: getImagePath(symbol),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error: could not load image');
          } else {
            if (snapshot.data != null) {
              return Image.file(File(snapshot.data!));
            } else {
              return const Text('No image found');
            }
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  static Future<String?> getImagePath(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(symbol);
  }

  static Future<void> saveImagePath(String symbol, String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(symbol, filePath);
  }
}
