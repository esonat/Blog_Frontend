import 'dart:async';
import 'dart:convert';
import '../models/Post.dart';
import '../models/Category.dart' as blog_category;
import '../models/BlogUser.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:dart_json_mapper/dart_json_mapper.dart';
// import 'package:path/path.dart';
//import 'auth/Registration.dart';
import '../util/CustomAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import '../screens/login_page.dart';
import '../screens/profile_page.dart';
import '../screens/register_page.dart';
import '../firebase_options.dart'; // new
import '../api/api.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  PostFormState createState() {
    return PostFormState();
  }
}

class PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  String dropdownValue = '1';

  User? user;
  BlogUser? blogUser;

  Future<List<DropdownMenuItem<String>>> categoryNames() async {
    List<blog_category.Category> categories = await allCategories();
    List<DropdownMenuItem<String>> list = [];
    List<String> names = [];

    if (categories != null) {
      for (var i = 0; i < categories.length; i++) {
        list.add(DropdownMenuItem<String>(
          value: categories[i].id.toString(),
          child: Text(categories[i].name),
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
    futureCategories = categoryNames();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String post_title = 'title';
    String text = 'text';
    String categoryID = '1';

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Container(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Title'),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        post_title = value;

                        return null;
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          post_title = value;
                        });
                      },
                      onChanged: (String? value) {
                        setState(() {
                          post_title = value!;
                        });
                      },
                    ),
                    const Text('Text'),
                    GestureDetector(
                      onTap: () {
                        if (!kIsWeb) {
                          controller.clearFocus();
                        }
                      },
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(widget.title),
                          elevation: 0,
                          actions: [
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () {
                                  if (kIsWeb) {
                                    controller.reloadWeb();
                                  } else {
                                    controller.editorController!.reload();
                                  }
                                })
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            controller.toggleCodeView();
                          },
                          child: Text(r'<\>',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              HtmlEditor(
                                controller: controller,
                                htmlEditorOptions: HtmlEditorOptions(
                                  hint: 'Your text here...',
                                  shouldEnsureVisible: true,
                                  //initialText: "<p>text content initial, if any</p>",
                                ),
                                htmlToolbarOptions: HtmlToolbarOptions(
                                  toolbarPosition:
                                      ToolbarPosition.aboveEditor, //by default
                                  toolbarType:
                                      ToolbarType.nativeScrollable, //by default
                                  onButtonPressed: (ButtonType type,
                                      bool? status, Function()? updateStatus) {
                                    print(
                                        "button '${describeEnum(type)}' pressed, the current selected status is $status");
                                    return true;
                                  },
                                  onDropdownChanged: (DropdownType type,
                                      dynamic changed,
                                      Function(dynamic)? updateSelectedItem) {
                                    print(
                                        "dropdown '${describeEnum(type)}' changed to $changed");
                                    return true;
                                  },
                                  mediaLinkInsertInterceptor:
                                      (String url, InsertFileType type) {
                                    print(url);
                                    return true;
                                  },
                                  mediaUploadInterceptor: (PlatformFile file,
                                      InsertFileType type) async {
                                    print(file.name); //filename
                                    print(file.size); //size in bytes
                                    print(file
                                        .extension); //file extension (eg jpeg or mp4)
                                    return true;
                                  },
                                ),
                                otherOptions: OtherOptions(height: 550),
                                callbacks: Callbacks(
                                    onBeforeCommand: (String? currentHtml) {
                                  print('html before change is $currentHtml');
                                }, onChangeContent: (String? changed) {
                                  print('content changed to $changed');
                                }, onChangeCodeview: (String? changed) {
                                  print('code changed to $changed');
                                }, onChangeSelection:
                                        (EditorSettings settings) {
                                  print(
                                      'parent element is ${settings.parentElement}');
                                  print('font name is ${settings.fontName}');
                                }, onDialogShown: () {
                                  print('dialog shown');
                                }, onEnter: () {
                                  print('enter/return pressed');
                                }, onFocus: () {
                                  print('editor focused');
                                }, onBlur: () {
                                  print('editor unfocused');
                                }, onBlurCodeview: () {
                                  print('codeview either focused or unfocused');
                                }, onInit: () {
                                  print('init');
                                },
                                    //this is commented because it overrides the default Summernote handlers
                                    /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                                    onImageUploadError: (FileUpload? file,
                                        String? base64Str, UploadError error) {
                                  print(describeEnum(error));
                                  print(base64Str ?? '');
                                  if (file != null) {
                                    print(file.name);
                                    print(file.size);
                                    print(file.type);
                                  }
                                }, onKeyDown: (int? keyCode) {
                                  print('$keyCode key downed');
                                  print(
                                      'current character count: ${controller.characterCount}');
                                }, onKeyUp: (int? keyCode) {
                                  print('$keyCode key released');
                                }, onMouseDown: () {
                                  print('mouse downed');
                                }, onMouseUp: () {
                                  print('mouse released');
                                }, onNavigationRequestMobile: (String url) {
                                  print(url);
                                  return NavigationActionPolicy.ALLOW;
                                }, onPaste: () {
                                  print('pasted into editor');
                                }, onScroll: () {
                                  print('editor scrolled');
                                }),
                                plugins: [
                                  SummernoteAtMention(
                                      getSuggestionsMobile: (String value) {
                                        var mentions = <String>[
                                          'test1',
                                          'test2',
                                          'test3'
                                        ];
                                        return mentions
                                            .where((element) =>
                                                element.contains(value))
                                            .toList();
                                      },
                                      mentionsWeb: ['test1', 'test2', 'test3'],
                                      onSelect: (String value) {
                                        print(value);
                                      }),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.undo();
                                      },
                                      child: Text('Undo',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.clear();
                                      },
                                      child: Text('Reset',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () async {
                                        var txt = await controller.getText();
                                        if (txt.contains('src=\"data:')) {
                                          txt =
                                              '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                                        }
                                        setState(() {
                                          result = txt;
                                        });
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () {
                                        controller.redo();
                                      },
                                      child: Text(
                                        'Redo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(result),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.disable();
                                      },
                                      child: Text('Disable',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () async {
                                        controller.enable();
                                      },
                                      child: Text(
                                        'Enable',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () {
                                        controller.insertText('Google');
                                      },
                                      child: Text('Insert Text',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () {
                                        controller.insertHtml(
                                            '''<p style="color: blue">Google in blue</p>''');
                                      },
                                      child: Text('Insert HTML',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () async {
                                        controller.insertLink('Google linked',
                                            'https://google.com', true);
                                      },
                                      child: Text(
                                        'Insert Link',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () {
                                        controller.insertNetworkImage(
                                            'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png',
                                            filename: 'Google network image');
                                      },
                                      child: Text(
                                        'Insert network image',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.addNotification(
                                            'Info notification',
                                            NotificationType.info);
                                      },
                                      child: Text('Info',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.addNotification(
                                            'Warning notification',
                                            NotificationType.warning);
                                      },
                                      child: Text('Warning',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () async {
                                        controller.addNotification(
                                            'Success notification',
                                            NotificationType.success);
                                      },
                                      child: Text(
                                        'Success',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () {
                                        controller.addNotification(
                                            'Danger notification',
                                            NotificationType.danger);
                                      },
                                      child: Text(
                                        'Danger',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.blueGrey),
                                      onPressed: () {
                                        controller.addNotification(
                                            'Plaintext notification',
                                            NotificationType.plaintext);
                                      },
                                      child: Text('Plaintext',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).accentColor),
                                      onPressed: () async {
                                        controller.removeNotification();
                                      },
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // TextFormField(
                    //   maxLines: 8,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter some text';
                    //     }
                    //     text = value;
                    //     return null;
                    //   },
                    //   onChanged: (String? value) {
                    //     setState(() {
                    //       text = value!;
                    //     });
                    //   },
                    //   onFieldSubmitted: (value) {
                    //     setState(() {
                    //       text = value;
                    //     });
                    //   },
                    // ),
                    FutureBuilder(
                      future: futureCategories,
                      builder: (context, snapshot) {
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
                            items: snapshot.data!
                                as List<DropdownMenuItem<String>>,
                            // items: <String>['One', 'Two', 'Free', 'Four']
                            //     .map<DropdownMenuItem<String>>((String value) {
                            //   return DropdownMenuItem<String>(
                            //     value: value,
                            //     child: Text(value),
                            //   );
                            // }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return const CircularProgressIndicator();
                      },
                    ),
                    FutureBuilder(
                      future: getBlogUserByUsername(user!.displayName!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          blogUser = snapshot.data as BlogUser;
                          return Text('${blogUser!.username}');
                        } else if (snapshot.hasError) {
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
                            //  print('Before post.Title:'+title+'Text:'+text+'Category:'+dropdownValue);
                            Post post = Post(
                                title: post_title,
                                text: text,
                                category: int.parse(dropdownValue),
                                blogUser: blogUser!.id!);

                            futurePost = addPost(post);
                            print('Added post with title:' + post_title);
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed('/posts');
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
          ),
        ),
      ),
    );
  }
}
