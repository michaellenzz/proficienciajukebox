import 'package:flutter/material.dart';
import 'package:proficienciajukebox/views/create_user.dart';
import 'package:proficienciajukebox/views/dialog_new_hash.dart';
import 'package:proficienciajukebox/views/list_users.dart';
import 'package:proficienciajukebox/views/login.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Proficiencia'),
        centerTitle: true,
    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => DialogNewHash());
        },
        label: const Text('Hash'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    body: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  "Login",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),

          SizedBox(height: 16,),

          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateUser()));
                },
                child: Text(
                  "Cadastre-se",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),
        ],
      )
    ),);
  }
}
