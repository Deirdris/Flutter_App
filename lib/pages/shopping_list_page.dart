import 'package:chores_flutter/controllers/shopping_controller.dart';
import 'package:chores_flutter/data/shopping.dart';
import 'package:chores_flutter/widgets/future_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> with AutomaticKeepAliveClientMixin {
  final shoppingController = Get.put(ShoppingController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizedBox marginBox = SizedBox(height: 16);

    return FutureHandler(
      future: shoppingController.fetchFuture,
      onDone: (_) => Obx(
        () => ListView(
          children: [
            for (var shopping in shoppingController.cart) ...[
              _Shopping(shopping: shopping),
              marginBox,
            ],
          ],
        ),
      ),
    );
  }
}

class _Shopping extends StatelessWidget {
  _Shopping({
    @required this.shopping,
  });

  final Shopping shopping;

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Text(
                  shopping.bought,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                Text(
                  shopping.userDisplayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 18,
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
