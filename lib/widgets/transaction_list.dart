import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
      ? Column(
          children: <Widget>[
            const Text('No transactions added yet.'),
            const SizedBox(height: 20),
            SizedBox(
                height: 200,
                child: Image.asset('Assets/Images/waiting.png'))
          ],
        )
      : ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                        child: Text(
                            '\$${transactions[index].amount.toStringAsFixed(2)}')),
                  ),
                ),
                title: Text(
                  '\$${transactions[index].title}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                subtitle: Text(
                  DateFormat.yMMMMd().format(transactions[index].date),
                ),
                trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transactions[index].id)),
              ),
            );
          },
          itemCount: transactions.length,    
        );
  }
}
