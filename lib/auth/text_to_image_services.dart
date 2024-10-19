// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// Future<Uint8List?> convertTextToImage(
//     String prompt, BuildContext context) async {
//   try {
//     String url = "https://api.vyro.ai/v1/imagine/api/generations";

//     Map<String, dynamic> payload = {'prompt': prompt, 'style_id': '29'};
//     Map<String, dynamic> headers = {
//       'Authorization':
//           'Bearer vk-Z5G0443s7kx2LD457b7D3ZJLjt5igOs1K2EVtFBeasiMI9n',
//     };
//     Dio dio = Dio();

//     dio.options =
//         BaseOptions(headers: headers, responseType: ResponseType.bytes);
//     FormData formData = FormData.fromMap(payload);
//     final response = await dio.post(url, data: formData);

//     if (response.statusCode == 200) {
//       return Uint8List.fromList(response.data);
//     } else {
//       return null;
//     }
//   } catch (e) {
//     log(e.toString());
//   }
//   return null;
// }
