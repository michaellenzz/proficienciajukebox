import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proficienciajukebox/util/state_user.dart';
import 'package:proficienciajukebox/views/dialog_new_hash.dart';
import 'package:proficienciajukebox/views/dialog_reset_password.dart';
import 'package:proficienciajukebox/views/list_users.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool isLoading;

  var hashCrud = 'b8dd982558704805a3c52895c53916f2';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
          padding: EdgeInsets.all(12),
          child: isLoading == true ? Center(child: CircularProgressIndicator(),) :
          Form(
            key: _formKey,
            child: ListView(
              children: [

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'Ex: João@email.com'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (!email.contains("@")) return "Email inválido";
                    return null;
                  },
                ),

                SizedBox(height: 8,),

                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 8,),

                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          logar();
                        }
                      },
                      child: Text(
                        "Logar",
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
                TextButton(
                    onPressed: (){
                      showDialog(
                          context: context, builder: (context) => DialogResetPassword());
                    },
                    child: Text("Altere sua senha"))
              ],
            ),
          )
      ),
    );
  }
  logar() async{
    isLoading = true;
    String email = _emailController.text;
    String password = _passController.text;

    String passMd5 = md5.convert(utf8.encode(password)).toString();

    try {
      Response response = await Dio().get('https://crudcrud.com/api/$hashCrud/users');
      for(int i = 0; i < response.data.length; i++){
        if(response.data[i]['email'] == email && response.data[i]['password'] == passMd5){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListUsers()));
          isLoading = false;
          StateUser().isLogged = true;
          return;
        }else{
          showDialog(
              context: context, builder: (context) => AlertDialog(
              title: Text('Erro ao logar',
                  style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Fechar")
                ),
              ],
          ));
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

