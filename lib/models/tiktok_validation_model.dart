class TiktokValidationModel {
  TiktokValidationModel({
    this.version,
    this.type,
    this.title,
    this.authorUrl,
    this.authorName,
    this.width,
    this.height,
    this.html,
    this.thumbnailWidth,
    this.thumbnailHeight,
    this.thumbnailUrl,
    this.providerUrl,
    this.providerName,
    this.authorUniqueId,
    this.embedProductId,
    this.embedType,
    this.videoUrl,
    this.videoPath,
    this.createdAt,
  });

  String? version;
  String? type;
  String? title;
  String? authorUrl;
  String? authorName;
  String? width;
  String? height;
  String? html;
  int? thumbnailWidth;
  int? thumbnailHeight;
  String? thumbnailUrl;
  String? providerUrl;
  String? providerName;
  String? authorUniqueId;
  String? embedProductId;
  String? embedType;
  String? videoUrl;
  String? videoPath;
  DateTime? createdAt;

  factory TiktokValidationModel.fromJson(Map<String, dynamic> json) =>
      TiktokValidationModel(
        version: json["version"] ?? null,
        type: json["type"] ?? null,
        title: json["title"] ?? null,
        authorUrl: json["author_url"] ?? null,
        authorName: json["author_name"] ?? null,
        width: json["width"] ?? null,
        height: json["height"] ?? null,
        html: json["html"] ?? null,
        thumbnailWidth: json["thumbnail_width"] ?? null,
        thumbnailHeight: json["thumbnail_height"] ?? null,
        thumbnailUrl: json["thumbnail_url"] ?? null,
        providerUrl: json["provider_url"] ?? null,
        providerName: json["provider_name"] ?? null,
        authorUniqueId: json["author_unique_id"] ?? null,
        embedProductId: json["embed_product_id"] ?? null,
        embedType: json["embed_type"] ?? null,
      );

  factory TiktokValidationModel.fromSqlite(Map<String, dynamic> json) =>
      TiktokValidationModel(
        type: json["type"] ?? null,
        title: json["title"] ?? null,
        authorUrl: json["author_url"] ?? null,
        authorName: json["author_name"] ?? null,
        thumbnailUrl: json["thumbnail_url"] ?? null,
        videoUrl: json['video_url'] ?? null,
        videoPath: json['video_path'] ?? null,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "type": type,
        "title": title,
        "author_url": authorUrl,
        "author_name": authorName,
        "width": width,
        "height": height,
        "html": html,
        "thumbnail_width": thumbnailWidth,
        "thumbnail_height": thumbnailHeight,
        "thumbnail_url": thumbnailUrl,
        "provider_url": providerUrl,
        "provider_name": providerName,
        "author_unique_id": authorUniqueId,
        "embed_product_id": embedProductId,
        "embed_type": embedType,
      };

  Map<String, dynamic> toSqlite() => {
        "type": type,
        "title": title,
        "author_url": authorUrl,
        "author_name": authorName,
        "thumbnail_url": thumbnailUrl,
        "video_url": videoUrl,
        "video_path": videoPath,
        "created_at": createdAt?.toIso8601String(),
      };
}
