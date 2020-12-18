import 'package:chores_flutter/controllers/chores_controller.dart';
import 'package:chores_flutter/data/chore.dart';
import 'package:chores_flutter/widgets/future_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChoresListPage extends StatefulWidget {
  @override
  _ChoresListPageState createState() => _ChoresListPageState();
}

class _ChoresListPageState extends State<ChoresListPage> with AutomaticKeepAliveClientMixin {
  final jobsController = Get.put(ChoresController(), permanent: true);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizedBox marginBox = SizedBox(height: 16);

    return FutureHandler(
      future: jobsController.fetchFuture,
      onDone: (_) => Obx(
        () => ListView(
          children: [
            for (var job in jobsController.chores) ...[
              _Chore(job: job),
              marginBox,
            ],
          ],
        ),
      ),
    );
  }
}

class _Chore extends StatelessWidget {
  _Chore({
    @required this.job,
  });

  final Chore job;

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
                  child: Tooltip(
                    message: job.job,
                    child: Text(
                      job.job,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    job.userDisplayName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                    Text(
                      '${job.duration} minut',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
