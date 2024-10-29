import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAnimatedBottomNavigationBar extends StatefulWidget {
  final List<String> svgIcons;
  final Function(int) onTap;

  const CustomAnimatedBottomNavigationBar({
    super.key,
    required this.svgIcons,
    required this.onTap,
  });

  @override
  State<CustomAnimatedBottomNavigationBar> createState() =>
      _CustomAnimatedBottomNavigationBarState();
}

class _CustomAnimatedBottomNavigationBarState
    extends State<CustomAnimatedBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60.0,
      clipBehavior: Clip.antiAlias,
      shape: AutomaticNotchedShape(
        const RoundedRectangleBorder(),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
      ),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.svgIcons.map((icon) {
          int index = widget.svgIcons.indexOf(icon);
          return InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(
                    4.0), // Decrease padding to reduce size
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? Colors.blue
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(15.0), // Add border radius
                  boxShadow: [
                    // Add box shadow to make it float
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  icon,
                  color: _selectedIndex == index ? Colors.white : Colors.grey,
                ),
              ));
        }).toList(),
      ),
    );
  }
}
