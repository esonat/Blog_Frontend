import 'dart:async';
import 'dart:convert';
import 'models/Post.dart';
import 'models/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_json_mapper/dart_json_mapper.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:const HomePage(title:'Blog'),
      //  body: const HomePage(title: 'Blog'),
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
    //  home: const HomePage(title: 'Blog'),
      initialRoute: '/',
      routes: {
        '/posts': (context) => const HomePage(title:'Blog'),
        '/createPost': (context) => const PostForm(),
      },
    );
  }
}

class HeaderWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
      title: const Text('Blog'),
      actions: <Widget>[
        TextButton(
          child: const Text('Create Post',style: TextStyle(fontSize: 18.0, color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostForm()));
          },
        ),
      ],
    ),
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

Future<Post>? getPost(int? id) async {
  Map<String, String> requestHeaders = {
    "Access-Control-Allow-Origin":"*",
  };

  final response = await http.get(Uri.parse('http://localhost:8080/posts/'+id.toString()));
  dynamic post=await json.decode(response.body) as dynamic;
  Post? result;

  // if(response.statusCode == 200) {
  //   for(var i=0;i<posts.length;i++) {
  //     result.add(Post.fromJson(posts[i]));
  //   }
  // }else {
  //   throw Exception("Failed to load posts");
  // }

  if(response.statusCode == 200) {
    result=Post.fromJson(post);
  }else {
    throw Exception("Failed to load post");
  }

  print(result.toString());

  return result;
}

Future<List<Category>> allCategories() async {
  final response = await http.get(Uri.parse('http://localhost:8080/categories'));
  List<dynamic> categories=await json.decode(response.body);
  List<Category> result=[];

  if(response.statusCode == 200) {
    for(var i=0;i<categories.length;i++) {
      result.add(Category.fromJson(categories[i]));
    }
  }else {
    throw Exception("Failed to load categories");
  }

  for(var i=0;i<result.length;i++){
      print(result[i].toString());
  }

  return result;
}

Future<Post> addPost(Post post) async {
  // Map<String, String> requestHeaders = {
  //   "Access-Control-Allow-Origin":"*",
  // };
  Map<String,dynamic> jsonBody={"ID":"5","Title":"title","Text":"text","Category":"1"};

  final response = await http.post(
    Uri.parse('http://localhost:8080/posts'),
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: jsonEncode(<String, dynamic>{
      'Title':post.title,
      'Text':post.text,
      'Category':post.category
    }),
  );

    print(jsonEncode(<String, dynamic>{
      'Title':post.title,
      'Text':post.text,
      'Category':post.category
    }));
    //jsonEncode(post));

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    }else {
      throw Exception("Failed to add post");
    }
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

  FutureOr onGoBack(dynamic value) {
    setState((){});
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
                ).then(onGoBack);
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
        actions: <Widget>[
          TextButton(
            child: const Text('Create Post',style: TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostForm()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
      Column(
        children: [
            Row(children: [
              Expanded(
                child: Text(post.title,style:TextStyle(fontSize:18.0,fontWeight:FontWeight.w700))
              ),
            ],
          ),
          const SizedBox(height:50),
            Row(children: [
              Expanded(
                child: Text(post.text,style:TextStyle(fontSize:14.0,fontWeight:FontWeight.w300)),
                ),
              ],
            ),
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
  final int? id;

  IdParameter(this.id);
}



class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  PostFormState createState() {
    return PostFormState();
  }
}

class PostFormState extends State<PostForm> {
  final _formKey=GlobalKey<FormState>();

  String dropdownValue='1';

  Future<List<DropdownMenuItem<String>>> categoryNames() async {
    List<Category> categories=await allCategories();
    List<DropdownMenuItem<String>> list=[];
    List<String> names=[];

    if(categories!=null){
      for(var i=0;i<categories.length;i++) {
        list.add(DropdownMenuItem<String>(
          value:categories[i].id.toString(),
          child:Text(categories[i].name),
        ));

        names.add(categories[i].name);
      }
    }

    return list;


    //
    // items: <String>['One', 'Two', 'Free', 'Four']
    //     .map<DropdownMenuItem<String>>((String value) {
    //   return DropdownMenuItem<String>(
    //     value: value,
    //     child: Text(value),
    //   );
    // }).toList(),
      // return names.map<DropdownMenuItem<String>>((String value){
      //   return DropdownMenuItem<String>(
      //     value: value,
      //     child: Text(value),
      //   );
      // }).toList();
  }



  late Future<List<DropdownMenuItem<String>>> futureCategories;
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futureCategories=categoryNames();
  }

  @override
  Widget build(BuildContext context) {
    String title='title';
    String text='text';
    String categoryID='1';

    return Scaffold(
      body: Form(
      key: _formKey,
      child: Container(
        width:500,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Title'),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title';
              }
              title=value;

              return null;
            },
            onFieldSubmitted: (value) {
              setState(() {
                title=value;
              });
            },
            onChanged: (String? value){
              setState(() {
                title=value!;
              });
            },
          ),
          const Text('Text'),
          TextFormField(
            maxLines:8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              text=value;
              return null;
            },
            onChanged: (String? value){
              setState(() {
                text=value!;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                text=value;
              });
            },
          ),
          FutureBuilder(
            future: futureCategories,
            builder:  (context, snapshot) {
              if (snapshot.hasData) {
                return DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: snapshot.data! as List<DropdownMenuItem<String>>,
                // items: <String>['One', 'Two', 'Free', 'Four']
                //     .map<DropdownMenuItem<String>>((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),
          );
        } else if(snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')),
                  //   );
                  print('Before post.Title:'+title+'Text:'+text+'Category:'+dropdownValue);
                  Post post=Post(title:title,text:text,category:int.parse(dropdownValue));

                  futurePost=addPost(post);
                  print('Added post with title:'+title);
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomePage(title:'Blog')));
                }
              },
              child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
