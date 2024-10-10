import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_clubess/views/FormCreate.dart';
import 'package:app_clubess/views/FormEdit.dart';
import 'package:app_clubess/views/app_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(filterData);
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://imja.adventistasumn.org/api/club'));
    if (response.statusCode == 200) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(response.body));
        filteredData = data;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  void filterData() {
    List<Map<String, dynamic>> tempData = [];
    if (searchController.text.isEmpty) {
      tempData = data;
    } else {
      tempData = data
          .where((item) =>
              item['club']
                  .toString()
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              item['estatus']
                  .toString()
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredData = tempData;
    });
  }

  void deleteClub(String id, BuildContext context) async {
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ID del club no disponible')));
      return;
    }
    String url = 'https://imja.adventistasumn.org/api/club/delete/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Club deleted successfully')));
      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete club: ${response.body}')));
    }
  }

  void openEditForm(Map<String, dynamic> club) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormEdit(club: club)),
    ).then((_) => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Buscar...',
            suffixIcon: Icon(Icons.search),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white.withAlpha(235),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormCreate()),
              ).then((_) => fetchData());
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 38,
          columns: const <DataColumn>[
            DataColumn(label: Text('Club')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('Opciones')),
          ],
          rows: filteredData
              .map((item) => DataRow(
                    cells: [
                      DataCell(Text(item['club'])),
                      DataCell(Text(item['estatus'])),
                      DataCell(Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => openEditForm(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                deleteClub(item['id_club'].toString(), context),
                          )
                        ],
                      )),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
