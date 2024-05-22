import 'dart:io';
import 'dart:typed_data';
import 'package:chat_zone/components/my_button.dart';
import 'package:chat_zone/components/my_text_field.dart';
import 'package:chat_zone/pages/home_page.dart';
import 'package:chat_zone/services/profile/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  XFile? imageRaw;
  Uint8List? _imageData;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      Uint8List imageData = await image!.readAsBytes();
      if (image != null) {
        setState(() {
          imageRaw = image;
          _imageData = imageData;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<Uint8List?> fetchImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();

    _profileService.getProfile().then((user) {
      var parts = user['displayName'] != null
          ? user['displayName'].toString().split(" ")
          : [];
      print(user);
      if (user != null) {
        setState(() {
          firstNameController.text = parts[0];
          lastNameController.text = parts[1];
        });
      }
    });
  }

  Future<void> _loadImage() async {
    var user = await _profileService.getProfile();
    final imageData = await fetchImageBytes(user['photoURL']);
    setState(() {
      _imageData = imageData;
    });
  }

  @override
  Widget build(BuildContext context) {
    void saveProfileItem() async {
      if (imageRaw != null) {
        Uint8List imageData = await imageRaw!.readAsBytes();

        await _profileService.saveProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          file: imageData,
        );

        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        var user = await _profileService.getProfile();
        final imageData = await fetchImageBytes(user['photoURL']);
        if (imageData != null) {
          await _profileService.saveProfile(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            file: imageData,
          );
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            ImageUploads(),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: firstNameController,
                hintText: 'First Name',
                obsecureText: false),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
                controller: lastNameController,
                hintText: 'last Name',
                obsecureText: false),
            const SizedBox(
              height: 50,
            ),
            MyButton(onTap: saveProfileItem, text: "Save Profile"),
          ],
        ),
      ),
    );
  }

  Widget ImageUploads() {
    return GestureDetector(
      onTap: () {
        _pickImage();
      },
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Color(0xffFDCF09),
        child: _imageData != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.memory(
                  _imageData!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(50)),
                width: 100,
                height: 100,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }
}
