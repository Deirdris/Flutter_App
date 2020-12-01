import 'package:chores_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChoresListPage extends StatefulWidget {
  @override
  _ChoresListPageState createState() => _ChoresListPageState();
}

class _ChoresListPageState extends State<ChoresListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    SizedBox marginBox = SizedBox(height: 16);

    return Consumer<JobsModel>(
      builder: (context, value, child) => ListView(
        children: [
          for (var job in value.jobs) ...[
            _Job(job: job),
            marginBox,
          ],
        ],
      ),
    );
  }
}

class _Job extends StatelessWidget {
  _Job({
    @required this.job,
  });

  final JobModel job;

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
                  job.job,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                Icon(
                  Icons.how_to_reg,
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
                      "Czas trwania",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    Text(job.duration,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Data wykonania",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    Text(DateFormat('dd.MM.yyyy').format(job.date),
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
