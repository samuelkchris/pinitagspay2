import 'package:flutter/material.dart';

class CustomLoader {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              ModalBarrier(
                  dismissible: false, color: Colors.black.withOpacity(0.5)),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/loader.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  static void hide() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
