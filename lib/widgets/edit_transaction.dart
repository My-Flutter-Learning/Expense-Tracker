import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_textbutton.dart';

class EditTransacation extends StatefulWidget {
  final Transaction transaction;
  final Function editTranscation;

  const EditTransacation({
    required this.transaction,
    required this.editTranscation,
    super.key,
  });

  @override
  State<EditTransacation> createState() => _EditTransacationState();
}

class _EditTransacationState extends State<EditTransacation> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate;

  @override
  didChangeDependencies() {
    _titleController.text = widget.transaction.title;
    _amountController.text = widget.transaction.amount.toString();
    _pickedDate = widget.transaction.date;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _pickedDate == null) {
      return;
    }

    widget.editTranscation(widget.transaction.id, enteredTitle, enteredAmount, _pickedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _pickedDate = selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        TextField(
          decoration: (const InputDecoration(labelText: 'Title')),
          controller: _titleController,
          onSubmitted: (_) => _submitData(),
        ),
        TextField(
          decoration: (const InputDecoration(labelText: 'Amount')),
          controller: _amountController,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => _submitData(),
        ),
        SizedBox(
          height: 70,
          child: Row(children: <Widget>[
            Expanded(
              child: Text(
                _pickedDate == null
                    ? 'No Date Chosen!'
                    : DateFormat.yMMMd().format(_pickedDate!),
              ),
            ),
            AdaptiveTextButton('Edit Date', _presentDatePicker),
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                ),
              ),
              child: const Text('Edit'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Cancel'),
            ),
          ],
        )
      ],
    );
  }
}
