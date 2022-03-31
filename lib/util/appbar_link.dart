import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_page.dart';

String? getCurrentRoute(BuildContext context) {
  var route = ModalRoute.of(context);

  if (route != null) {
    print("Current Route:" + route.settings.name!);
    return route.settings.name;
  }

  return null;
}

Widget header_link(BuildContext context, String text) {
  String route = '/login';

  switch (text) {
    case 'Blog':
      route = '/posts';
      break;
    case 'Create Post':
      route = '/createPost';
      break;
    case 'Create Category':
      route = '/createCategory';
      break;
    case 'Sign Out':
      route = '/login';
      break;
    case 'Login':
      route = '/login';
      break;
  }

  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: TextButton(
      child: Text(text,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 18.0, color: Colors.white)),
      onPressed: () {
        String? currentRoute = getCurrentRoute(context);
        if (currentRoute != route) {
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PostForm()));
      },
    ),
  );
}
