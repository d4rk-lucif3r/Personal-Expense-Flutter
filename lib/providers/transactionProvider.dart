import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionProvider with ChangeNotifier {
  Future<void> addTransactions(
      String txTitle, double amount, DateTime chosenDate) async {
    final url =
        'https://personal-expense-a299e-default-rtdb.firebaseio.com/transactions.json';
    final transactions = {
      'title': txTitle,
      'amount': amount.toString(),
      'date': chosenDate.toIso8601String(),
    };
    await http.post(url, body: json.encode(transactions));
    notifyListeners();
  }
}
