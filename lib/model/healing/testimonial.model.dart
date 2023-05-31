///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class TestimonialResponseTestimonials {
/*
{
  "userId": "1",
  "userName": "Mahesh Karande",
  "profileImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/profile/mahesh.jpg",
  "age": "35",
  "city": "Mumbai",
  "testimonial": "I am a 35 year old man, had Type 2 Diabetes for 15 years and was on oral hypoglycaemic drugs ever ..."
} 
*/

  String? userId;
  String? userName;
  String? profileImage;
  String? age;
  String? city;
  String? testimonial;

  TestimonialResponseTestimonials({
    this.userId,
    this.userName,
    this.profileImage,
    this.age,
    this.city,
    this.testimonial,
  });
  TestimonialResponseTestimonials.fromJson(Map<String, dynamic> json) {
    userId = json['userId']?.toString();
    userName = json['userName']?.toString();
    profileImage = json['profileImage']?.toString();
    age = json['age']?.toString();
    city = json['city']?.toString();
    testimonial = json['testimonial']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['profileImage'] = profileImage;
    data['age'] = age;
    data['city'] = city;
    data['testimonial'] = testimonial;
    return data;
  }
}

class TestimonialResponse {
/*
{
  "testimonials": [
    {
      "userId": "1",
      "userName": "Mahesh Karande",
      "profileImage": "https://resetcontent.s3.ap-south-1.amazonaws.com/healing/profile/mahesh.jpg",
      "age": "35",
      "city": "Mumbai",
      "testimonial": "I am a 35 year old man, had Type 2 Diabetes for 15 years and was on oral hypoglycaemic drugs ever ..."
    }
  ]
} 
*/

  List<TestimonialResponseTestimonials?>? testimonials;

  TestimonialResponse({
    this.testimonials,
  });
  TestimonialResponse.fromJson(Map<String, dynamic> json) {
  if (json['testimonials'] != null) {
  final v = json['testimonials'];
  final arr0 = <TestimonialResponseTestimonials>[];
  v.forEach((v) {
  arr0.add(TestimonialResponseTestimonials.fromJson(v));
  });
    testimonials = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (testimonials != null) {
      final v = testimonials;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['testimonials'] = arr0;
    }
    return data;
  }
}