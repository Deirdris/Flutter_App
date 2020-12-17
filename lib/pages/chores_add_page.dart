import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:chores_flutter/controllers/chores_controller.dart';
import 'package:chores_flutter/data/chore.dart';
import 'package:chores_flutter/utils/always_disabled_focus_node.dart';
import 'package:chores_flutter/widgets/spin_me.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MinutePicker extends TimePickerModel {
  MinutePicker() : super(currentTime: DateTime(0));

  @override
  List<int> layoutProportions() {
    return [0, 1, 0];
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return ":";
  }
}

class ChoresAddPage extends StatefulWidget {
  @override
  _ChoresAddPageState createState() => _ChoresAddPageState();
}

class _ChoresAddPageState extends State<ChoresAddPage> with AutomaticKeepAliveClientMixin {
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();
  bool isSaving = false;

  Chore formModel = Chore();

  void unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  @override
  void dispose() {
    durationController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    dateController.text = dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now()).toString();
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Proszę podać wykonaną czynność';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Co zostało zrobione',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.only(top: 12, bottom: 8),
              ),
              textInputAction: TextInputAction.next,
              maxLength: 50,
              onChanged: (value) {
                formModel.job = value;
              },
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextFormField(
                  focusNode: AlwaysDisabledFocusNode(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: durationController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Czas trwania',
                    alignLabelWithHint: true,
                    errorStyle: TextStyle(height: 0),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity(vertical: -3),
                  padding: EdgeInsets.zero,
                  splashRadius: 24,
                  onPressed: () {
                    unfocus();
                    DatePicker.showPicker(
                      context,
                      locale: LocaleType.pl,
                      pickerModel: MinutePicker(),
                      theme: DatePickerTheme(
                        doneStyle: TextStyle(color: Colors.amber),
                        cancelStyle: TextStyle(color: Colors.black.withAlpha(220)),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          var duration = value.minute;
                          formModel.duration = duration;
                          durationController.text = '$duration minut';
                        });
                      }
                    });
                    // showTimePicker(
                    //   context: context,
                    //   initialTime: TimeOfDay(hour: 0, minute: 0),
                    // ).then((time) {
                    //   if (time != null) {
                    //     setState(() {
                    //       var duration = time.minute;
                    //       formModel.duration = duration;
                    //       durationController.text = '$duration minut';
                    //     });
                    //   }
                    // });
                  },
                  icon: Icon(
                    Icons.access_time_outlined,
                    size: 20,
                  ),
                ),
              ],
            ),
            marginBox,
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextFormField(
                  focusNode: AlwaysDisabledFocusNode(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Data',
                    errorStyle: TextStyle(height: 0),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity(vertical: -3),
                  padding: EdgeInsets.zero,
                  splashRadius: 24,
                  onPressed: () {
                    unfocus();
                    showDatePicker(
                      context: context,
                      locale: const Locale('pl', ''),
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
                  child: RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          isSaving = true;
                        });
                        var user = userController.user;
                        formModel
                          ..user = user.uid
                          ..userDisplayName = user.displayName.split(" ").first;
                        userController.userData.overallDuration += formModel.duration;
                        await Get.find<ChoresController>().add(Chore.from(formModel));
                        await userController.saveData();
                        formKey.currentState.reset();
                        durationController.clear();
                        dateController.clear();
                        formModel = Chore();
                        setState(() {
                          isSaving = false;
                        });
                      }
                    },
                    child: SpinMe(
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
