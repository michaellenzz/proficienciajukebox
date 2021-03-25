import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:proficienciajukebox/util/api.dart';


class DialogNewHash extends StatefulWidget {

  @override
  _DialogNewHash createState() => _DialogNewHash();
}

class _DialogNewHash extends State<DialogNewHash> {

  final _hashController = TextEditingController();

  @override
  Widget build(BuildContext context) {



    return AlertDialog(
      title: Text("Novo Hash"),
      content: SingleChildScrollView(
        child: Column(

          children: <Widget>[
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _hashController,
              decoration: InputDecoration(
                  labelText: "Digite seu novo hash",
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: Text("Cancelar")),
        TextButton(onPressed: (){
          if(_hashController.text.isNotEmpty){
            Api().hashCrud = _hashController.text;
            Navigator.pop(context);
            showDialog(
                context: context, builder: (context) => AlertDialog(
              title: Text("Hash Atualizado!"),
            ));

          }
        },
            child: Text("Mudar")),
      ],
    );
  }
}
