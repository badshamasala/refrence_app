import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Experiment extends StatefulWidget {
  const Experiment({Key? key}) : super(key: key);

  @override
  State<Experiment> createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: Container(
              color: Colors.blue,
              height: 100.h,
              width: double.infinity,
            ),
            pinned: true,
            expandedHeight: 100.h,
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                flexibleSpace: Container(
                  color: Colors.red,
                  height: 100.h,
                  width: double.infinity,
                ),
                pinned: true,
                expandedHeight: 100.h,
                bottom: TabBar(
                    controller: TabController(length: 3, vsync: this),
                    tabs: [Text('hellp'), Text('helle'), Text('hellj')]),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                    color: Colors.red,
                    margin: EdgeInsets.all(10),
                    height: 100.h,
                  ),
                  childCount: 100,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
