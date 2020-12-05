import 'package:chores_flutter/data/jobs.dart';
import 'package:chores_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChoresListPage extends StatefulWidget {
  @override
  _ChoresListPageState createState() => _ChoresListPageState();
}

class _ChoresListPageState extends State<ChoresListPage> with AutomaticKeepAliveClientMixin {
  Future future;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizedBox marginBox = SizedBox(height: 16);

    if(!Provider.of<Jobs>(context, listen: false).hasFetchedData){
      future = Provider.of<Jobs>(context, listen: false).fetchData();
    }else{
      future = Provider.of<Jobs>(context, listen: false).fetchFuture;
    }

    return Consumer<Jobs>(
      builder: (context, value, child) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: [
                for (var job in value.jobs) ...[
                  _Job(job: job),
                  marginBox,
                ],
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _Job extends StatelessWidget {
  _Job({
    @required this.job,
  });

  final Job job;

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
                  job.job,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
                Text(job.userDisplayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.person,
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
