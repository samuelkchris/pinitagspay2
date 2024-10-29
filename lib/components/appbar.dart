import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'customInfobox.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://media.gettyimages.com/id/1392685483/video/asian-freelance-photographer-buying-a-cup-of-drink-from-local-beverages-stall.mp4?s=mp4-640x640-gi&k=20&c=scZa4xa5-UEFB6194V2rpMZy5tAf7MSqwqVDJ4I489M='))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green.withOpacity(0.3),
      expandedHeight: 220.0,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.account_circle_outlined),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Image.asset(
        'assets/images/PinniSoft Logos-01.png',
        fit: BoxFit.cover,
        height: 50,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active_outlined),
          onPressed: () {},
        ),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        centerTitle: true,
        background: CustomInfoBox(),
      ),
    );
  }
}
