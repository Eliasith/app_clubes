import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

// Clase para Datos
class Distrito {
  final int id;
  final String nombre;
  final int totalClubes;

  Distrito({required this.id, required this.nombre, required this.totalClubes});

  factory Distrito.fromJson(Map<String, dynamic> json) {
    return Distrito(
      id: json['id_distrito'] as int,
      nombre: json['nombre_distrito'] as String,
      totalClubes: json['total_clubes'] as int,
    );
  }
}

// LLamar Api en Grafica
class ApiService {
  Future<List<Distrito>> fetchDistritos() async {
    final response = await http
        .get(Uri.parse('https://imja.adventistasumn.org/api/grafica'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map(
              (distrito) => Distrito.fromJson(distrito as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Failed to load distritos with status code: ${response.statusCode}');
    }
  }
}

// Chart Distritos
class DistritoChart extends StatelessWidget {
  final List<Distrito> data;

  DistritoChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Distrito, String>> series = [
      charts.Series(
        id: 'Distritos',
        data: data,
        domainFn: (Distrito distrito, _) => distrito.nombre,
        measureFn: (Distrito distrito, _) => distrito.totalClubes,
        labelAccessorFn: (Distrito distrito, _) => '${distrito.totalClubes}',
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Grafica()));
}

class Grafica extends StatefulWidget {
  @override
  _GraficaState createState() => _GraficaState();
}

class _GraficaState extends State<Grafica> {
  late Future<List<Distrito>> futureDistritos;

  @override
  void initState() {
    super.initState();
    futureDistritos = ApiService().fetchDistritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Distritos'),
      ),
      body: Center(
        child: FutureBuilder<List<Distrito>>(
          future: futureDistritos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DistritoChart(data: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
