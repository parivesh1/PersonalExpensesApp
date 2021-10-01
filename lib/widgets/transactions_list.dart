import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  late final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  "No Transactions Added yet!",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/zzz.jpg",
                      fit: BoxFit.cover,
                    ))
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, value) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 5,
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                          child: Text("\$${transactions[value].amount}")),
                    ),
                  ),
                  title: Text(
                    transactions[value].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[value].date)),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? FlatButton.icon(
                          onPressed: () => deleteTx(transactions[value].id),
                          textColor: Theme.of(context).errorColor,
                          icon: Icon(Icons.delete),
                          label: Text("Delete!"))
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteTx(transactions[value].id),
                        ),
                ),
              );
            },
          );
  }
}
