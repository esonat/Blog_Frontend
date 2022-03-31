import 'dart:async';
import 'dart:convert';
import '../models/Post.dart';
import '../models/Category.dart';
import '../models/BlogUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:path/path.dart';
//import 'auth/Registration.dart';
import '../util/CustomAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import '../screens/login_page.dart';
import '../screens/profile_page.dart';
import '../screens/register_page.dart';
import '../firebase_options.dart'; // new
import '../api/api.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({Key? key}) : super(key: key);

  @override
  CategoryFormState createState() {
    return CategoryFormState();
  }
}

class CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = '1';

  User? user;
  // Future<List<DropdownMenuItem<String>>> categoryNames() async {
  //   List<Category> categories=await allCategories();
  //   List<DropdownMenuItem<String>> list=[];
  //   List<String> names=[];
  //
  //   if(categories!=null){
  //     for(var i=0;i<categories.length;i++) {
  //       list.add(DropdownMenuItem<String>(
  //         value:categories[i].id.toString(),
  //         child:Text(categories[i].name),
  //       ));
  //
  //       names.add(categories[i].name);
  //     }
  //   }
  //
  //   return list;
  //
  //
  //   //
  //   // items: <String>['One', 'Two', 'Free', 'Four']
  //   //     .map<DropdownMenuItem<String>>((String value) {
  //   //   return DropdownMenuItem<String>(
  //   //     value: value,
  //   //     child: Text(value),
  //   //   );
  //   // }).toList(),
  //     // return names.map<DropdownMenuItem<String>>((String value){
  //     //   return DropdownMenuItem<String>(
  //     //     value: value,
  //     //     child: Text(value),
  //     //   );
  //     // }).toList();
  // }
  //

  //late Future<List<DropdownMenuItem<String>>> futureCategories;
  late Future<Category> futureCategory;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    //futureCategories=categoryNames();
  }

  @override
  Widget build(BuildContext context) {
    // String title='title';
    // String text='text';
    // String categoryID='1';
    String name = 'name';

    if (user == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        key: _formKey,
        child: Container(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name'),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  name = value;

                  return null;
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    name = value;
                  });
                },
                onChanged: (String? value) {
                  setState(() {
                    name = value!;
                  });
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
                      Category category = Category(name: name);

                      futureCategory = addCategory(category);
                      print('Added category with name:' + name);

                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/posts');

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
