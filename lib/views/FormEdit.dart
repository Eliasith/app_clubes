import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormEdit extends StatefulWidget {
  final Map<String, dynamic> club;

  const FormEdit({Key? key, required this.club}) : super(key: key);

  @override
  _FormEditState createState() => _FormEditState();
}

class _FormEditState extends State<FormEdit> {
  final TextEditingController _controllerClub = TextEditingController();
  final TextEditingController _controllerStatus = TextEditingController();
  final TextEditingController _controllerIglesia = TextEditingController();
  final TextEditingController _controllerDistrito = TextEditingController();
  final TextEditingController _controllerCampo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerClub.text = widget.club['club'];
    _controllerStatus.text = widget.club['estatus'];
    _controllerIglesia.text = widget.club['id_iglesia'].toString();
    _controllerDistrito.text = widget.club['id_distrito'].toString();
    _controllerCampo.text = widget.club['id_campo'].toString();
  }

  Future<void> updateClub() async {
    final body = {
      "id_club": widget.club['id_club'],
      "club": _controllerClub.text,
      "estatus": _controllerStatus.text,
      "id_iglesia": _controllerIglesia.text,
      "id_distrito": _controllerDistrito.text,
      "id_campo": _controllerCampo.text,
      "tipo": widget.club['tipo'] ?? "",
      "naturaleza": widget.club['naturaleza'] ?? "",
      "f_creacion": widget.club['f_creacion'] ?? "",
      "direccion": widget.club['direccion'] ?? "",
      "correo": widget.club['correo'] ?? "",
      "telefono": widget.club['telefono'] ?? "",
      "facebook": widget.club['facebook'] ?? "",
      "twitter": widget.club['twitter'] ?? "",
      "Instagram": widget.club['Instagram'] ?? "",
    };

    try {
      final response = await http.put(
        Uri.parse(
            'https://imja.adventistasumn.org/api/club/${widget.club['id_club']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Club actualizado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error actualizando club: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Club'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerClub,
              decoration: InputDecoration(labelText: 'Nombre del Club'),
            ),
            TextField(
              controller: _controllerStatus,
              decoration: InputDecoration(labelText: 'Estado'),
            ),
            ElevatedButton(
              onPressed: updateClub,
              child: Text('Actualizar Club'),
            ),
          ],
        ),
      ),
    );
  }
}
