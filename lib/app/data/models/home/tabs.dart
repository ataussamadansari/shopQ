class Tabs {
  final String? key;
  final String? label;
  final String? icon;
  final String? themeColor;

  Tabs({
    this.key,
    this.label,
    this.icon,
    this.themeColor,
  });

  factory Tabs.fromJson(Map<String, dynamic> json) {
    return Tabs(
      key: json['key'],
      label: json['label'],
      icon: json['icon'],
      themeColor: json['themeColor'],
    );
  }
}