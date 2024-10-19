import 'dart:developer';
import 'dart:io';

// import 'dart:typed_data';
import 'package:chat_bot_app/auth/du.dart';
import 'package:chat_bot_app/utils/my_data.dart';
import 'package:chat_bot_app/widgets/auto_type_text.dart';
import 'package:flutter/material.dart';

// import 'package:chat_bot_app/auth/text_to_image_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  State<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  final createImage = TextEditingController();
  bool clicked = false;

  // Uint8List? generatedImage;

  String? generatedImage;

  final _key = GlobalKey<FormState>();

  Future<void> _generateImage() async {
    if (_key.currentState!.validate()) {
      setState(() {
        clicked = true;
      });

      // Uint8List? image = await convertTextToImage(createImage.text, context);
      String? image = await convertTextToImage(createImage.text, context);

      setState(() {
        generatedImage = image;
        clicked = false;
      });

      if (image == null) {
        Get.snackbar("Error", 'Failed to generate image.',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: isDarkTheme
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xff0D1B2A), Color(0xff1C2541)],
              ),
            )
          : const BoxDecoration(
              color: Color(0xFFF2F5FA),
            ),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              generatedImage != null
                  ? Container(
                      height: size.height * .5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            // image: MemoryImage(generatedImage!),

                            image: NetworkImage(generatedImage!)),
                      ),
                    )
                  : Container(
                      height: size.height * .5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Center(
                        child: AutoTypeText(
                          text: "Let's Create Something",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1,
                              color: isDarkTheme ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your prompt",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Form(
                      key: _key,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            Get.snackbar("Info", "Please Enter Something",
                                backgroundColor: isDarkTheme
                                    ? Color(0xff1C2541)
                                    : Color(0xFFF2F5FA));
                            return "";
                          }
                          return null;
                        },
                        cursorErrorColor: Colors.white,
                        controller: createImage,
                        decoration: InputDecoration(
                          hintText: 'Type a few words to describe your idea…',
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isDarkTheme ? Colors.white : Colors.black),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    isDarkTheme ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .01,
              ),
              clicked
                  ? Container(
                      height: 60,
                      width: size.width * .8,
                      decoration: BoxDecoration(
                        color: isDarkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      height: 60,
                      width: size.width * .8,
                      child: ElevatedButton.icon(
                        onPressed: _generateImage,
                        icon: Icon(Icons.generating_tokens),
                        label: const Text("Generate"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
              generatedImage != null
                  ? SizedBox(
                      height: size.height * .02,
                    )
                  : SizedBox.shrink(),
              generatedImage != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                  onPressed: _shareImage,
                                  child: Icon(
                                    Icons.share,
                                  )),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Share",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: _downloadImage,
                                child: Icon(Icons.file_download),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Download",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              generatedImage != null
                  ? SizedBox(
                      height: size.height * .05,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadImage() async {
    try {
      final bytes = (await get(Uri.parse(generatedImage!))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/image.png');
      file.writeAsBytes(bytes);
      ImageGallerySaver.saveFile(file.path, name: Utils().appName);

      Get.snackbar("Saved", "Image Saved Successfully",
          backgroundColor: Colors.green);
    } catch (e) {
      log(e.toString());
    }
  }

  void _shareImage() async {
    try {
      // Ensure generatedImage is not null or empty
      if (generatedImage == null || generatedImage!.isEmpty) {
        Get.snackbar("Error", "Image URL is invalid or empty.",
            backgroundColor: Colors.red);
        return;
      }

      // Download the image
      final response = await get(Uri.parse(generatedImage!));
      if (response.statusCode != 200) {
        Get.snackbar("Error", "Failed to download image.",
            backgroundColor: Colors.red);
        return;
      }

      // Save the image to a temporary file
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/shared_image.png'; // Name your file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this image!');
    } catch (e) {
      log(e.toString());
      Get.snackbar("Error", "An error occurred while sharing the image.",
          backgroundColor: Colors.red);
    }
  }
}
