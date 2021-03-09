import 'package:editable/editable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myanimate/model/criteria.dart';

class MatrixPage extends StatefulWidget {
  static const routeName = '/matrix';
  MatrixPage({Key key}) : super(key: key);

  @override
  _MatrixPageState createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  /// Create a Key for EditableState
  final _editableKey = GlobalKey<EditableState>();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> _cols;

  /// Function to add a new row
  /// Using the global key assigined to Editable widget
  /// Access the current state of Editable
  void _addNewRow() {
    setState(() {
      _editableKey.currentState.createRow();
    });
  }

  ///Print only edited rows.
  void _printRows() {
    List editedRows = _editableKey.currentState.rows;
    print(editedRows);
  }

  void _submit() {
    _printRows();
  }

  List<Map<String, String>> _createRandomCols(int n_cols) {
    var i = 0;
    List<Map<String, String>> list = [];
    while (i < n_cols) {
      list.add({"title": "Test$i", "name": "test$i"});
      i++;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> _cols = _createRandomCols(10);
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
              'back to criteria creation',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
        title: Text("Insert Values to the decision matrix"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
                onPressed: () => _printRows(),
                child: Text('Print Rows',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Editable(
                        key: _editableKey,
                        columns: _cols,
                        zebraStripe: true,
                        stripeColor1: Colors.blue[50],
                        stripeColor2: Colors.grey[200],
                        onRowSaved: (value) {
                          print("saved row with values:");
                          print(value);
                        },
                        onSubmitted: (value) {
                          print(value);
                        },
                        borderColor: Colors.blueGrey,
                        tdStyle: TextStyle(fontWeight: FontWeight.bold),
                        trHeight: 80,
                        thStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        thAlignment: TextAlign.center,
                        thVertAlignment: CrossAxisAlignment.end,
                        thPaddingBottom: 0,
                        showCreateButton: true,
                        tdAlignment: TextAlign.left,
                        // tdEditableMaxLines: 100,  // don't limit and allow data to wrap
                        tdPaddingTop: 0,
                        tdPaddingBottom: 14,
                        tdPaddingLeft: 10,
                        tdPaddingRight: 8,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
          )
        ],
      ),
    );
  }
}
