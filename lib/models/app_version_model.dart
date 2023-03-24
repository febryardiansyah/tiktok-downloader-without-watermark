class AppVersionModel {
  final String? title;
  final VersionModel? version;
  final String? link;
  final List<String>? changeLogs;
  final bool? force;
  final bool? showUpdate;

  AppVersionModel({
    this.title,
    this.version,
    this.link,
    this.changeLogs,
    this.force,
    this.showUpdate,
  });

  factory AppVersionModel.fromMap(Map<String, dynamic> json) {
    return AppVersionModel(
      title: json['title'],
      version: VersionModel.fromMap(json['version']),
      link: json['link'],
      changeLogs: List<String>.from(json['change_logs']),
      force: json['force'],
      showUpdate: json['show_update'],
    );
  }
}

class VersionModel {
  final String? currentVersion;
  final String? newVersion;

  VersionModel({this.currentVersion, this.newVersion});
  factory VersionModel.fromMap(Map<String, dynamic> json) {
    return VersionModel(
      currentVersion: json['current_version'],
      newVersion: json['new_version'],
    );
  }
}
