List<Map<String, Object>> moodTrackingQuestions = [
  {
    "question": "How are you feeling today?",
    "answers": [
      {"text": "Very Happy", "value": "Very Happy", "selected": false},
      {"text": "Good", "value": "Good", "selected": false},
      {"text": "Just Ok", "value": "Just Ok", "selected": false},
      {"text": "Somewhat Bad", "value": "Somewhat Bad", "selected": false},
      {"text": "Terrible", "value": "Terrible", "selected": false}
    ],
    "isAnswered": false
  },
  {
    "question": "Identify the emotion?",
    "answers": [
      {"text": "Disliked", "value": "Disliked", "selected": false},
      {"text": "Anxious", "value": "Anxious", "selected": false},
      {"text": "Confused", "value": "Confused", "selected": false},
      {"text": "Insecured", "value": "Insecured", "selected": false},
      {"text": "Insulted", "value": "Insulted", "selected": false},
      {"text": "Numb", "value": "Numb", "selected": false},
      {"text": "Cheated", "value": "Cheated", "selected": false},
      {"text": "Frustrated", "value": "Frustrated", "selected": false},
      {"text": "Desperate", "value": "Desperate", "selected": false},
      {"text": "Embarassed", "value": "Embarassed", "selected": false},
      {"text": "Lost", "value": "Lost", "selected": false},
      {"text": "Awkward", "value": "Awkward", "selected": false},
      {"text": "Depressed", "value": "Depressed", "selected": false},
      {"text": "Horrified", "value": "Horrified", "selected": false},
      {"text": "Heartbroken", "value": "Heartbroken", "selected": false},
    ],
    "isAnswered": false
  },
  {
    "question": "Identify the Triggers",
    "answers": [
      {"text": "Aayu", "value": "Aayu", "selected": false},
      {"text": "Weather", "value": "Weather", "selected": false},
      {"text": "Entertainment", "value": "Entertainment", "selected": false},
      {"text": "Pets", "value": "Pets", "selected": false},
      {"text": "Money", "value": "Money", "selected": false},
      {"text": "Learning", "value": "Learning", "selected": false},
      {"text": "Progress", "value": "Progress", "selected": false},
      {"text": "Celebrating", "value": "Celebrating", "selected": false},
      {"text": "Sports", "value": "Sports", "selected": false},
      {"text": "Relaxation", "value": "Relaxation", "selected": false}
    ],
    "isAnswered": false
  },
];

List<Map<String, Object>> moodTrackingInsights = [
  {"duration": "1 Week", "selected": false},
  {"duration": "1 Month", "selected": false},
  {"duration": "6 Months", "selected": false},
  {"duration": "1 Year", "selected": false},
  {"duration": "All time", "selected": false},
];


Map<String, List<String>> moodTrackingInsightOptions = {
  "mostMarkedMoods":["Very Happy", "Good", "Just Ok"],
    "mostUsedEmotions":["Frustrated", "Awkward"],
    "mostUsedTriggers":["Entertainment", "Learning", "Relaxation"]
};