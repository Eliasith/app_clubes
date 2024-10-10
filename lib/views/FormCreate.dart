import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormCreate extends StatefulWidget {
  const FormCreate({Key? key}) : super(key: key);

  @override
  _FormCreateState createState() => _FormCreateState();
}

class _FormCreateState extends State<FormCreate> {
  final TextEditingController _controllerClub = TextEditingController();
  final TextEditingController _controllerEstatus =
      TextEditingController(text: "Aspirante");
  final TextEditingController _controllerIglesia =
      TextEditingController(text: "500");
  final TextEditingController _controllerDistrito =
      TextEditingController(text: "30");
  final TextEditingController _controllerCampo =
      TextEditingController(text: "3");
  final TextEditingController _controllerTipo =
      TextEditingController(text: "aventureros");
  final TextEditingController _controllerNaturaleza =
      TextEditingController(text: "Regular");

  void newPost() async {
    try {
      final body = {
        "id_club": "",
        "club": _controllerClub.text,
        "tipo": _controllerTipo.text,
        "naturaleza": _controllerNaturaleza.text,
        "estatus": _controllerEstatus.text,
        "id_iglesia": _controllerIglesia.text,
        "id_distrito": _controllerDistrito.text,
        "id_campo": _controllerCampo.text,
        "f_creacion": "",
        "direccion": "",
        "correo": "",
        "telefono": "",
        "facebook": "",
        "twitter": "",
        "Instagram": "",
      };

      final response = await http.post(
        Uri.parse('https://imja.adventistasumn.org/api/club/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Club creado exitosamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al conectar con la API: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Club'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerClub,
              decoration: InputDecoration(labelText: 'Nombre del Club'),
            ),
            TextField(
              controller: _controllerTipo,
              decoration: InputDecoration(labelText: 'Tipo de Club'),
            ),
            TextField(
              controller: _controllerNaturaleza,
              decoration: InputDecoration(labelText: 'Naturaleza del Club'),
            ),
            TextField(
              controller: _controllerEstatus,
              decoration: InputDecoration(labelText: 'Estatus'),
            ),
            TextField(
              controller: _controllerIglesia,
              decoration: InputDecoration(labelText: 'ID Iglesia'),
            ),
            TextField(
              controller: _controllerDistrito,
              decoration: InputDecoration(labelText: 'ID Distrito'),
            ),
            TextField(
              controller: _controllerCampo,
              decoration: InputDecoration(labelText: 'ID Campo'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: newPost,
              child: Text('Crear Club'),
            ),
          ],
        ),
      ),
    );
  }
}
