import 'package:flutter/material.dart';

import '../models/transcation.dart';
import '../widgets/transaction_item.dart';

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
              const SizedBox(
                height: 15,
              ),
              Container(
                  alignment: Alignment.topCenter,
                  height: constraints.maxHeight * .6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ))
            ]);
          })
        : ListView(
            children: _userTransactions
                .map((tx) => TransactionItems(
                    key: ValueKey(tx.id),
                    userTransaction: tx,
                    theme: theme,
                    deleteTx: _deleteTx))
                .toList());
  }
}
