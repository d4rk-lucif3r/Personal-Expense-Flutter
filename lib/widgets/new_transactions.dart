import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NewTransactions extends StatefulWidget {
  final Function addTx;
  NewTransactions(this.addTx) {
    print("Newtransaction Widget Constructor");
  }

  @override
  _NewTransactionsState createState() {
    print("Newtransaction Widget createState");
    return _NewTransactionsState();
  }
}

class _NewTransactionsState extends State<NewTransactions> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  _NewTransactionsState() {
    print("Newtransaction State Constructor");
  }
  @override
  void initState() {
    super.initState();
    print("Newtransaction Widget initState");
    
  }
  @override
  void didUpdateWidget(covariant NewTransactions oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("Newtransaction Widget didUpdateState");
  }
  @override
  void dispose() {
    super.dispose();
    print("Newtransaction Widget disposeState");
  }
  
  void _addNew() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2001, 03, 05),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(20),
            )),
            margin: EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
              bottom: 5,
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                bottom: mediaQuery.viewInsets.bottom + 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    // onChanged: (value) {
                    //   titleInput = value;
                    // },
                    controller: _titleController,
                  ),
                  TextField(
                    cursorColor: Colors.black,
                    enableSuggestions: true,

                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    // onChanged: (value) {
                    //   amountInput = value;
                    // },
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _addNew(),
                    controller: _amountController,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(_selectedDate == null
                              ? 'No Date Chosen'
                              : 'Picked Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                        ),
                        FlatButton(
                          textColor: theme.buttonColor,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => {_presentDatePicker()},
                        ),
                        RaisedButton(
                          child: Text('Add Transaction'),
                          onPressed: _addNew,
                          textColor: theme.textTheme.button.color,                
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
