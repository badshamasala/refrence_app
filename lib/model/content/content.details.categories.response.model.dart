import 'package:aayu/model/grow/grow.page.content.model.dart';

class ContentDetailsCategoriesResponse {
  List<ContentCategories?>? categories;
  ContentDetailsCategoriesResponse({
    this.categories,
  });
  ContentDetailsCategoriesResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      final v = json['categories'];
      final arr0 = <ContentCategories>[];
      v.forEach((v) {
        arr0.add(ContentCategories.fromJson(v));
      });
      categories = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (categories != null) {
      final v = categories;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['categories'] = arr0;
    }
    return data;
  }
}
