import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Calculation {
  int left;
  int right;
  int result;

  Calculation(
    this.left,
    this.right,
    this.result
  );
}

class _MyHomePageState extends State<MyHomePage> {
  List<Calculation> calculations = [];

  int _currentSortColumn = 0;
  bool _isAscending = false;

  void _addCalculation() {
    setState(() {
      calculations.add(new Calculation(0, 0, 0));
    });
  }

  void calculateValue(Calculation calc) {
    if (calc.left != 0 && calc.right != 0) {

      int newVal = calc.left + calc.right;

      if (newVal != calc.result) {
        setState(() {
          calc.result = newVal;
        });
      }
    }
  }

  DataRow _buildTableRow(Calculation calculation) {
    TextEditingController leftController = new TextEditingController(text: calculation.left == 0 ? "" : calculation.left.toString());
    TextEditingController rightController = new TextEditingController(text: calculation.right == 0 ? "" : calculation.right.toString());

    leftController.addListener(() {
      if (int.tryParse(leftController.text) != null) {
        calculation.left = int.parse(leftController.text);
        calculateValue(calculation);
      }
    });

    rightController.addListener(() {
      if (int.tryParse(rightController.text) != null) {
        calculation.right = int.parse(rightController.text);
        calculateValue(calculation);
      }
    });

    return DataRow(cells: [
      DataCell(
        TextFormField(
          controller: leftController,
          keyboardType: TextInputType.number,
        ),
      ),
      DataCell(
        TextFormField(
          controller: rightController,
          keyboardType: TextInputType.number,
        )
      ),
      DataCell(
        Text(
          calculation.result.toString()
        )
      ),
    ]);
  }

  List<DataRow> _getDataTableRows() {
    List<DataRow> rows =
        calculations.map((calculation) => _buildTableRow(calculation)).toList();
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    Widget tableSection = Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          DataTable(
              sortColumnIndex: _currentSortColumn,
              sortAscending: _isAscending,
              columns: [
              DataColumn(
                label: Text('Left'),
                numeric: true,
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      calculations.sort((a, b) => a.left.compareTo(b.left));
                    } else {
                      _isAscending = true;
                      calculations.sort((b, a) => a.left.compareTo(b.left));
                    }
                  });
                }
              ),
              DataColumn(
                label: Text('Right'),
                numeric: true,
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      calculations.sort((a, b) => a.right.compareTo(b.right));
                    } else {
                      _isAscending = true;
                      calculations.sort((b, a) => a.right.compareTo(b.right));
                    }
                  });
                }
              ),
              DataColumn(
                label: Text('Result'),
                numeric: true,
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isAscending == true) {
                      _isAscending = false;
                      calculations.sort((a, b) => a.result.compareTo(b.result));
                    } else {
                      _isAscending = true;
                      calculations.sort((b, a) => a.result.compareTo(b.result));
                    }
                  });
                }
              )
            ],
            rows: _getDataTableRows(),
            columnSpacing: 5
          )
        ],
      )
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width - 10,
        child: Column(
          children: [
            tableSection,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCalculation,
        tooltip: 'Add Calculation',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
