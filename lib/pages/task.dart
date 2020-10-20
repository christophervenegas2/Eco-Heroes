import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_listcard.dart';

class Task extends StatefulWidget {
  final getUser, getWipTask, tabindex, settabindex, task, wip, revision, names;

  const Task({Key key, this.getUser, this.tabindex, this.settabindex, this.getWipTask, this.task, this.wip, this.revision, this.names}) : super(key: key);
  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> with SingleTickerProviderStateMixin {
  TabController _tabController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loadtask = false;

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = widget.tabindex;
    return (Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 60),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
            child: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              labelStyle: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Proxima Nova'),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
              indicator: BoxDecoration(color: Color(0xFF4AD6B0), borderRadius: BorderRadius.circular(50)),
              labelPadding: EdgeInsets.zero,
              isScrollable: true,
              controller: _tabController,
              unselectedLabelColor: Color(0xFF4AD6B0),
              tabs: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text('Disponibles'),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("En curso"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Revisión"),
                  ),
                ),
              ],
            ),
          ),
          loadtask
              ? Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4AD6A7)),
                    strokeWidth: 3,
                  ),
                )
              : Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListCard(
                          task: widget.task,
                          names: widget.names,
                          settabindex: widget.settabindex,
                          gettask: widget.getWipTask,
                          tab: 0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: TOListCard(
                                task: widget.wip,
                                gettask: widget.getWipTask,
                                settabindex: widget.settabindex,
                                dismissible: true,
                                tab: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TOListCard(
                            task: widget.revision,
                            gettask: widget.getWipTask,
                            settabindex: widget.settabindex,
                            dismissible: true,
                            tab: 2,
                          )),
                    ],
                  ),
                )
        ],
      ),
    ));
  }
}
