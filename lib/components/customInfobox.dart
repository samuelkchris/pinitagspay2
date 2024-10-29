import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

class CustomInfoBox extends StatelessWidget {
  const CustomInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 200,
            left: 10,
            child: GradientBall(
              colors: [
                Colors.deepOrange,
                Colors.amber,
              ],
            ),
          ),
          const Positioned(
            top: 400,
            right: 10,
            child: GradientBall(
              size: Size.square(200),
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlurryContainer(
              color: Colors.green.withOpacity(0.3),
              blur: 8,
              elevation: 6,
              height: 240,
              padding: const EdgeInsets.all(32),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/boy.jpg'),
                  ),
                  const Spacer(),
                  Text(
                    "Samuel Ssekizinvu".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      // fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        "Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "UGX 0.00",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "0771265609",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientBall extends StatelessWidget {
  final List<Color> colors;
  final Size size;
  const GradientBall({
    Key? key,
    required this.colors,
    this.size = const Size.square(150),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}
