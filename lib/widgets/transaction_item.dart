import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transcation.dart';

class TransactionItems extends StatefulWidget {
  const TransactionItems({
    Key key,
    @required this.userTransaction,
    @required this.theme,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction userTransaction;
  final ThemeData theme;
  final Function deleteTx;

  @override
  _TransactionItemsState createState() => _TransactionItemsState();
}

class _TransactionItemsState extends State<TransactionItems> {
  Color _bgColor;
  @override
  void initState() {
    const availColors = [
      Colors.yellow,
      Colors.blue,
      Colors.amber,
      Colors.purple,
    ];
    _bgColor = availColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: ListTile(
        // onLongPress: () {
        //   _deleteTx(_userTransactions[index].id);
        // },
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child:
                  Text('\₹${widget.userTransaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                      )),
            ),
          ),
        ),
        title: Text(
          widget.userTransaction.title,
          style: widget.theme.textTheme.headline6,
        ),
        subtitle: Text(
            DateFormat('EEEE dd/MM/yyyy').format(widget.userTransaction.date)),
        trailing: MediaQuery.of(context).size.width > 450
            ? FlatButton.icon(
                textColor: Colors.amber,
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () {
                  widget.deleteTx(widget.userTransaction.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Deleting"),
                    duration: Duration(milliseconds: 600),
                  ));
                },
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.amber,
                onPressed: () {
                  widget.deleteTx(widget.userTransaction.id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Deleting"),
                    duration: Duration(milliseconds: 600),
                  ));
                },
              ),
      ),
    );
  }
}
