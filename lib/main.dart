import 'package:flutter/material.dart';

void main() => runApp(MeasuresConverterApp());

class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Measures Converter', home: MeasureConverter());
  }
}

class MeasureConverter extends StatefulWidget {
  const MeasureConverter({super.key});

  @override
  _MeasureConverterState createState() => _MeasureConverterState();
}

class _MeasureConverterState extends State<MeasureConverter> {
  final TextEditingController _valueController = TextEditingController();

  final List<String> _units = [
    'meters',
    'feet',
    'kilometers',
    'miles',
    'kilograms',
    'pounds',
  ];

  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  String _result = '';

  void _convert() {
    double value = double.tryParse(_valueController.text) ?? 0.0;
    double converted = _performConversion(value, _fromUnit, _toUnit);

    setState(() {
      _result =
          '$value $_fromUnit are ${converted.toStringAsFixed(3)} $_toUnit';
    });
  }

  double _performConversion(double value, String from, String to) {
    Map<String, double> conversionsToBase = {
      // Length
      'meters': 1.0,
      'feet': 0.3048,
      'kilometers': 1000.0,
      'miles': 1609.34,
      // Weight
      'kilograms': 1.0,
      'pounds': 0.453592,
    };

    if (!conversionsToBase.containsKey(from) ||
        !conversionsToBase.containsKey(to)) {
      return 0.0;
    }

    // Convert to base unit (meters or kilograms), then to target
    double baseValue = value * conversionsToBase[from]!;
    return baseValue / conversionsToBase[to]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measures Converter'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Value', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter value'),
            ),
            SizedBox(height: 20),
            Text('From', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _fromUnit = newValue!;
                });
              },
              items:
                  _units.map<DropdownMenuItem<String>>((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
            ),
            SizedBox(height: 10),
            Text('To', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _toUnit = newValue!;
                });
              },
              items:
                  _units.map<DropdownMenuItem<String>>((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _convert, child: Text('Convert')),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
