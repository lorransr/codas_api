import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myanimate/model/criteria.dart';
import 'package:myanimate/model/criteria_type.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Map<String, String> _formdata = {};
  final _textController = TextEditingController();
  List<Criteria> _criteriaList = [];
  var _criteriaTypeList = <String>[
    CriteriaType.benefit.toString().split(".").last,
    CriteriaType.cost.toString().split(".").last
  ];
  int _lastRemovedPos;

  void _snackValidationError(String message) {
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[200],
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _addCriteria() {
    setState(() {
      var newCriteria =
          Criteria(_textController.text, CriteriaType.benefit, 0.0);
      if (_criteriaList.length > 0) {
        var nameSet = _criteriaList.map((e) => e.name).toSet();
        bool valueNotInSet = nameSet.add(newCriteria.name);
        if (valueNotInSet) {
          _criteriaList.add(newCriteria);
          _textController.text = '';
        } else {
          _snackValidationError("Criteria with same name already added");
        }
      } else {
        if (["", " "].contains(newCriteria.name)) {
          _snackValidationError("Criteria name must not be empty");
        } else {
          _criteriaList.add(newCriteria);
          _textController.text = '';
        }
      }
    });
  }

  void _submit() {
    int nErrors = _validateCriteriaList(_criteriaList);
    if (nErrors == 0) {
      print(_criteriaList.map((e) => e.name));
    } else {
      print("Validation Errors were found: $nErrors");
    }
  }

  int _validateCriteriaList(List<Criteria> _criteriaList) {
    var fail = 0;
    if (_criteriaList.length < 2) {
      _snackValidationError("Please Insert at least 2 Criterias");
      fail = ++fail;
    }
    if (_criteriaList.map((e) => e.weight).reduce((a, b) => a + b) != 1) {
      _snackValidationError("Criteria Weights should add up to 1");
      fail = ++fail;
    }
    return fail;
  }

  void _dismissCriteria(
      DismissDirection direction, BuildContext context, int index) {
    setState(() {
      Criteria _lastRemoved = _criteriaList[index];
      _lastRemovedPos = index;
      _criteriaList.removeAt(index);
      final snack = SnackBar(
        content: Text('Criteria \"${_lastRemoved.name}\" removed!'),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _criteriaList.insert(_lastRemovedPos, _lastRemoved);
            });
          },
        ),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    });
  }

  CriteriaType _getCriteriaType(String criteriaTypeName) {
    if (CriteriaType.benefit.toString().contains(criteriaTypeName)) {
      return CriteriaType.benefit;
    } else {
      return CriteriaType.cost;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criteria Input'),
          backgroundColor: Colors.purple,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                          labelText: 'Add a New Criteria',
                          labelStyle: TextStyle(color: Colors.grey)),
                    )),
                    ElevatedButton(
                      child: Text('Add'),
                      onPressed: _addCriteria,
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _criteriaList.length,
                    itemBuilder: itemBuilder)),
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
        ));
  }

  Widget itemBuilder(context, index) {
    int keyValue = index;
    var _dropDownValue;
    //Widget responsável por permitir dismiss
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      //A propriedade "background" representa o fundo da nossa tile, o fundo em si não possui ações
      //As ações estão no evento onDismissed
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: Card(
        child: Column(
          key: Key("$keyValue"),
          children: <Widget>[
            ListTile(
              title: Text(
                _criteriaList[index].name,
              ),
            ),
            ListTile(
              leading: Text('Type: '),
              title: DropdownButton(
                value: _dropDownValue,
                onChanged: (val) {
                  _criteriaList[index].type = _getCriteriaType(val);
                  _formdata['type_${keyValue}'] = val;
                  setState(() {
                    _dropDownValue = val;
                  });
                },
                items: _criteriaTypeList.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
            ListTile(
              leading: Text("Criteria Weight:"),
              title: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
                ],
                onChanged: (val) {
                  _criteriaList[index].weight = double.parse(val);
                  _formdata['weight_${keyValue}'] = val;
                },
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _dismissCriteria(direction, context, index);
      },
    );
  }
}
