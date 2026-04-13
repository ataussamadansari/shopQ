import 'package:get/get.dart';

class TabItem {
  final String title;
  final String image;

  TabItem({required this.title, required this.image});
}

class HomeController extends GetxController {
  List<TabItem> tabs = [];
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    loadTabs();
  }

  void loadTabs() async {
    await Future.delayed(Duration(seconds: 1));

    /// 🔥 backend data (example)
    tabs = [
      TabItem(title: "All", image: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png"),
      TabItem(title: "Deals", image: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png"),
      TabItem(title: "Fresh", image: "https://cdn-icons-png.flaticon.com/512/415/415733.png"),
      TabItem(title: "Electronics", image: "https://cdn-icons-png.flaticon.com/512/1041/1041880.png"),
      TabItem(title: "All", image: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png"),
      TabItem(title: "Deals", image: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png"),
      TabItem(title: "Fresh", image: "https://cdn-icons-png.flaticon.com/512/415/415733.png"),
      TabItem(title: "Electronics", image: "https://cdn-icons-png.flaticon.com/512/1041/1041880.png"),
      TabItem(title: "All", image: "https://cdn-icons-png.flaticon.com/512/1046/1046784.png"),
      TabItem(title: "Deals", image: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png"),
      TabItem(title: "Fresh", image: "https://cdn-icons-png.flaticon.com/512/415/415733.png"),
      TabItem(title: "Electronics", image: "https://cdn-icons-png.flaticon.com/512/1041/1041880.png"),
    ];

    update();
  }

  void changeTab(int index) {
    selectedIndex = index;
    update();
  }
}