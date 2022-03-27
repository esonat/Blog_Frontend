import 'package:flutter/material.dart';

String? getCurrentRoute(BuildContext context){
  var route=ModalRoute.of(context);

  if(route!=null){
    print("Current Route:"+route.settings.name!);
    return route.settings.name;
  }

  return null;
}
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  const CustomAppBar({Key? key}) : super(key: key);

  @override
   Size get preferredSize => const Size.fromHeight(100);

  @override
  CustomAppBarState createState() {
    return CustomAppBarState();
  }
}

 class CustomAppBarState extends State<CustomAppBar>{
  // const ({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context){
     return AppBar(
       title: MouseRegion(
         cursor: SystemMouseCursors.click,
         child: TextButton(
           child: const Text(
             'Blog',
             style: TextStyle(fontSize: 18.0,color:Colors.white)),
           onPressed: () {
             String? currentRoute=getCurrentRoute(context);
             if(currentRoute!='/posts'){
               Navigator.pushNamed(context,'/posts');
             }else{
               Navigator.pop(context);
               Navigator.pushNamed(context,'/posts');
             }
             // Navigator.push(
             //   context,
             //   MaterialPageRoute(builder: (context) => HomePage(title:'Blog')));
           },
         ),
       ),
       actions: <Widget>[
         MouseRegion(
           cursor: SystemMouseCursors.click,
           child: TextButton(
           child: const Text(
             'Create Post',
             textAlign:TextAlign.start,
             style: TextStyle(fontSize: 18.0, color: Colors.white)),
           onPressed: () {
             String? currentRoute=getCurrentRoute(context);
             if(currentRoute!='/createPost'){
               Navigator.pushNamed(context,'/createPost');
             }else{
               Navigator.pop(context);
               Navigator.pushNamed(context,'/createPost');
             }
             // Navigator.push(
             //   context,
             //   MaterialPageRoute(builder: (context) => PostForm()));
           },
         ),
       ),
       MouseRegion(
         cursor: SystemMouseCursors.click,
         child: TextButton(
         child: const Text(
           'Create Category',
           textAlign:TextAlign.start,
           style: TextStyle(fontSize: 18.0, color: Colors.white)),
         onPressed: () {
           String? currentRoute=getCurrentRoute(context);
           if(currentRoute!='/createCategory'){
             Navigator.pushNamed(context,'/createCategory');
           }else{
             Navigator.pop(context);
             Navigator.pushNamed(context,'/createCategory');
           }
           // Navigator.push(
           //   context,
           //   MaterialPageRoute(builder: (context) => PostForm()));
         },
        ),
       ),
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
       ],
     );
   }
}
