import 'package:chores_flutter/data/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Future add(String name, double price) async {
    var productDoc = FirebaseFirestore.instance.collection("products").doc(name);
    DocumentSnapshot documentSnapshot = await productDoc.get();

    if (!documentSnapshot.exists) {
      var product = Product(
        price: price,
      );
      await productDoc.set(product.toFirestore());
    }
  }

  Future<List<Product>> search(String name) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("products")
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: name)
        .where(FieldPath.documentId, isLessThan: name + "\uf8ff")
        .limit(5)
        .get();

    return querySnapshot.docs.map((e) => Product.fromFirestore(e)).toList();
  }
}
