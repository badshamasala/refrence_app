import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveEventsLiveCount extends StatelessWidget {
  final String liveEventId;
  const LiveEventsLiveCount({Key? key, required this.liveEventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("liveEvents")
            .doc(liveEventId)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as DocumentSnapshot;
            int number = data['liveCount'] as int;
            if (number < 0) {
              number = 0;
            }

            return Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFAAFDB4),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 2,
                        offset: Offset(0, 2))
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
              child: Text(
                '${number > 999 ? '${(number / 1000).toStringAsFixed(2)}K' : '$number'} LIVE',
                style: TextStyle(
                  color: const Color(0xFF298634),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          return const Offstage();
        });
  }
}
