import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final String label;
  final double spending;
  final double spendingPctOfTotal;

  Bar(this.label, this.spending, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child:
                  FittedBox(child: Text("\$${spending.toStringAsFixed(0)}"))),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10))),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.1,
          ),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label))),
        ],
      );
    });
  }
}
