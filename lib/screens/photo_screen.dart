import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildPhotoColumn(context, ['concert_photo_1', 'concert_photo_2', 'concert_photo_3']),
                Container(width: 1, color: Colors.grey[300]),
                _buildPhotoColumn(context, ['concert_photo_4', 'concert_photo_5', 'concert_photo_6']),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text('Back'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoColumn(BuildContext context, List<String> photos) {
    return Expanded(
      child: Column(
        children: [
          _buildCircularPhoto(context, photos[0], Alignment.centerLeft),
          _buildCircularPhoto(context, photos[1], Alignment.centerRight),
          _buildCircularPhoto(context, photos[2], Alignment.centerLeft),
        ],
      ),
    );
  }

  Widget _buildCircularPhoto(BuildContext context, String photo, Alignment alignment) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onTap: () => _showFullScreenImage(context, photo),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/$photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black,
              child: Center(
                child: PhotoView(
                  imageProvider: AssetImage('assets/images/$photo.jpg'),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
