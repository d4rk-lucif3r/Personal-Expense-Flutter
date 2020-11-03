import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transcation.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function _deleteTx;
  TransactionList(this._userTransactions, this._deleteTx);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(children: <Widget>[
              Text(
                'No Transaction Added yet!',
                style: theme.textTheme.headline6,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  height: constraints.maxHeight * .6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ))
            ]);
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: ListTile(
                  // onLongPress: () {
                  //   _deleteTx(_userTransactions[index].id);
                  // },
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                            '\$${_userTransactions[index].amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    _userTransactions[index].title,
                    style: theme.textTheme.headline6,
                  ),
                  subtitle: Text(DateFormat('EEEE dd/MM/yyyy')
                      .format(_userTransactions[index].date)),
                  trailing: MediaQuery.of(context).size.width > 450
                      ? FlatButton.icon(
                          textColor: theme.errorColor,
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          onPressed: () {
                            _deleteTx(_userTransactions[index].id);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Deleting"),
                              duration: Duration(milliseconds: 600),
                              backgroundColor: theme.primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ));
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: theme.errorColor,
                          onPressed: () {
                            _deleteTx(_userTransactions[index].id);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Deleting"),
                              duration: Duration(milliseconds: 600),
                              backgroundColor: theme.primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ));
                          },
                        ),
                ),
              );
            },
            itemCount: _userTransactions.length,
          );
  }
}
