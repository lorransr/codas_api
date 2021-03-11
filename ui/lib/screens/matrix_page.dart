import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myanimate/model/codas_input.dart';
import 'package:myanimate/model/criteria.dart';
import 'package:myanimate/model/criteria_type.dart';
import 'package:myanimate/screens/result_page.dart';

class MatrixPage extends StatefulWidget {
  static const routeName = '/matrix';
  MatrixPage({Key key}) : super(key: key);

  @override
  _MatrixPageState createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  /// Create a Key for EditableState
  final _tableKey = GlobalKey();

  List<Criteria> _criterias = [];
  List<DataColumn> _cols = [];
  List<DataRow> _rows = [];

  /// Function to add a new row
  /// Using the global key assigined to Editable widget
  /// Access the current state of Editable
  void _addNewRow() {
    setState(() {
      _rows.add(DataRow(cells: _createEmptyCells(_cols.length)));
    });
  }

  void _removeRow() {
    setState(() {
      _rows.removeLast();
    });
  }

  List<DataCell> _createEmptyCells(int n) {
    int idx = 0;
    List<DataCell> cells = [];
    while (idx < n) {
      final controller = TextEditingController(text: "0.0");
      cells.add(
        DataCell(
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
              ],
              onFieldSubmitted: (val) {
                print(val);
              },
              validator: (val) {
                if (val.isEmpty) {
                  return "Insert data";
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            showEditIcon: false),
      );
      idx++;
    }
    return cells;
  }

  ///Print only edited rows.
  List<List<double>> _getAlternatives() {
    List<List<double>> alternatives = [];
    for (DataRow row in _rows) {
      List<double> alternative = [];
      for (DataCell cell in row.cells) {
        TextFormField form = cell.child;
        alternative.add(double.parse(form.controller.text));
      }
      alternatives.add(alternative);
    }
    return alternatives;
  }

  void _submit() {
    var alternatives = _getAlternatives();
    var threshold = 0.02;
    CodasInput input = CodasInput(_criterias, alternatives, threshold);
    Navigator.pushNamed(context, ResultPage.routeName, arguments: input);
  }

  List<DataColumn> _createCols(List<Criteria> criterias) {
    List<DataColumn> columns = [];
    for (Criteria c in criterias) {
      columns.add(
        DataColumn(
          label: Text(
            c.name,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
    return columns;
  }

  List<Criteria> _generateCriterias(int n) {
    List<Criteria> criterias = [];
    int i = 0;
    while (i < n) {
      criterias.add(
        Criteria("criteria_$i", CriteriaType.benefit, 0.0),
      );
      i++;
    }
    return criterias;
  }

  @override
  Widget build(BuildContext context) {
    _criterias = _generateCriterias(3);
    _cols = _createCols(_criterias);
    // List<Criteria> _criterias = ModalRoute.of(context).settings.arguments;
    // print("n criterias: ${_criterias.length}");
    // _cols = _criterias.map((e) => e.getColumn()).toList();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 200,
        backgroundColor: Colors.purple,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          label: Text(
            '',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text("Fill your decision matrix"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: _addNewRow,
                          icon: Icon(Icons.add_box_sharp)),
                      IconButton(
                          onPressed: _removeRow,
                          icon: Icon(Icons.remove_circle)),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Expanded(
                                child: DataTable(
                                    columns: _cols,
                                    rows: _rows,
                                    key: _tableKey))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
