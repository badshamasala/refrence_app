import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        /*  'ko_KR': {
          'greeting': '안녕하세요',
        },
        'ja_JP': {
          'greeting': 'こんにちは',
        }, */
        'en_US': {
          // Common Text

          'FOLLOWING': 'Following',
          'FOLLOW': 'Follow',
          'VIEW_ALL': 'View All',
          'DISMISS': 'Dismiss',
          'REFRESH': 'Refresh',
          'LOGIN': 'Login',
          'DATE': 'Date: ',
          'TIME': 'Time: ',
          ':': ':',
          'OR': 'or',
          'OKAY': 'Okay',

          //Events
          'EVENT_STARTS_IN': 'Event starts in',
          'DAYS': 'Days',
          'HOURS': 'Hours',
          'MINS': 'Mins',
          'MIN': 'Min',

          'COMPLETED': 'Completed',
          'PENDING': 'Pending',
          'AWESOME': 'Awesome!',
          'SUBMIT': 'Submit',
          'SKIP': 'Skip',
          'FREE': 'Free',
          'SKIP_FOR_NOW': 'Skip for now',
          'COMING_SOON': 'Coming Soon',
          'DOCTOR': 'Doctor',

          'CONTINUE': "Continue",

          'CONFERENECE_DETAILS': '24th International Conference',
          'CONFERENECE_TITLE':
              'On Frontiers in Yoga Research and its Applications',
          'VIEW_DETAILS': 'View Details',

          'BED_TIME': 'BED TIME',
          'WAKE_UP': 'WAKE UP',
          'SLEEP_HOURS': 'SLEEP HOURS',
          'FOR_HOW_LONG_DID_YOU_SLEEP': 'For how long did you sleep?',
          'YOU_SLEPT_FOR': 'You slept for',
          'CONTINUE_WITH_AAYU': 'Continue with Aayu',
          'ALREADY_MEMBER': 'Already a member? ',

          'AFFIRMATION': 'Affirmation',
          'CONTENT': 'Content',
          'CATEGORY': 'Category',
          'WELCOME': 'Welcome',
          // Grow
          'EXPLORE_SECTION':
              'Enhance your wellbeing,\nexplore our sections below.',

          //healing
          'CONFIRM_SLOT': 'Confirming your slot...',
          'APPOINTMENT_BOOKED_SUCCESSFULLY': 'Appointment Booked Successfully',
          'NOTE_FROM_YOUR_DOCTOR': 'Note from your Doctor',
          'LATEST_REPORTS_CONSULTATION':
              'Keep your latest reports handy for the consultation.',
          'RELIABLE_INTERNET_SERVICE': 'Connect to a reliable internet service',
          'ANSWER_QUESTIONS_APPOINTMENT':
              'Answer a few questions to make the most of your appointment.',
          'INITIAL_ASSESSMENT': 'Initial Assessment',
          'BOOK_DOCTOR_SLOT': 'BOOK DOCTOR SLOT',
          'SOMETHING_WENT_WRONG': 'Something went wrong. Please try again!',
          'TAKE_ASSESSMENT_NOW': 'Take Assessment Now',
          'Speaks': 'Speaks :',
          'AVAILABLE_SLOTS': 'AVAILABLE SLOTS',
          'BOOK_SLOT': 'Book a Slot',
          'BLOCK_SLOT': 'Block a Slot',
          'DAY_WISE_PROGRAM': 'DAY_WISE_PROGRAM',
          'PROGRAM_DETAILS': 'PROGRAM_DETAILS',
          'DOCTOR_SESSIONS': 'DOCTOR_SESSIONS',
          'FAILED_TO_BOOK': 'Failed to book slot. Please try again!',
          'NO_SLOTS': 'No slots available for selected date.',
          'TRAINER_SESSIONS': 'TRAINER_SESSIONS',
          'BOOK_TRAINER_SLOTS': 'Book_Trainer_Slots',
          'FAILED_TO_SAVE_DETAILS': 'Failed to save details. Please try again',
          'BIRTH_DATE_TEXT':
              'Knowing your birth date will help us understand you better and customise your healing journey.',

          'VIEW_DOCTOR_RECOMMENDATION': 'View Doctor’s Recommendation',
          'PROGRAM_RECOMMENDATION_NOT_AVAILABLE':
              'Program Recommendation not available!',
          'FIRST_STEP_TEXT':
              'You’ve taken the first step in owning your health. Now, follow your program and get, set, go! ',

          'LET_IDENTIFY': 'Let’s Identify...',
          'WHAT_AFFECTED_YOUR_SLEEP': 'What affected your sleep?',
          'YOUR_AAYU_SCORE': 'Your Aayu Score',
          'CHECK_YOUR_AAYU_SCORE': 'Check Your Aayu Score',
          'DOCTOR_RECOMMENDATION': 'Doctor’s Recommendation',
          'YOUR_DOCTOR_WILL_CUSTOMIZE_THE_PROGRAM_MSG':
              'Your doctor will customize the program in 24 hours and share a link with you via SMS.',
          'HOW_WAS_YOUR_EXPERIENCE': 'How was your experience?',
          'LEAVE_REVIEW_TEXT': '\n\nLeave a review\n\n',
          'FEEDBACK_TEXT': 'Thank you for your feedback.',

          'SELECT_ANY_SESSION': 'Please select any session',
          'ADD_PACKAGE': 'Add Package',
          'CHOOSE_PAYMENT_OPTIONS': 'Choose Payment Options',

          'YOU_DONT_HAVE_ANY_DOCTOR_CONSULTS':
              'You don’t have any doctor consults.',
          'YOU_DONT_HAVE_ANY_YOGA_THERAPY_SESSIONS':
              'You don’t have any yoga therapy sessions.',

          'DOCTOR_CONSULTS': 'Doctor Consultation Sessions',
          'ACTIVE': 'ACTIVE',
          'BUY_MORE': 'Buy',
          'SCHEDULE': 'Schedule',
          'PREREQUISITE': 'Prerequisite',
          'CALL_JOIN_LINK_NOT_AVAILABLE': 'Call join link not available!',
          'FIRST_SESSION_WITH_A_YOGA_THERAPIST':
              'Schedule your first session with a Yoga Therapist.',
          'SCHEDULE_FIRST_CONSULT_TEXT':
              'Schedule your first consultation with a Doctor specialising in Integrated Yoga Therapy.',
          'BUY_SESSIONS': 'Buy Sessions',
          'UPCOMING': 'Upcoming',
          'RESCHEDULE': 'Reschedule',
          'PAST_SESSIONS': 'Past Sessions',
          'BOOKED': 'BOOKED',
          'JOIN_THE_SESSION': 'JOIN THE SESSION',
          'RESCHEDULE_UNTIL_1_HOUR_BEFORE_THE_SLOT_TIME':
              'You can reschedule only until 1 hour before the slot time',
          'CAMERA_PERMISSION':
              'Required the camera permission to start the video call',
          'MICROPHONE_PERMISSION':
              'Required the microphone permission to start the video call',
          'GOT_QUERY': 'GOT QUERY',
          'BOOK_A_DOCTOR_CONSULTATION': 'Book a Doctor Consultation',
          'CUSTOMIZE_HEALING_PROGRAM':
              'while we customize your healing program.',
          'THOUGHT_MSG':
              'Now sit back and send out a beautiful thought into the world',
          'CUSTOMIZE_SESSION_TEXT': 'while we customize your sessions.',
          'SESSION_READY_MSG': 'Your sessions are ready!',
          'FAILED_TO_PREBOOK_SESSION_MSG': 'Failed to pre-book sessions',
          'YOGA_THERAPIST_SESSIONS': 'Yoga Therapist Sessions',
          'ATTENDED': 'ATTENDED',
          'EXPIRED': 'EXPIRED',
          'PERSONAL_TRAINER': 'Select a Yoga Therapist',
          'BOOK_CONSULTATION': 'Select Health Expert',
          'CHECK_SLOTS': 'CHECK SLOTS',
          'DOCTORS_ARE_NOT_AVAILAIBLE':
              "Doctor's are not available for now.\nPlease try later",
          'THERAPIST_ARE_NOT_AVAILAIBLE':
              "Therapist's are not available for now.\nPlease try later",
          'NUTRITIONIST_ARE_NOT_AVAILAIBLE':
              "Nutritionist's are not available for now.\nPlease try later",
          'PSYCHOLOGIST_ARE_NOT_AVAILAIBLE':
              "Psychologist are not available for now.\nPlease try later",
          'BOOK_TRAINER_SESSION': 'Book a Trainer Session',
          'TESTIMONIALS': 'Testimonials',
          'NO_INTERNET': 'No Internet',
          'NOTIFY_ME': 'Notify Me',
          'ASSESSED_BY_SPECIALIST':
              'Get assessed by a specialist, all it takes is 15 minutes',
          'LATEST_REPORTS_HANDY_FOR_THE_COSULT':
              'Just keep your latest reports handy for the consult',
          'OR_CONTINUE_WITH': 'Or continue with ',
          'FREE_DOCTOR_CONSULT': 'Free Doctor Consult',
          'WE_NEED_TO_MENTION_MSG':
              'We need to mention 3-4 lines about\n our doctors and we can also mention\n about S-vysa',
          'NOTE_MSG':
              "Please note:\nOnce you book a slot, you can't cancel/reschedule it.",
          'SELECT_YOUR_DOCTOR': 'Select Your Doctor',
          'THANK_YOU_COMING_SOON_MSG':
              'Thank you for showing interest.\nFeature is coming soon.',
          'GOT_QUERIES': 'Got queries?',
          "SURE_YOU_WANT_TO_SKIP":
              'Sure you want to skip the\nsteps? Your experience won’t\nbe personalised.',

          'YOU_HAVE_ALREADY_SUBSCRIBED':
              'Your current program is still live! For further assistance, connect with our support team.',
          'PERFERENCES_DETAILS_NOT_AVAILABLE':
              'Perferences details not available!',
          'SELECT_PROGRAM_PREFERENCES': 'Select Program Preferences',

          'CONSULT_FOR_MORE_THAN_ONE_ILLNESS_MSG':
              'To consult for more than one illness, you need to first talk to our doctors',
          'ALREADY_USED_FREE_SESSION_BOOKING':
              'You have already used free session booking.',
          'CONGRATULATIONS': 'Congratulations',
          'BASIC_HEALTH_ASSESMENT_MSG':
              'You’ve completed your basic health assessment. Your doctor will discuss more about the disease during the consult.',
          'COMPLETED_YOUR_ASSESMENT':
              "You’ve completed your assessment. Remember, your intent to heal is stronger than any diagnosis.",
          'YOU_ARE_UNIQUE': "you are unique",
          'HELP_US_UNDERSTAND_YOU_BETTER_THROUGH_THIS_ASSESSMENT':
              "Your wellbeing is an interplay of various factors. Help us understand you better through this assessment.",
          'SELECT': "Select",
          'ANSWER_LATER': "Answer Later",
          'ANSWER_NOW': "Answer Now",
          'PICK_YOUR_REPLY': "Pick Your Reply",
          'NEXT': "Next",
          'OBJECTIVE_ASSESSMENT': "OBJECTIVE ASSESSMENT",
          'SUBJECTIVE_ASSESSMENT': "SUBJECTIVE ASSESSMENT",
          'PREVIOUS': "Previous",
          'LEAVING_MIDWAY': "Leaving midway?",
          'FINISH_YOUR_ASSESSMENT':
              "It is important that you finish your assessment, so that we can map your progress.",
          'DO_IT_LATER': "Do it Later",
          'START_NOW': "Start Now",

          'ASSESSING_FOR': "ASSESSING FOR",
          'SCORE': "Score",
          '10': "10",
          '%': "%",
          'AAYU_SCORE': "Aayu Score",

          'BEGIN_ASSESSMENT': "Begin Assessment",
          'RESUME_ASSESSMENT': "Resume Assessment",
          'HEALING_WELLNESS_YOU_MSG': "Healing,\nwellness & you.",
          'OOPS': "Oops!",
          'POWERED_BY': "Powered by:",
          'ABOUT_YOUR_HEALTH_HONESTLY_TXT':
              "Answer questions about your health honestly. Your Aayu Score is an insight into your current health.",
          'YOUR_ASSESSMENT_IS_INCOMPLETE_MSG':
              "Your assessment is incomplete. Answer all the questions to monitor your progress.",
          'DURATION': "Duration",
          'PERIOD': "Period",
          'ONLINE_PERSONAL_TRAINING': "Online Personal Training",
          'DELETE_ADD_ON': "Delete Add-On",
          'ARE_YOU_SURE': "Are you sure?",
          'CANCEL': "Cancel",
          'DELETE': "Delete",
          'PAYMENT': "Payment",
          "DEBIT_CREDIT_CARDS_TXT": "Debit / Credit Cards",
          'ADD_NEW_CARD': "Add new card",
          'NET_BANKING': "Net Banking".toUpperCase(),
          'PAY_WITH_UPI': "Pay With UPI",
          'ADD_NEW_UPI': "Add new UPI",
          'SUMMARY': "Summary",
          'LENGTH': "LENGTH",
          'BEDTIME': "Bedtime",
          'TAGS': "TAGS",
          'TODAY': "Today",
          'YESTERDAY': "Yesterday",
          'YOUR_PLAN': "YOUR PLAN",
          'ONLINE_DOCTOR_CONSULTATION': "Online Doctor Consultation",
          'PICK_A_DATE': "PICK A DATE",
          'START_YOUR_HEALING_JOURNEY': "Start your healing journey on...",
          'ACCESS_YOUR_PROGRAM': "Access Your Program",
          'YOUR_PROGRAM_IS_READY': "Your program is ready!",
          'FAILED_TO_UPDATE_SUBSCRIPTION': "Failed to update subscription!",
          'RECOMMENDED': "RECOMMENDED",
          'RECENT_SEARCHES': "RECENT SEARCHES",
          'MONTH': "Month",
          'CHOOSE_A_PROGRAM_LENGTH_TXT':
              "Choose a program-length that you will find easy to stay committed to.",
          'ALL_DONE': "All done!",
          'YOUR_JOURNEY_TOWARDS_HEALTH_MSG':
              "Your journey towards health and wellness begins today.",
          'YOUR_MONTHLY_ASSESSMENT': "Your Monthly Assessment",
          'CONTENT_NOT_AVAIALBLE': "Content not avaialble!",
          'THANK_YOU': "Thank you!",
          'THIS_HELPS_US_MAP_YOUR_PROGRESS_BETTER':
              "This helps us map your progress better.",
          'REMINDER_FOR_DAILY_PRACTICE': "Reminder for Daily Practice",
          'CHOOSE_A_DURATION_FOR_EACH_SESSION':
              "Choose the session duration for your [PROGRAM_NAME] that you will find easy to commit to.",
          'SET_A_TIME': "Set a Time",
          'DAY_ZERO_MSG':
              "For consistency, its important that you practice at the same time daily.",
          'HOW_ARE_YOU_TXT': "How are you, really?",
          'DAY_ZERO_STATUS':
              "Your Aayu Score determines the status of your health. It is the starting point to track your progress in the program.",
          'ASSESS_YOURSELF': "Assess Yourself",
          'YOUR_HEALTH_HONESTLY_MSG':
              "Answer questions about your health honestly. Your Aayu Score will give an insight into your current health.",
          'TAKE_A_15_MINUTE_ASSESSMENT': "Take a 15-Minute Assessment",
          "TODAY_QUESTION": "TODAY'S QUESTION",
          "SUBMITTED": "Submitted",
          "HEALTH_CARD": "Health Card",
          "YOUR_CURRENT_HEALTH_SCORE": "YOUR CURRENT HEALTH SCORE",
          "HEALTH_SCORE_BASED_ON_THE_ASSESMENT_QUESTIONS":
              "Your current health score based on the assesment questions. Overall current health score based on the assesment questions.",
          "BUILD_YOUR_PROGRAM": "Build your program",
          "YOUR_OVERALL_HEALTH_SCORE": "YOUR OVERALL HEALTH SCORE",
          "Brilliant_Effort": "Brilliant Effort!",
          "REPEAT": "Repeat:",
          "HEALTH_SCORE_BASED_ON_DAYS_MESSAGE_TXT":
              "Overall health score based on days message. Overall health score based on days insight message",
          "SET_YOUR_DAILY_PRACTICE_TIME": "Set Your\nDaily Practice Time",
          "15_MINUTES_BEFORE_YOU_START_MSG":
              "We'll notify you 15 minutes\nbefore you start.",
          "FAILED_TO_SAVE_DETAILS_MSG": "Failed to save details",
          "WELLNESS_QUOTIENT": "WELLNESS QUOTIENT",
          "AAYU_TIPS": "Aayu\nTips",
          "HEALING_AND_YOU": "Healing and You",
          "UPCOMING_PROGRAMS": "UPCOMING PROGRAMS",
          "UPCOMING_PROGRAM": "UPCOMING PROGRAM",

          "VIEW_PERSONALIZED_PROGRAM": "View Personalised Program",
          "BEDTIME_IS_APPROACHING_TEXT": "Psst...\nYour bedtime is approaching",
          "SLEEP_INSTRUCTIONS":
              "Remember to keep your phone away as part of your sleep hygeine.",
          "SLEEP_INSTRUCTIONS2":
              "Every extra minute that you spend on your phone can ruin your chances of sound sleep.",
          "KNOW_MORE": "Know More",
          "DAILY_ROUTINE": "My Routine",
          "INHALE": "INHALE",
          "BOOK_NOW": "Book Now",
          "OVERVIEW": "Overview",
          "ACCURACY": "Accuracy",
          "SHARE_YOUR_SCORE": "Share your score",
          "POSE_CORRECTION_AI_COACH_TEXT": "POSE\nCORRECTION\nAI-COACH",
          "HOW_TO_PROCEED": "How to proceed",
          "START_PROGRAM": "Start Program",
          "GET_STARTED": "Get Started",
          "READ_MORE": "Read More",
          "THANK_YOU_FOR_REGISTRATION": "Thank you for registration.",
          "FEATURE_COMING_SOON": "Feature coming soon.",
          "PERSONALISED_CONTENT_SUGGESTIONS":
              "Answer a few questions about your health to give you personalised content suggestions.",
          "HEALING_PROGRAMS": "Healing\nPrograms",
          "FREE_DOCTOR_CONSULTATION": "Get a Free Doctor Consultation",
          "FREE_DOCTOR_CONSULTATION_MSG": "Free Doctor Consultation",
          "FREE_DOCTOR_CONSULTATION_SCHEDULE_FOR":
              "Free doctor consultation scheduled for",
          "GROW_CONTENT": "Grow\nContent",
          "ONBOARDING_SUBTITLE":
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit ipsum dolor sit amet.",
          "POSE_CORRECTION_AI_COACH": "POSE CORRECTION AI-COACH",
          "ANXIETY_AND_DISORDER": "Anxiety\nDisorder Care",
          "ADD_ONS": "Add-ons",
          "POWERED_BY_SVYASA": "Powered by S-VYASA",
          "BOOK_FREE_DOCTOR": "Book\nDoctor Consultation",
          "BOOK_FREE_DOCTOR_MSG": "Book a Doctor Consult",
          "GET_EVALUATED_IN_15_MINUTES": "Get evaluated in 15 minutes",
          "CHOOSE_FROM_OUR_PANEL":
              "Choose from our panel of clinical\nexperts in Intergrated Yoga Therapy",
          "CHECK_OUT_MORE_CONTENT":
              "Check out more content. with 2 lines of content what user will expect if clicked",
          "WHAT_YOU_ARE_LOOKING_FOR":
              "Couldn’t find what you were looking for? ",
          "FREE_CONSULT_IS_ONE_TIME_OPPORTUNITY":
              "The free consult is a one time\n opportunity that can’t be cancelled\n or rescheduled",
          "EXHALE": "EXHALE",
          "LISTING": "Listings",
          "KNOW_MORE_ABOUT_ANXIETY": "Know more about Anxiety",
          "TRACK_MOOD": "Track your mood\nregularly at",
          "CHECK_IN_COMPLETE": "Check-in Complete",
          "BOOK_ONE_TO_ONE":
              "Book a 1-to-1 session with our doctors specialized in Integrated Yoga Therapy to talk about your chronic health condition and get a personalised healing program.",
          "APPRECIATE_MSG": "We appreciate you looking\nout for yoursellf.",
          "MOOD_TRACKER": "Mood Tracker",
          "Journaling": "Journaling",
          "EXPLORE_MORE": "Explore Aayu",
          "EXPRESS_YOURSELF": "Express yourself",
          "COMPLETE_CHECK_IN": "Complete Check-in",
          "REGISTER_FOR_YOUR_ANXIETY":
              "for registering for your Anxiety healing program.",
          "HELP_YOU_PROCESS_YOUR_FEELINGS_TXT":
              "Writing what's on your mind can help you process your feelings. This space is for your eyes only. Fill it up, without fear of judgement.'",
          "IDENTIFY_TXT": "LET'S IDENTIFY...",
          "WHY_ARE_YOU_FEELING_THIS_WAY": "Why are you feeling this way?",
          "LETS_FIGURE": "Let's Figure",
          "WHAT_YOU_FEEL": "What you feel?",
          "YOU_ARE": "you are".toUpperCase(),
          "SLEEP_QUALITY": "SLEEP QUALITY",
          "AVERAGE_BEDTIME": "AVERAGE\nBEDTIME",
          "AVERAGE_SLEEP_HOURS": "AVERAGE\nSLEEP HOURS",
          "WHAT_HELPED_YOU_SLEEP": "What helped you sleep",
          "WHAT_KEPT_YOU_UP_AT_NIGHT": "What kept you up at night",
          "BECAUSE_OF": "because of".toUpperCase(),
          "TRACK_YOUR_MOOD_CONSISTENTLY":
              "Set a reminder to track your mood consistently.",
          "REMIND_YOU_TO_CHECK_IN_AT": "We'll remind you to check in at",
          "MOOD_OF_THE_WEEK": "MOOD OF THE WEEK",
          "YOU_MOSTLY_FELT": "You mostly felt",
          "WHAT_MADE_YOU_SMILE": "What made you smile",
          "WHAT_GOT_YOU_DOWN": "What got you down",
          "YOUR_WEEKLY_INSIGHTS": "Your Weekly Insights",

          // OTP Screen

          "VERIFY_OTP": "Verify OTP",
          "OTP_SENT_ON": "OTP sent on ",
          "DIDNT_RECEIVE_CODE": "Didn't receive code? ",
          "RESEND_OTP": "Resend OTP",
          "CHANGE_NUMBER": "Change Mobile Number",
          "ENTER_YOUR_NUMBER": "Enter your number",
          "ENTER_A_VALID_MOBILE_NUMBER": "Please enter a valid mobile number.",
          "YOUR_MOBILE_NUMBER": "Your mobile number",
          "ACCOUNT_NOT_EXIST_WITH_THIS_MOBILE_NUMBER":
              "Account not exist with this mobile number.",
          "EXIT_AAYU": "Exit Aayu",
          "MOBILE_NUMBER_CANT_BE_EMPTY_TXT": "Mobile number can't be empty",

          "NO": "No",
          "UPDATE_AVAILABLE": "Update Available",
          "UPDATE_NOW": "Update Now",
          "NEW_VERSION_ISAVAILABLE_MSG":
              "There is a newer version of app available please update it now.",
          "ARE_YOU_SURE_YOU_WANT_TO_LEAVE": "Are you sure you want to leave?",
          "DONT_HAVE_AN_ACCOUNT": "Don’t have an account? ",
          "WE_ARE_ALMOST_THERE_TXT": "We are almost there",
          "TELL_US_YOUR_BIRTHDATE": "Tell us your birthdate",
          "I_WAS_BORN_ON": "I was born on",
          "PROVIDE_YOUR_BIRTH_DATE": "Please provide your Birth date!",
          "PROFILE_UPDATED_SUCCESSFULLY": "Profile updated successfully!",
          "NICE_TO_MEET_YOU": "Nice to meet you",
          "PLEASE_PROVIDE_YOUR_IDENTITY": "Please provide your identity!",
          "HELP_US_MAKE_YOUR_JOURNEY_UNIQUE_TXT":
              "Help us make your journey unique",
          "NAME_CANT_BE_EMPTY": "Name can't be empty!",
          "LINK_YOUR_MOBILE": "Link your Mobile",
          "ACCOUNT_ALREADY_EXIST_WITH_THIS_MOBILE_NUMBER_TXT":
              "Account already exist with this mobile number.",
          "YOU_AGREE_TO_AAYU_TXT": "By continuing, you agree to Aayu ",
          "TERMS": "Terms",
          "PRIVACY_POLICY": "Privacy Policy.",
          "FOR_REACHING_OUT_MSG": "Thank you\nfor reaching out",
          "MOST_POWERFUL_THING_YOU_CAN_DO_FOR_YOURSELF":
              "Sometimes, its the most powerful thing you can do for yourself.",
          "CHECK_YOUR_PHONE_FOR_THE_VERIFICATION_CODE":
              "Please check your phone for the verification code.",
          "VERIFICATION_CODE_INVALID":
              "The sms verification code used is invalid",
          "THANK_YOU_FOR_REGISTERING": "Thank you for registering.",
          "GIVE_US_A_MOMENT_PERSONALIZE_SPACE":
              "Give us a moment, while we personalise your space",
          "GIVE_US_A_MOMENT_SET_UP_SPACE":
              "Give us a moment while we set up your space",
          "HOW_WAS_IT_FOR_YOU": "How was it for you?",
          "PLEASE_TELL_US_WHY": "Please tell us why",
          "YOUR_DAILY_PRACTICE_TIME_IS_SET_FOR":
              "Your daily practice time is set for ",
          "SET_A_TIME_FOR_YOUR_DAILY_PRACTICE":
              "Set a time for your daily practice.",
          "SAVE": "Save",
          "EMAIL_ID": "Email id",
          "DOWNLOADS": "Downloads",
          "OUR_OTHER_PROGRAMS": "Our Other Programs",
          "3.4": "3.4",
          "EDIT_PROFILE": "Edit Profile",
          "START_YOUR_HEALING_JOURNEY_MSG":
              "We look forward to helping you start your healing journey.",
          "SELECT_YOUR_GENDER": "Please select your gender",
          "EXPERTS_I_FOLLOW": "Experts I Follow",
          "YOU_HAVE_NOT_FOLLOWED_ANY_EXPERT_YET_MSG":
              "You have not followed\nany expert yet.",
          "FOLLOWERS": "Followers",
          "MY_FAVOURITES": "My Favourites",
          "YOU_HAVE_NO_FAVOURITES_ADDED_YET_TEXT":
              "You have no favourites added yet.\nGo on, add your first.",
          "GOT_SOMETHING_TO_TELL_US_TXT":
              "Got something to tell us? We are all ears!",
          "SELECT_CATEGORY": "Select Category",
          "SELECT_ISSUE": "Select Issue",
          "EXPLORE_AAYU": "Explore Aayu",
          "RESPONSE_TIME":
              "Thank you for contacting. We will connect you in next 48 Hours.",
          "FAILED_TO_SUBMIT_YOUR_REQUEST": "Failed to submit your request",
          "REQUEST_A_CALL_BACK": "Request a Call Back",
          "MY_SUBSCRIPTION": "My Subscription",
          "YOU_HAVE_NO_SUBSCRIPTIONS":
              "You have no active subscriptions currently.",
          "EXPLORE_AAYU_HEALING": "Explore Aayu Healing",
          "YOGA_THERAPIST": "Yoga Therapist",
          "DOCTOR_CONSULT": "Doctor Consult",
          "RENEW_NOW": "Renew Now",
          "START_TODAYS_PRACTICE": "Start Today’s Practice",
          "NOTIFICATIONS": "Notifications",
          "REMINDERS": "Reminders",
          "ANXIETY_CARE_PROGRAM": "Anxiety Care Program",
          "SETTINGS": "Settings",
          "LOGOUT": "Logout",
          "EDIT_MY_PROFILE": "Edit My Profile",
          "CLEAR_ALL": "Clear All",
          "TYPE": "TYPE",
          "EXIT_PLAYING": "Exit Playing",
          "VIEW_PROGRAM": "View Program",
          "HOW_ARE_YOU": "How are you?",
          "SIGN_UP": "Sign Up",
          "SELECT_THE_CATEGORY": "Select the category",
          "INVALID_OTP": "Invalid OTP!",
          "YOU_IDENTIFY_AS": "You identify as",
          "MOBILE_NUMBER": "Mobile number",
          "GENDER": "Gender",
          "YES": "Yes",
          "BIRTHDATE": "Birthdate",
          "CAMERA": "Camera",
          "GALLERY": "Gallery",
          "PROFILE_PHOTO": "Profile Photo",
          "HELP_SUPPORT": "Help & Support",
          "START_YOUR_ASSESMENT": "Start your assessment",
          "ANSWER_QUESTIONS_ABOUT_HEALTH":
              "Answer questions about your health to\nget your health insights.",
          "UNABLE_TO_REMOVE_PROFILE_PHOTO": "Unable to remove Profile photo!",
          "TELL_US_YOUR_NAME": "Tell us your name",
          "URL_NOT_AVAIALBLE": "Url not avaialble!",
          "UNDER_MAINTAINANCE": "Under\nMaintainance",
          "UNDER_SCHEDULED_MAINTENANCE_MSG":
              "We are under scheduled maintenance. Please come back later.",
          "ENTER_MOBILE_NO": "Enter your mobile number",
          "YOU_HAVE_NOT_DOWNLOADED_ANYTHING_YET":
              "You have not downloaded anything yet. Subscribe to Aayu to avail this feature.",
          "THE_SMS_VERIFICATION_CODE_USED_IS_INVALID":
              "The sms verification code used is invalid",
          "INVALID_VERIFICATION_PIN": "Invalid Verification Id/PIN!",
          "MY_MOBILE_NUMBER": "My mobile number",
          "HOW_DID_YOU_SLEEP_LAST_NIGHT": "How did you sleep last night?",
          "RESCHEDULE_MSG":
              "Want to reschedule? Do it 1 hour before the booked time slot.",
          "UPDATED_SUCCESSFULLY": "Updated Successfully!",
          "FAILED_TO_UPDATE_PROFILE": "Failed to update profile!",
          "TRACK_YOUR_SLEEP": "Track your sleep\ndaily at",
          "NOTIFY_YOU_15_MINUTES":
              "We’ll notify you 15 minutes\nbefore you start.",

          "FAILED_TO_UPDATE_DETAILS":
              "Failed to update details. Please try again!",
          "RECOMMENDED_FOR_YOU": "RECOMMENDED\nFOR YOU",

          // Internet Connectivity Text
          "NO_INTERNET_CONNECTION_MSG": "No internet connection found.",
          "MOBILE_DATA_DETECTED_BUT_NO_INTERNET_CONNECTION_FOUND":
              "Mobile data detected but no internet connection found.",
          "WIFI_DETECTED_BUT_NO_INTERNET_CONNECTION_FOUND":
              "Wifi detected but no internet connection found.",
          "CONNECTION_MSG":
              "Make sure you are connected to Wi-Fi or Mobile Network and try again.",
          "WOULD_YOU_LIKE_TO_SIGN_OUT_OF_AAYU_TXT":
              "Would you like to sign out of Aayu?",
          "COMPLETE_DOCTOR_CALL_BOOKED":
              "We value your interest to schedule another call with our doctor's. We request you to complete your scheduled/upcoming consultation and book your next slot.",
          "COMPLETE_THERAPIST_CALL_BOOKED":
              "We value your interest to schedule another call with our therapist's. We request you to complete your scheduled/upcoming consultation and book your next slot.",
          "COMPLETE_NUTRITIONIST_CALL_BOOKED":
              "We value your interest to schedule another call with our nutritionist. We request you to complete your scheduled/upcoming consultation and book your next slot.",
          "COMPLETE_PSYCHOLOGIST_CALL_BOOKED":
              "We value your interest to schedule another call with our counsellor. We request you to complete your scheduled/upcoming consultation and book your next slot."
        },
      };
}
