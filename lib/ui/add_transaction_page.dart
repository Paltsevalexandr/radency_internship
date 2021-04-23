import 'package:flutter/material.dart';

class AddTransactionPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
      ),
      body: Container(
        child: Text("Add New Transaction"),
      ),
    );
  }

}