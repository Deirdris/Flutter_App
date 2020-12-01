import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import 'package:provider/provider.dart';

class ShoppingAddPage extends StatefulWidget {
  @override
  _ChoresAddPageState createState() => _ChoresAddPageState();
}

class _ChoresAddPageState extends State<ShoppingAddPage> with AutomaticKeepAliveClientMixin{
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  final formModel = ShoppingModel();

  void unfocus(){
    FocusScopeNode currentFocus = FocusScope.of(context);

    if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  void dispose(){
    dateController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    SizedBox marginBox = SizedBox(height: 16);
    SizedBox marginBox1 = SizedBox(height: 64);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Co zostało kupione',
                alignLabelWithHint: true,
              ),
              textInputAction: TextInputAction.next,
              maxLength: 50,
              onChanged: (value){
                formModel.bought = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cena',
                alignLabelWithHint: true,
              ),
              onChanged: (value){
                formModel.price = int.parse(value);
              },
            ),
            marginBox,
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextField(
                  enabled: false,
                  controller: dateController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Data',
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity(vertical: -3),
                  padding: EdgeInsets.zero,
                  splashRadius: 24,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2222),
                    ).then((date) {
                      if(date != null) {
                        setState(() {
                          formModel.date = date;
                          dateController.text = DateFormat('dd.MM.yyyy').format(date).toString();
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.calendar_today, size: 20,),
                ),
              ],
            ),
            marginBox1,
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Provider.of<CartModel>(context, listen: false).add(ShoppingModel.from(formModel));
                      formKey.currentState.reset();
                      dateController.clear();
                    },
                    child: Text(
                      'Dodaj',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}