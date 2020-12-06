import 'package:chores_flutter/data/chores_user.dart';
import 'package:chores_flutter/data/jobs.dart';
import 'package:chores_flutter/pages/spin_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChoresAddPage extends StatefulWidget {
  @override
  _ChoresAddPageState createState() => _ChoresAddPageState();
}

class _ChoresAddPageState extends State<ChoresAddPage> with AutomaticKeepAliveClientMixin {
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSaving = false;

  Job formModel = Job();

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
              validator: (value){
                if(value.isEmpty){
                  return 'Proszę podać wykonaną czynność';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Co zostało zrobione',
                alignLabelWithHint: true,
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
                  validator: (value){
                    if(value.isEmpty){
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
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 0, minute: 0),
                    ).then((time) {
                      if (time != null) {
                        setState(() {
                          var duration = time.minute;
                          formModel.duration = duration;
                          durationController.text = '$duration minut';
                        });
                      }
                    });
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
                  validator: (value){
                    if(value.isEmpty){
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
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2222),
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
                      if(formKey.currentState.validate()) {
                        setState(() {
                          isSaving = true;
                        });
                        var provider = Provider.of<ChoresUser>(context, listen: false);
                        var user = provider.user;
                        formModel
                          ..user = user.uid
                          ..userDisplayName = user.displayName
                              .split(" ")
                              .first;
                        provider.userData.overallDuration += formModel.duration;
                        await Provider.of<Jobs>(context, listen: false).add(Job.from(formModel));
                        await provider.saveData();
                        formKey.currentState.reset();
                        durationController.clear();
                        dateController.clear();
                        formModel = Job();
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
