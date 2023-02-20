class TiktokValidationModel {
  TiktokValidationModel({
    required this.version,
    required this.type,
    required this.title,
    required this.authorUrl,
    required this.authorName,
    required this.width,
    required this.height,
    required this.html,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.thumbnailUrl,
    required this.providerUrl,
    required this.providerName,
    required this.authorUniqueId,
    required this.embedProductId,
    required this.embedType,
  });

  String version;
  String type;
  String title;
  String authorUrl;
  String authorName;
  String width;
  String height;
  String html;
  int thumbnailWidth;
  int thumbnailHeight;
  String thumbnailUrl;
  String providerUrl;
  String providerName;
  String authorUniqueId;
  String embedProductId;
  String embedType;

  factory TiktokValidationModel.fromJson(Map<String, dynamic> json) =>
      TiktokValidationModel(
        version: json["version"],
        type: json["type"],
        title: json["title"],
        authorUrl: json["author_url"],
        authorName: json["author_name"],
        width: json["width"],
        height: json["height"],
        html: json["html"],
        thumbnailWidth: json["thumbnail_width"],
        thumbnailHeight: json["thumbnail_height"],
        thumbnailUrl: json["thumbnail_url"],
        providerUrl: json["provider_url"],
        providerName: json["provider_name"],
        authorUniqueId: json["author_unique_id"],
        embedProductId: json["embed_product_id"],
        embedType: json["embed_type"],
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
}
