import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/CustomAppBar.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey=GlobalKey<FormState>();


    //late Future<Category> futureCategory;

  @override
  void initState() {
    super.initState();
    //futureCategories=categoryNames();
  }

  @override
  Widget build(BuildContext context) {
    // String title='title';
    // String text='text';
    // String categoryID='1';
    String email='email';
    String password='password';

    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
      key: _formKey,
      child: Container(
        width:500,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email'),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              email=value;

              return null;
            },
            onFieldSubmitted: (value) {
              setState(() {
                email=value;
              });
            },
            onChanged: (String? value){
              setState(() {
                email=value!;
              });
            },
          ),
          const Text('Password'),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              password=value;

              return null;
            },
            onFieldSubmitted: (value) {
              setState(() {
                password=value;
              });
            },
            onChanged: (String? value){
              setState(() {
                password=value!;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {

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
