import 'package:flutter/material.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';

class TikTokPreview extends StatelessWidget {
  final TiktokValidationModel data;
  final Function()? onTap;
  const TikTokPreview({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(data.thumbnailUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data.authorName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onTap != null)
                      GestureDetector(
                        onTap: onTap,
                        child: const Icon(Icons.more_vert),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.title!,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
