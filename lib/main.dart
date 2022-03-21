import 'dart:async';
import 'dart:convert';
import 'models/Post.dart';
import 'models/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Blog'),
      initialRoute: '/',
      routes: {
        '/posts': (context) => const HomePage(title:'Blog'),
      },
    );
  }
}

Future<List<Post>?> allPosts() async {
  // Map<String, String> requestHeaders = {
  //   "Access-Control-Allow-Origin":"*",
  // };

  final response = await http.get(Uri.parse('http://localhost:8080/posts'));
  List<dynamic> posts=await json.decode(response.body);
  List<Post> result=[];

  if(response.statusCode == 200) {
    for(var i=0;i<posts.length;i++) {
      result.add(Post.fromJson(posts[i]));
    }
  }else {
    throw Exception("Failed to load posts");
  }

  for(var i=0;i<result.length;i++){
      print(result[i].toString());
  }

  return result;
}

Future<Post>? getPost(int id) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin":"*",
  };

  final response = await http.get(Uri.parse('http://localhost:8080/posts/'+id.toString()));
  JsonMap posts=await json.decode(response.body);
  Post? result;

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if(response.statusCode == 200) {
    result=Post.fromJson(posts[0]);
  }else {
    throw Exception("Failed to load post");
  }

  print(result.toString());

  return result;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided  parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>?> futurePosts;
  // handlePosts(List<Post> content){
  //   for(var i=0;i<content.length;i++){
  //     print(content[i].toString());
  //   }
  // }
  @override
  void initState() {
    super.initState();
    futurePosts=allPosts();
  }

  Widget postWidgetList(List<Post> posts) {

    List<Widget> children=[];
    List<int> idList=[];

    for(var i=0;i<posts.length;i++) {
      children.add(
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostDetailPage(),


                    settings: RouteSettings(
                      arguments: IdParameter(posts[i].id),
                    ),
                  ),
                  );
                },
                child: Text(posts[i].title,style:TextStyle(fontSize:18.0,fontWeight:FontWeight.w700)))
             ),
          ],
        ),
      );

      children.add(
        Row(
          children: [
            Expanded(child: Text(posts[i].text,style:TextStyle(fontSize:12.0))),
          ],
        ),
      );

      children.add(SizedBox(height:50));
    }
    return Container(
      width:500,
      child: Column(children: children),
    );
      //child: Column(children:children),
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        //Here we take the value from the MyHomePage object that was created by
        //the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Post>?>(
          future: futurePosts,
          builder: (context,snapshot) {
            if(snapshot.hasData){

              return postWidgetList(snapshot.data!);
              ///return Text(snapshot.data![0].title);
            }else if(snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided  parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {

  late Future<Post> futurePost;
  //int id=0;

  @override
  void initState() {
    super.initState();

  }

  Widget postWidget(Post post) {
    List<Widget> children=[];

    children.add(
      Row(
        children: [
          Expanded(child:Text(post.title,style:TextStyle(fontSize:18.0,fontWeight:FontWeight.w700))),
        ],
      ),
    );

    return Container(
      width:500,
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args=ModalRoute.of(context)!.settings.arguments as IdParameter;

    return Scaffold(
      appBar:AppBar(
        title: Text('Post Detail'),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: getPost(args.id),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return postWidget(snapshot.data!);
              ///return Text(snapshot.data![0].title);
            }else if(snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        )
      ),
    );
  }
}

class IdParameter{
  final int id;

  IdParameter(this.id);
}
