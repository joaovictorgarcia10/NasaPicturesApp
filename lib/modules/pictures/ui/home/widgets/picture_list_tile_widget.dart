import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PictureListTileWidget extends StatelessWidget {
  final String url;
  final String title;
  final String date;
  final VoidCallback onPressed;
  final Key iconButtonKey;

  const PictureListTileWidget({
    Key? key,
    required this.url,
    required this.title,
    required this.date,
    required this.onPressed,
    required this.iconButtonKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListTile(
              leading: CachedNetworkImage(
                height: 90.0,
                width: 90.0,
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(
                  Icons.error_outline_rounded,
                ),
              ),
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(date),
              trailing: IconButton(
                key: iconButtonKey,
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
