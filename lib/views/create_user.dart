
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:proficienciajukebox/util/state_user.dart';
import 'package:proficienciajukebox/views/dialog_new_hash.dart';
import 'dart:convert';
import 'package:proficienciajukebox/views/list_users.dart';

class CreateUser extends StatefulWidget {

  final user;

  CreateUser({this.user});

  @override
  _CreateUserState createState() => _CreateUserState(user);
}

class _CreateUserState extends State<CreateUser> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _passController = TextEditingController();
  bool isLoading;

  var hashCrud = 'b8dd982558704805a3c52895c53916f2';

  final user;
  _CreateUserState(this.user){
    isLoading = false;
    if(user != null){
      _nameController.text = user['name'];
      _emailController.text = user['email'];
      _dateController.text = user['birthDate'];
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
        padding: EdgeInsets.all(8),
        child: isLoading == true ? Center(child: CircularProgressIndicator(),) :
          Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Ex: João da Silva'
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (nome) {
                    if (nome.isEmpty) return "Digite seu nome";
                    return null;
                  },
                ),

                SizedBox(height: 8,),

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
                  controller: _dateController,
                  decoration: InputDecoration(
                      labelText: 'Data de nascimento',
                      hintText: 'Ex: 10/05/1999'
                  ),
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
                          user == null ? cadastrar() : atualizar();
                        }
                      },
                      child: Text(
                        user == null ? 'Cadastrar' : 'Atualizar',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),

              ],
            ),
          )
      ),
    );
  }
   cadastrar() async{
    isLoading = true;
    String name = _nameController.text;
    String email = _emailController.text;
    String birthDate = _dateController.text;
    String password = _passController.text;

    String passMd5 = md5.convert(utf8.encode(password)).toString();

    try {
      Response response = await Dio().post("https://crudcrud.com/api/$hashCrud/users",
          data: {
            'name': name,
            'email': email,
            'birthDate': birthDate,
            'password': passMd5}
            // ignore: missing_return
            ).then((value){
        isLoading = false;
        print("Criado com sucesso!");
        StateUser().isLogged = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListUsers()));
      });

    } catch (e) {
      print(e);
    }
  }

  atualizar() async{
    isLoading = true;
    String name = _nameController.text;
    String email = _emailController.text;
    String birthDate = _dateController.text;
    String password = _passController.text;

    String passMd5 = md5.convert(utf8.encode(password)).toString();

    try {
      Response response = await Dio().put("https://crudcrud.com/api/$hashCrud/users/${user['_id']}",
          data: {
            'name': name,
            'email': email,
            'birthDate': birthDate,
            'password': passMd5}
            // ignore: missing_return
            ).then((value) {
              isLoading = false;
              print('Atualizado com sucesso');
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListUsers()));
      });
    } catch (e) {
      print(e);
    }
  }
}
