import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ecoheroes/pages/detail_task.dart';
import 'package:ecoheroes/pages/end_task.dart';
import 'package:ecoheroes/ui/to_cardtask.dart';
import 'to_confirmationdialog.dart';

class TOListCard extends StatefulWidget {
  final task, settabindex, gettask, tab, disablebutton, names;
  final bool dismissible;

  const TOListCard({Key key, this.task, this.dismissible = false, this.settabindex, this.gettask, this.tab, this.disablebutton = false, this.names}) : super(key: key);

  @override
  _TOListCardState createState() => _TOListCardState();
}

class _TOListCardState extends State<TOListCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var temp = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await widget.gettask(widget.tab);
    // if failed,use refreshFailed()
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      header: ClassicHeader(
        completeDuration: Duration(seconds: 2),
        completeText: 'Tareas actualizadas!',
        refreshingText: 'Actualizando tareas...',
        idleText: 'Desliza para actualizar!',
        releaseText: 'Soltar para actualizar!',
        failedText: 'Internet no es para mí :(, hubo un error',
      ),
      child: (widget.task).length == 0
          ? Center(child: Text('No hay tareas disponibles...'))
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.task.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return (index == widget.task.length)
                    ? widget.dismissible
                        ? Text(
                            'Desliza para eliminar',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          )
                        : SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: widget.dismissible
                            ? Dismissible(
                                confirmDismiss: (DismissDirection dismissDirection) async {
                                  return await showConfirmationDialog(context) == true;
                                },
                                onDismissed: (DismissDirection dismissDirection) async {
                                  return {
                                    await firestore.collection('tasks').doc(widget.task[index]['id']).get().then((value) async => {
                                          if (value.data()['counterstart'] == value.data()['maxstart'])
                                            {
                                              await firestore.collection('task-active').doc('active').get().then((value) => {
                                                    temp = value.data()['task'],
                                                    temp.asMap().forEach((i, t) {
                                                      if (t['id'] == widget.task[index]['id']) {
                                                        temp[i]['status'] = 'enabled';
                                                      }
                                                    }),
                                                    if (temp.length == value.data()['task'].length)
                                                      {
                                                        firestore.collection('task-active').doc('active').update({'task': temp})
                                                      }
                                                  }),
                                            },
                                          await firestore.collection('tasks').doc(widget.task[index]['id']).update({'counterstart': FieldValue.increment(-1)})
                                        }),
                                    await firestore.collection('users').doc(userprovider.userinfo['id']).collection('tasks').doc(widget.task[index]['id_desafio']).delete(),
                                    widget.gettask(widget.tab),
                                  };
                                },
                                direction: DismissDirection.endToStart,
                                dismissThresholds: {DismissDirection.endToStart: 0.2},
                                background: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDBDBDB),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Icon(Icons.delete_sweep, color: Color(0xFFDF2126)),
                                      )),
                                ),
                                key: widget.task[index]['id'] == null ? Key(index.toString()) : Key(widget.task[index]['id']),
                                child: TOCardTask(
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EndTask(
                                          task: widget.task[index],
                                          gettask: widget.gettask,
                                          settabindex: widget.settabindex,
                                          docid: widget.task[index]['id'],
                                        ),
                                      ),
                                    )
                                  },
                                  index: index,
                                  task: widget.task,
                                ),
                              )
                            : TOCardTask(
                                onTap: widget.disablebutton
                                    ? () {}
                                    : () async => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => DetailTask(
                                                names: widget.names,
                                                settabindex: widget.settabindex,
                                                docid: widget.task[index]['id'],
                                                gettask: widget.gettask,
                                              ),
                                            ),
                                          )
                                        },
                                index: index,
                                task: widget.task,
                              ),
                      );
              },
            ),
    );
  }
}
