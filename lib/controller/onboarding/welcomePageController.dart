import 'dart:convert';
import 'dart:math';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:get/state_manager.dart';

class WelcomePageController extends GetxController {
  Rx<int> currentIndex = 0.obs;
  Rx<WelcomeQuotesModel?> welcomeQuotes = WelcomeQuotesModel().obs;
  Rx<WelcomeQuotesModelQuotes> welcomeQuote = WelcomeQuotesModelQuotes().obs;

  Rx<String> userName = "".obs;

  Map<String, List<Map<String, String>>> quotesData = {
    "quotes": [
      {
        "quote":
            "Time and health are two precious assets that we don’t recognize and appreciate until they have been depleted",
        "author": "Denis Waitley",
      },
      {
        "quote":
            "A fit body, a calm mind, a house full of love. These things cannot be bought – they must be earned",
        "author": "Naval Ravikant",
      },
      {
        "quote":
            "A good laugh and a long sleep are the best cures in the doctor’s book",
        "author": "Irish proverb",
      },
      {
        "quote":
            "The more you understand yourself, the more silence there is, the healthier you are",
        "author": "Maxime Lagacé",
      },
      {
        "quote":
            "Good health is not something we can buy. However, it can be an extremely valuable savings account",
        "author": "Anne Wilson Schaef",
      },
      {
        "quote":
            "Health is a state of complete harmony of the body, mind, and spirit",
        "author": "B.K.S. Iyengar",
      },
      {
        "quote":
            "Values are related to our emotions, just as we practice physical hygiene to preserve our physical health, we need to observe emotional hygiene to preserve a healthy mind and attitudes",
        "author": "Dalai Lama",
      },
      {
        "quote":
            "If you truly treat your body like a temple, it will serve you well for decades. If you abuse it, you must be prepared for poor health and a lack of energy",
        "author": "Oli Hille",
      },
      {
        "quote":
            "The body loves routine. Try to eat, sleep, and so on at the same times every day in order for the body to function at its optimum efficiency. The body loves consistency",
        "author": "Theresa Hearn Haynes",
      },
      {
        "quote":
            "Anger can have equally disastrous effects on your own life. Left unchecked, it can destroy some of your closest relationships and undermine your physical and mental health",
        "author": "Albert Ellis",
      },
      {
        "quote":
            "A fit body, a calm mind, a house full of love. These things cannot be bought – they must be earned",
        "author": "Naval Ravikant",
      }
    ]
  };

  @override
  void onInit() {
    getWelcomeQuotes();
    getUserName();
    super.onInit();
  }

  getWelcomeQuotes() {
    try {
      welcomeQuotes.value =
          WelcomeQuotesModel.fromJson(jsonDecode(jsonEncode(quotesData)));

      if (welcomeQuotes.value != null) {
        var random = Random();
        int randomIndex = random.nextInt(welcomeQuotes.value!.quotes!.length);
        welcomeQuote.value = welcomeQuotes.value!.quotes![randomIndex]!;
      }
    } finally {}
  }

  getUserName() async {
    UserDetailsResponse? userDetailsResponse =
        await HiveService().getUserDetails();

    if (userDetailsResponse != null &&
        userDetailsResponse.userDetails != null) {
      String firstName = userDetailsResponse.userDetails!.firstName ?? "";
      if (firstName.isNotEmpty) {
        //userName.value = firstName.split(" ")[0];
        userName.value = firstName;
      }
    }
  }
}
