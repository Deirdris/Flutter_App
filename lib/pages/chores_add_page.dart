import 'package:chores_flutter/data/chores_user.dart';
import 'package:chores_flutter/data/jobs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import 'package:provider/provider.dart';

class ChoresAddPage extends StatefulWidget {
  @override
  _ChoresAddPageState createState() => _ChoresAddPageState();
}

class _ChoresAddPageState extends State<ChoresAddPage> with AutomaticKeepAliveClientMixin {
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                  enabled: false,
                  controller: durationController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Czas trwania [hh]:[mm]',
                    alignLabelWithHint: true,
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
                          var duration = time.format(context).toString();
                          formModel.duration = duration;
                          durationController.text = duration;
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
                  enabled: false,
                  controller: dateController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Data',
                    //(_dateTime == null ? 'Data nie została wybrana' : DateFormat('dd.MM.yyyy').format(_dateTime)),
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
                    onPressed: () {
                      var user = Provider.of<ChoresUser>(context, listen: false).user;
                      formModel
                        ..user = user.uid
                        ..userDisplayName = user.displayName.split(" ").first;
                      Provider.of<Jobs>(context, listen: false).add(Job.from(formModel));
                      formKey.currentState.reset();
                      durationController.clear();
                      dateController.clear();
                      formModel = Job();
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
