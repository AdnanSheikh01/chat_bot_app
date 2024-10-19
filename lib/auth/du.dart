import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<dynamic> convertTextToImage(String prompt, BuildContext context) async {
  final url = Uri.parse('https://stablediffusionapi.com/api/v3/text2img');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer qbnqnM1EF1VfKMJBNDvWTQl1UBvGgsY6nvKDtY32Sz6jmSBJ8BUltEBaTFSD',
    },
    body: jsonEncode({
      "key": "qbnqnM1EF1VfKMJBNDvWTQl1UBvGgsY6nvKDtY32Sz6jmSBJ8BUltEBaTFSD",
      "prompt": prompt,
      "negative_prompt":
          "((out of frame)), ((extra fingers)), mutated hands, ((poorly drawn hands)), ((poorly drawn face)), (((mutation))), (((deformed))), (((tiling))), ((naked)), ((tile)), ((fleshpile)), ((ugly)), (((abstract))), blurry, ((bad anatomy)), ((bad proportions)), ((extra limbs)), cloned face, (((skinny))), glitchy, ((extra breasts)), ((double torso)), ((extra arms)), ((extra hands)), ((mangled fingers)), ((missing breasts)), (missing lips), ((ugly face)), ((fat)), ((extra legs)), anime",
      "width": "512",
      "height": "512",
      "samples": "1",
      "num_inference_steps": "20",
      "seed": null,
      "guidance_scale": 7.5,
      "webhook": null,
      "track_id": null
    }),
  );

  if (response.statusCode == 200) {
    try {
      final jsonResponse = jsonDecode(response.body);

      // Extract the image URL from the response
      if (jsonResponse['output'] != null && jsonResponse['output'].isNotEmpty) {
        final imageUrl = jsonResponse['output'][0];

        return imageUrl;
      } else {
        log('No image URL found in response: ${response.body}');
      }
    } catch (e) {
      log('Failed to parse response: $e');
    }
  } else {
    log('Request failed with status: ${response.statusCode}');
    final jsonResponse = jsonDecode(response.body);
    log('Error: ${jsonResponse['message']}');
  }
}
