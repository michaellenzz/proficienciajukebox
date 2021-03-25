import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:proficienciajukebox/util/api.dart';


class DialogResetPassword extends StatefulWidget {

  @override
  _DialogResetPassword createState() => _DialogResetPassword();
}

class _DialogResetPassword extends State<DialogResetPassword> {

  final _emailController = TextEditingController();
  final _passOldController = TextEditingController();
  final _passNewController = TextEditingController();


  @override
  Widget build(BuildContext context) {



    return AlertDialog(
      title: Text("Redefinir senha"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Ex: João@email.com'
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 8,),

            TextFormField(
              controller: _passOldController,
              decoration: InputDecoration(
                labelText: 'Senha antiga',
              ),
              obscureText: true,
            ),

            SizedBox(height: 8,),

            TextFormField(
              controller: _passNewController,
              decoration: InputDecoration(
                labelText: 'Nova senha',
              ),
              obscureText: true,
            ),

            SizedBox(height: 8,),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: Text("Cancelar")),
        TextButton(onPressed: (){
          AltetarSenha();
        },
            child: Text("Redefinir")),
      ],
    );
  }

  AltetarSenha() async{
    String email = _emailController.text;
    String passwordNew = _passNewController.text;
    String passwordOld = _passOldController.text;

    String passMd5 = md5.convert(utf8.encode(passwordOld)).toString();

    try {
      Response response = await Dio().get('https://crudcrud.com/api/${Api().hashCrud}/users');
      for(int i = 0; i < response.data.length; i++){
        if(response.data[i]['email'] == email && response.data[i]['password'] == passMd5){
          atualizarSenha(
              response.data[i]['_id'],
              response.data[i]['name'],
              response.data[i]['email'],
              response.data[i]['birthDate'],
              passwordNew,
          );
          return;
        }else{
          showDialog(
              context: context, builder: (context) => AlertDialog(
            title: Text('Senha incorreta!',
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

  atualizarSenha(id, name, email, birthDate, pass) async{

    String passMd5 = md5.convert(utf8.encode(pass)).toString();

    try {
      Response response = await Dio().put("https://crudcrud.com/api/${Api().hashCrud}/users/${id}",
          data: {
            'name': name,
            'email': email,
            'birthDate': birthDate,
            'password': passMd5}
        // ignore: missing_return
      );
      Navigator.pop(context);
      showDialog(
          context: context, builder: (context) => AlertDialog(
        title: Text("Senha Atualizada!"),
      ));
    } catch (e) {
      print(e);
    }
  }
}
