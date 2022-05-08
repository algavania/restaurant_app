import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:transparent_image/transparent_image.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: const AssetImage('assets/restaurant.png'),
                  fadeInDuration: const Duration(seconds: 2),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 2)),
                  builder: (_, s) {
                    switch (s.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('');
                      default:
                        return AnimatedTextKit(animatedTexts: [
                          TypewriterAnimatedText('Cuisination', speed: const Duration(milliseconds: 100)),
                        ],totalRepeatCount: 1, onFinished: () {
                          Navigator.pushReplacementNamed(context, HomePage.routeName);
                        });
                    }
                  }
                )
              ],
            )),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
