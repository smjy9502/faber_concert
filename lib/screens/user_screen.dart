import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _imageUrl;
  final picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await Amplify.Storage.list();
      if (result.items.isNotEmpty) {
        final item = result.items.first;
        final urlResult = await Amplify.Storage.getUrl(key: item.key);
        setState(() {
          _imageUrl = urlResult.url;
        });
      }
      // Load text data (you might want to use Amplify DataStore for this)
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _saveData() async {
    try {
      // Save text data (you might want to use Amplify DataStore for this)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved successfully')),
      );
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        final key = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.private,
        );
        final result = await Amplify.Storage.uploadFile(
          local: imageFile,
          key: key,
          options: options,
        );
        print('Successfully uploaded image: ${result.key}');
        final urlResult = await Amplify.Storage.getUrl(key: result.key);
        setState(() {
          _imageUrl = urlResult.url;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (_imageUrl != null)
              Image.network(
                _imageUrl!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DottedBorder(
                              color: Colors.white,
                              strokeWidth: 1,
                              dashPattern: [5, 5],
                              child: Container(
                                width: 300,
                                child: TextField(
                                  controller: _textController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: '오래 기억하고 싶은 문장을 입력하세요.',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text('Save'),
                            onPressed: _saveData,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text('Add photo'),
                        onPressed: uploadImage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
