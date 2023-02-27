import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/src/material/text_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Click Count Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Click Count Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<charts.Series<ClickData, DateTime>> _chartData = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateChartData();
    });
  }

  void _updateChartData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final clickData = ClickData(today, _counter);
    if (_chartData.isEmpty) {
      _chartData.add(
        charts.Series<ClickData, DateTime>(
          id: 'Clicks',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (ClickData clickData, _) => clickData.time,
          measureFn: (ClickData clickData, _) => clickData.count,
          data: [clickData],
        ),
      );
    } else {
      final lastData = _chartData[0].data.last;
      if (lastData.time == today) {
        _chartData[0].data.removeLast();
      }
      _chartData[0].data.add(clickData);
    }
  }

  @override
  void initState() {
    super.initState();
    _updateChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Button clicked $_counter times today:',
            ),
            SizedBox(height: 20),
            Expanded(
              child: charts.TimeSeriesChart(
                _chartData,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ClickData {
  final DateTime time;
  final int count;

  ClickData(this.time, this.count);
}
