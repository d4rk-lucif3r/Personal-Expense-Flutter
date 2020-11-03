import 'package:flutter/material.dart';

Widget wrapWithBanner(Widget child) {
  return Banner(
    child: child,
    location: BannerLocation.topStart,
    message: 'LuCiFeR',
    color: Colors.grey.withOpacity(0.6),
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12.0,
      letterSpacing: 1.0,
      fontFamily: 'OpenSans',
      
    ),
    textDirection: TextDirection.ltr,
  );
}
