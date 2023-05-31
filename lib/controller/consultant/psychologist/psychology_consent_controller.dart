import 'package:get/get.dart';

class PsychologyConsentController extends GetxController {
  RxBool isAccepted = false.obs;
  List<Map<String, dynamic>> listofRights = [
    {
      "title": "RESPONSIBILITIES",
      "content": [
        {
          "icon": "assets/images/psycology/18plus.png",
          "desc":
              "Clients interested in receiving online counselling services must be at least 18 years-old.",
        },
        {
          "icon": "assets/images/psycology/hand.png",
          "desc":
              "Personally identifiable images or excerpts from the therapy for the purpose of clinical supervision will not happen without your explicit consent given to have sessions recorded.",
        }
      ],
    },
    {
      "title": "CLIENT'S RIGHTS",
      "content": [
        {
          "icon": "assets/images/psycology/18plus.png",
          "desc":
              "The client may ask questions on what to expect during and end result of the therapy",
        },
        {
          "icon": "assets/images/psycology/hand.png",
          "desc":
              "The client may decline to proceed the therapy as to the techniques which may be conducted by the therapist",
        }
      ],
    },
  ];
}
