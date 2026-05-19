class Sticker {
  final String code;
  final String team;
  final String type;
  final String group;
  bool isCollected;

  Sticker({
    required this.code,
    required this.team,
    required this.type,
    required this.group,
    this.isCollected = false,
  });
}
