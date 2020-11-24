import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transcation.dart';

class TransactionItems extends StatelessWidget {
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
          backgroundColor: Colors.amber,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\₹${userTransaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
          ),
        ),
        title: Text(
          userTransaction.title,
          style: theme.textTheme.headline6,
        ),
        subtitle:
            Text(DateFormat('EEEE dd/MM/yyyy').format(userTransaction.date)),
        trailing: MediaQuery.of(context).size.width > 450
            ? FlatButton.icon(
                textColor: Colors.amber,
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () {
                  deleteTx(userTransaction.id);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text("Deleting"),
                    duration: Duration(milliseconds: 600),
                  ));
                },
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.amber,
                onPressed: () {
                  deleteTx(userTransaction.id);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text("Deleting"),
                    duration: Duration(milliseconds: 600),
                  ));
                },
              ),
      ),
    );
  }
}
