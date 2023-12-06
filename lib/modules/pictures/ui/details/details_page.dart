import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var hasImage = true;

  @override
  Widget build(BuildContext context) {
    final picture = ModalRoute.of(context)?.settings.arguments as Picture;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: picture.url,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                  child: const Icon(Icons.error_outline_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    const Divider(),
                    const SizedBox(height: 20.0),
                    Text(picture.title),
                    const SizedBox(height: 5.0),
                    Text(picture.date),
                    const SizedBox(height: 20.0),
                    Text(picture.explanation),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
