import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function editDialog;
  final Function deleteTx;

  const TransactionList(
    this.transactions,
    this.editDialog,
    this.deleteTx, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                const Text('No transactions added yet.'),
                const SizedBox(height: 20),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset('assets/images/waiting.png'),
                )
              ],
            );
          })
        : ListView(
            children: transactions
                .map(
                  (tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    editTx: editDialog,
                    deleteTx: deleteTx,
                  ),
                )
                .toList(),
          );
  }
}
