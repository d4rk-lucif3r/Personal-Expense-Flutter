import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctTotal;
  ChartBar({
    @required this.label,
    @required this.spendingAmount,
    @required this.spendingPctTotal,
  });
  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
                height: constraints.maxHeight * .15,
                child: FittedBox(
                    child: Text('₹${spendingAmount.toStringAsFixed(0)}'))),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
              height: constraints.maxHeight * .6,
              width: constraints.maxWidth *.20,
              child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(20),
                )),
                FractionallySizedBox(
                    heightFactor: spendingPctTotal,
                    child: Container(
                        decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ))),
              ]),
            ),
            SizedBox(
              height: constraints.maxHeight * .05,
            ),
            Container(
              height: constraints.maxHeight * .15,
              child: FittedBox(child: Text(label)),
            ),
          ],
        );
      },
    );
  }
}
