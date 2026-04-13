import 'tabs.dart';
import 'section_model.dart';

class HomeData {
  List<Tabs>? tabs;
  List<SectionModel>? sections;

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['tabs'] != null) {
      tabs = (json['tabs'] as List)
          .map((e) => Tabs.fromJson(e))
          .toList();
    }

    if (json['sections'] != null) {
      sections = (json['sections'] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList();
    }
  }
}