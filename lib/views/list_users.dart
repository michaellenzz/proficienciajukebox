import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proficienciajukebox/util/state_user.dart';
import 'package:proficienciajukebox/views/create_user.dart';
import 'package:proficienciajukebox/views/dialog_new_hash.dart';
import 'package:proficienciajukebox/views/home.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  var hashCrud = 'b8dd982558704805a3c52895c53916f2';



  TextStyle _styleTitle = TextStyle(fontWeight: FontWeight.w700, fontSize: 18);
  TextStyle _styleContent = TextStyle(fontWeight: FontWeight.w400, fontSize: 18);

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuários"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                StateUser().isLogged = false;
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
              },
            ),
          ],
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
        body: FutureBuilder(
          future:  getUsers(),
          builder: (c, snapshot) {
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            else
            return  ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue[100],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Nome: ', style: _styleTitle,),
                          Text(snapshot.data[index]['name'], style: _styleContent,),
                        ],
                      ),
                      Row(
                        children: [
                          Text('E-mail: ', style: _styleTitle,),
                          Text(snapshot.data[index]['email'], style: _styleContent),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Data de nascimento: ', style: _styleTitle,),
                          Text(snapshot.data[index]['birthDate'], style: _styleContent),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                              onPressed: (){
                                editUser(snapshot.data[index]);
                              },
                              icon: Icon(Icons.edit),
                              label: Text('Editar'),
                          ),
                          TextButton.icon(
                              onPressed: (){
                                deleteUser(snapshot.data[index]['_id']);
                              },
                              icon: Icon(Icons.delete),
                              label: Text('Deletar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        ));
  }

  Future getUsers() async {
    try {
      Response response = await Dio().get('https://crudcrud.com/api/$hashCrud/users');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  editUser(user){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateUser(user: user,)));
  }

  deleteUser(id)async{
    try {
      Response response = await Dio().delete('https://crudcrud.com/api/$hashCrud/users/$id');
      showDialog(
          context: context, builder: (context) => AlertDialog(
        title: Text('Apagado com sucesso!',
            style: TextStyle(color: Colors.red)),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Ok")
          ),
        ],
      ));
      setState(() {
        //atualizar lista
      });
    } catch (e) {
      print(e);
    }
  }
}