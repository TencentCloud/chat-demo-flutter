class CustomEmojiFaceData {
  CustomEmojiFaceData(
      {required this.name,
      required this.icon,
      required this.list,
      this.isEmoji});

  late final String name;
  late final String icon;
  late List<String> list;
  bool? isEmoji = false;

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'list': list,
        'isEmoji': isEmoji ?? false,
      };

  CustomEmojiFaceData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    list = json['list'];
    isEmoji = json['isEmoji'];
  }
}
