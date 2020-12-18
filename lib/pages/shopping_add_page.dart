import 'package:chores_flutter/controllers/product_contoller.dart';
import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:chores_flutter/data/product.dart';
import 'package:chores_flutter/data/shopping.dart';
import 'package:chores_flutter/utils/always_disabled_focus_node.dart';
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
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();
  final productController = Get.put(ProductController());
  bool isSaving = false;

  Shopping formModel = Shopping();

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now()).toString();
    formModel.date = DateTime.now();
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
    super.build(context);
    SizedBox marginBox = SizedBox(height: 16);
    SizedBox marginBox1 = SizedBox(height: 64);

    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SearchInput<Product>(
                    controller: nameController,
                    textCapitalization: TextCapitalization.sentences,
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
                    searchFunction: productController.search,
                    resultBuilder: (product) => Text(product.name),
                    onResultPressed: (product) {
                      formModel.bought = product.name;
                      nameController.text = product.name;
                      formModel.price = product.price;
                      priceController.text = product.price.toString();
                    },
                  ),
                  TextFormField(
                    controller: priceController,
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
                      value = value.replaceAll(',', '.');
                      print(value);
                      formModel.price = double.parse(value);
                      print(formModel.price);
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
                        focusNode: AlwaysDisabledFocusNode(),
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
                            locale : const Locale('pl', ''),
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
                              await productController.add(formModel.bought, formModel.price);
                              await userController.saveData();
                              formKey.currentState.reset();
                              nameController.clear();
                              priceController.clear();
                              dateController.clear();
                              formModel = Shopping();
                              setState(() {
                                isSaving = false;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.save,
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
          ),
        ),
      ],
    );
  }
}

class SearchInput<T> extends StatefulWidget {
  SearchInput({
    this.controller,
    this.decoration,
    this.maxLength,
    this.onChanged,
    this.textInputAction,
    this.validator,
    this.textCapitalization,
    @required this.searchFunction,
    @required this.resultBuilder,
    @required this.onResultPressed,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final int maxLength;
  final void Function(String) onChanged;
  final String Function(String) validator;
  final TextInputAction textInputAction;
  final Future<List<T>> Function(String) searchFunction;
  final Widget Function(T) resultBuilder;
  final void Function(T) onResultPressed;
  final textCapitalization;

  @override
  _SearchInputState<T> createState() => _SearchInputState();
}

class _SearchInputState<T> extends State<SearchInput<T>> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final name = "".obs;
  final searchResults = RxList<T>();
  Worker searchWorker;

  Future search(String name) async {
    if (name.isEmpty) {
      searchResults.clear();
      return;
    }
    var results = await widget.searchFunction(name);
    searchResults.clear();
    searchResults.addAll(results);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + 5.0,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: Obx(
            () => ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                for (T result in searchResults)
                  ListTile(
                    title: widget.resultBuilder(result),
                    onTap: () {
                      _focusNode.unfocus();
                      searchResults.clear();
                      widget.onResultPressed(result);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (searchWorker == null) {
      searchWorker = debounce(name, search, time: Duration(milliseconds: 300));
    }
    return TextFormField(
      controller: widget.controller,
      textCapitalization: widget.textCapitalization,
      focusNode: _focusNode,
      decoration: widget.decoration,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      onChanged: (value) {
        name.value = value;
        widget.onChanged(value);
      },
      validator: widget.validator,
    );
  }
}
