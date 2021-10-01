import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function tx;

  NewTransaction(this.tx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  void submitData() {
    if (_amountController.text.isEmpty) return;

    final String enteredTitle = _titleController.text;
    final double enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.tx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  onSubmitted: (_) => submitData()),
              TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => submitData()),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? ("No Date Chosen!")
                          : "Picked Date: ${DateFormat.yMd().format(_selectedDate!)}"),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            onPressed: _showDatePicker,
                            child: Text(
                              "Choose Date!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                        : TextButton(
                            onPressed: _showDatePicker,
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.purple)),
                            child: Text(
                              "Choose Date!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                  ],
                ),
              ),
              RaisedButton(
                  onPressed: submitData,
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button!.color,
                  child: Text(
                    "Add Transaction",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button!.color),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
