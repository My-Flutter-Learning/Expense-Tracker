import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final Function addTransaction;

  NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: (const InputDecoration(labelText: 'Title')),
              // onChanged: (value) {
              //   titleInput = value;
              // },
              controller: titleController,
            ),
            TextField(
              decoration: (const InputDecoration(labelText: 'Amount')),
              // onChanged: (val) {
              //   amountInput = val;
              // },
              controller: amountController,
            ),
            ElevatedButton(
              onPressed: () {
                addTransaction(titleController.text, double.parse(amountController.text));
              },
              child: const Text('Add transaction'),
            )
          ],
        ),
      ),
    );
  }
}
