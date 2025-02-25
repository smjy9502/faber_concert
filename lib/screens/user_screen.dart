import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';

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
      final listResult = await Amplify.Storage.list();
      if (listResult.items.isNotEmpty) { // StorageListResult.items 사용
        final item = listResult.items.first; // StorageListResult.items 사용
        final getUrlResult = await Amplify.Storage.getUrl(key: item.key);
        setState(() {
          _imageUrl = getUrlResult.url.toString();
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        final key = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final uploadFileResult = await Amplify.Storage.uploadFile(
          key: key,
          local: imageFile, // local 파라미터 사용
        );
        print('Successfully uploaded image: ${uploadFileResult.key}');

        final getUrlResult = await Amplify.Storage.getUrl(key: uploadFileResult.key);
        setState(() {
          _imageUrl = getUrlResult.url.toString();
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
                            onPressed: () {},
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
