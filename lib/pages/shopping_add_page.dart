import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:chores_flutter/data/shopping.dart';
import 'package:chores_flutter/widgets/spin_me.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:chores_flutter/controllers/shopping_controller.dart';

class ShoppingAddPage extends StatefulWidget {
  @override
  _ChoresAddPageState createState() => _ChoresAddPageState();
}

class _ChoresAddPageState extends State<ShoppingAddPage> with AutomaticKeepAliveClientMixin {
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();
  bool isSaving = false;

  Shopping formModel = Shopping();

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  void dispose() {
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
              onChanged: (value) {
                formModel.bought = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Proszę podać zakupiony przedmiot';
                }
                return null;
              },
            ),
            TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
                labelText: 'Cena',
                alignLabelWithHint: true,
                errorStyle: TextStyle(height: 0),
                suffixIcon: Padding(
                    padding: EdgeInsets.only(top: 18, right: 18),
                    child: Text(
                      "zł",
                      style: TextStyle(fontSize: 16),
                    )),
                suffixIconConstraints: BoxConstraints(maxWidth: 32),
              ),
              onChanged: (value) {
                formModel.price = double.parse(value);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
            ),
            marginBox,
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Data',
                    errorStyle: TextStyle(height: 0),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
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
                      lastDate: DateTime.now(),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          formModel.date = date;
                          dateController.text = DateFormat('dd.MM.yyyy').format(date).toString();
                        });
                      }
                    });
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                ),
              ],
            ),
            marginBox1,
            Row(
              children: [
                Expanded(
                  child: RaisedButton.icon(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          isSaving = true;
                        });
                        var user = userController.user;
                        formModel
                          ..user = user.uid
                          ..userDisplayName = user.displayName.split(" ").first;
                        userController.userData.sumSpent += formModel.price;
                        await Get.find<ShoppingController>().add(Shopping.from(formModel));
                        await userController.saveData();
                        formKey.currentState.reset();
                        dateController.clear();
                        formModel = Shopping();
                        setState(() {
                          isSaving = false;
                        });
                      }
                    },
                    icon: Icon(Icons.save,
                    color: Colors.white,
                      size: 20,
                    ),
                    label: SpinMe(
                      isSaving: isSaving,
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
