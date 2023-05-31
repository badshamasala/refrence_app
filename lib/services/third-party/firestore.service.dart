import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<void> joinChannel(String liveEventId) async {
    await FirebaseFirestore.instance
        .collection('liveEvents')
        .doc(liveEventId)
        .set({
      "liveCount": FieldValue.increment(1),
      "smileCount": FieldValue.increment(0),
    }, SetOptions(merge: true));
  }

  Future<void> leaveChannel(String liveEventId) async {
    FirebaseFirestore.instance
        .collection('liveEvents')
        .doc(liveEventId)
        .set({"liveCount": FieldValue.increment(-1)}, SetOptions(merge: true));
  }

  Future<void> sendSmile(String liveEventId) async {
    await FirebaseFirestore.instance
        .collection('liveEvents')
        .doc(liveEventId)
        .set({"smileCount": FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Future<void> changeLiveCount(String liveEventId, int num) async {
    await FirebaseFirestore.instance
        .collection('liveEvents')
        .doc(liveEventId)
        .set({
      "liveCount": num,
      "smileCount": FieldValue.increment(0),
    }, SetOptions(merge: true));
  }
}
