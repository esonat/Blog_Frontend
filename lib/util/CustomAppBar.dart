import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_page.dart';
import 'appbar_link.dart';
import 'fire_auth.dart';

String? getCurrentRoute(BuildContext context) {
  var route = ModalRoute.of(context);

  if (route != null) {
    print("Current Route:" + route.settings.name!);
    return route.settings.name;
  }

  return null;
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  CustomAppBarState createState() {
    return CustomAppBarState();
  }
}

class CustomAppBarState extends State<CustomAppBar> {
  // const ({Key? key}) : super(key: key);
  bool _userLoggedIn = false;

  // Widget headers(BuildContext context){
  //   User? user=FirebaseAuth.instance.currentUser;
  //   if(user==null){
  //     return MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       child: TextButton(
  //         child: const Text(
  //           'Blog',
  //           style: TextStyle(fontSize: 18.0,color:Colors.white)),
  //         onPressed: () {
  //           String? currentRoute=getCurrentRoute(context);
  //           if(currentRoute!='/posts'){
  //             Navigator.pushNamed(context,'/posts');
  //           }else{
  //             Navigator.pop(context);
  //             Navigator.pushNamed(context,'/posts');
  //           }
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(builder: (context) => HomePage(title:'Blog')));
  //         },
  //       ),
  //     );
  //     actions: [
  //     //actions: <Widget>[
  //       MouseRegion(
  //         cursor: SystemMouseCursors.click,
  //         child: TextButton(
  //         child: const Text(
  //           'Create Post',
  //           textAlign:TextAlign.start,
  //           style: TextStyle(fontSize: 18.0, color: Colors.white)),
  //         onPressed: () {
  //           String? currentRoute=getCurrentRoute(context);
  //           if(currentRoute!='/createPost'){
  //             Navigator.pushNamed(context,'/createPost');
  //           }else{
  //             Navigator.pop(context);
  //             Navigator.pushNamed(context,'/createPost');
  //           }
  //           // Navigator.push(
  //           //   context,
  //           //   MaterialPageRoute(builder: (context) => PostForm()));
  //         },
  //       ),
  //     ),
  //     MouseRegion(
  //       cursor: SystemMouseCursors.click,
  //       child: TextButton(
  //       child: const Text(
  //         'Create Category',
  //         textAlign:TextAlign.start,
  //         style: TextStyle(fontSize: 18.0, color: Colors.white)),
  //       onPressed: () {
  //         String? currentRoute=getCurrentRoute(context);
  //         if(currentRoute!='/createCategory'){
  //           Navigator.pushNamed(context,'/createCategory');
  //         }else{
  //           Navigator.pop(context);
  //           Navigator.pushNamed(context,'/createCategory');
  //         }
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => PostForm()));
  //       },
  //     ),
  //   ),

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('Current user:' + user.email!);
      _userLoggedIn = true;
    }

    if (_userLoggedIn) {
      return AppBar(
        title: header_link(context, 'Blog'),
        //actions: <Widget>[
        actions: [
          //  header_link(context,'Create Post'),
          //  header_link(context,'Create Category'),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: TextButton(
              child: const Text('Sign Out',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  print('Current user email:' + user.email!);
                  await FirebaseAuth.instance.signOut();
                }
                // FireAuth.signOut(user

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return AppBar(
      //title: header_link(context,'Blog'),
      //actions: <Widget>[
      actions: [
        // header_link(context,'Create Post'),
        // header_link(context,'Create Category'),
        header_link(context, 'Login'),
      ],
    );
  }
}

     //   MouseRegion(
     //     cursor: SystemMouseCursors.click,
     //     child: TextButton(
     //     child: const Text(
     //       'Registration',
     //       textAlign:TextAlign.start,
     //       style: TextStyle(fontSize: 18.0, color: Colors.white)),
     //     onPressed: () {
     //       String? currentRoute=getCurrentRoute(context);
     //       if(currentRoute!='/registration'){
     //         Navigator.pushNamed(context,'/registration');
     //       }else{
     //         setState((){});
     //       }
     //       // Navigator.push(
     //       //   context,
     //       //   MaterialPageRoute(builder: (context) => PostForm()));
     //     },
     //   ),
     // ),


   // return AppBar(
   //   title: MouseRegion(
   //     cursor: SystemMouseCursors.click,
   //     child: TextButton(
   //       child: const Text(
   //         'Blog',
   //         style: TextStyle(fontSize: 18.0,color:Colors.white)),
   //       onPressed: () {
   //         String? currentRoute=getCurrentRoute(context);
   //         if(currentRoute!='/posts'){
   //           Navigator.pushNamed(context,'/posts');
   //         }else{
   //           Navigator.pop(context);
   //           Navigator.pushNamed(context,'/posts');
   //         }
   //         // Navigator.push(
   //         //   context,
   //         //   MaterialPageRoute(builder: (context) => HomePage(title:'Blog')));
   //       },
   //     ),
   //   ),
   //   actions: [
   //   //actions: <Widget>[
   //     MouseRegion(
   //       cursor: SystemMouseCursors.click,
   //       child: TextButton(
   //       child: const Text(
   //         'Create Post',
   //         textAlign:TextAlign.start,
   //         style: TextStyle(fontSize: 18.0, color: Colors.white)),
   //       onPressed: () {
   //         String? currentRoute=getCurrentRoute(context);
   //         if(currentRoute!='/createPost'){
   //           Navigator.pushNamed(context,'/createPost');
   //         }else{
   //           Navigator.pop(context);
   //           Navigator.pushNamed(context,'/createPost');
   //         }
   //         // Navigator.push(
   //         //   context,
   //         //   MaterialPageRoute(builder: (context) => PostForm()));
   //       },
   //     ),
   //   ),
   //   MouseRegion(
   //     cursor: SystemMouseCursors.click,
   //     child: TextButton(
   //     child: const Text(
   //       'Create Category',
   //       textAlign:TextAlign.start,
   //       style: TextStyle(fontSize: 18.0, color: Colors.white)),
   //     onPressed: () {
   //       String? currentRoute=getCurrentRoute(context);
   //       if(currentRoute!='/createCategory'){
   //         Navigator.pushNamed(context,'/createCategory');
   //       }else{
   //         Navigator.pop(context);
   //         Navigator.pushNamed(context,'/createCategory');
   //       }
   //       // Navigator.push(
   //       //   context,
   //       //   MaterialPageRoute(builder: (context) => PostForm()));
   //     },
   //    ),
   //   ),
   //   MouseRegion(
   //     cursor: SystemMouseCursors.click,
   //     child: TextButton(
   //       child: const Text(
   //         'Sign Out',
   //         textAlign:TextAlign.start,
   //         style: TextStyle(fontSize: 18.0, color: Colors.white)),
   //       onPressed: () async {
   //          User user=FirebaseAuth.instance.currentUser!;
   //          if (user != null) {
   //            await FirebaseAuth.instance.signOut();
   //          }
   //          // FireAuth.signOut(user
   //
   //           Navigator.of(context).pushReplacement(
   //             MaterialPageRoute(
   //               builder: (context) => LoginPage(),
   //             ),
   //           );
   //         // String? currentRoute=getCurrentRoute(context);
   //         // if(currentRoute!='/createCategory'){
   //         //   Navigator.pushNamed(context,'/createCategory');
   //         // }else{
   //         //   Navigator.pop(context);
   //         //   Navigator.pushNamed(context,'/createCategory');
   //         // }
   //       // Navigator.push(
   //       //   context,
   //       //   MaterialPageRoute(builder: (context) => PostForm()));
   //     },
   //    ),
   //  ),
   //
   // //   MouseRegion(
   // //     cursor: SystemMouseCursors.click,
   // //     child: TextButton(
   // //     child: const Text(
   // //       'Registration',
   // //       textAlign:TextAlign.start,
   // //       style: TextStyle(fontSize: 18.0, color: Colors.white)),
   // //     onPressed: () {
   // //       String? currentRoute=getCurrentRoute(context);
   // //       if(currentRoute!='/registration'){
   // //         Navigator.pushNamed(context,'/registration');
   // //       }else{
   // //         setState((){});
   // //       }
   // //       // Navigator.push(
   // //       //   context,
   // //       //   MaterialPageRoute(builder: (context) => PostForm()));
   // //     },
   // //   ),
   // // ),
   //   ],
   // );
