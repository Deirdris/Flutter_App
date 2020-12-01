import 'package:chores_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    SizedBox marginBox = SizedBox(height: 16);

    return Consumer<CartModel>(
      builder: (context, value, child) => ListView(
        children: [
          for (var shopping in value.cart) ...[
            _Shopping(shopping: shopping),
            marginBox,
          ],
        ],
      ),
    );
  }
}

class _Shopping extends StatelessWidget {
  _Shopping({
    @required this.shopping,
  });

  final ShoppingModel shopping;

  @override
  Widget build(BuildContext context) {
    SizedBox marginBox = SizedBox(height: 16);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  shopping.bought,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                ),
              ],
            ),
            marginBox,
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cena",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    Row(
                      children: [
                        Text(shopping.price.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Text("zł",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Data kupienia",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    Text(DateFormat('dd.MM.yyyy').format(shopping.date),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
