import 'package:flutter/material.dart';

class TransactionsDataPlaceholder extends StatelessWidget {
  final String text;

  TransactionsDataPlaceholder({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      ),
    );
  }
}
