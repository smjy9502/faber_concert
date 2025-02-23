import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'photo_screen.dart';
import 'video_screen.dart';
import 'user_screen.dart';  // 새로 추가

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/concert_main.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(  // Column을 Stack으로 변경
          children: [
            Positioned(  // 'My' 버튼 추가
              top: 40,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserScreen()),
                  );
                },
                child: Text('My'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 640),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDottedButton('Photo', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhotoScreen()),
                        );
                      }),
                      const SizedBox(width: 30),
                      _buildDottedButton('Video', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VideoScreen()),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDottedButton(String text, VoidCallback onPressed) {
    return DottedBorder(
      color: Colors.white,
      strokeWidth: 2,
      dashPattern: const [5, 5],
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
// _buildDottedButton 함수는 그대로 유지
}
