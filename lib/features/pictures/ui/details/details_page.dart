import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final picture = ModalRoute.of(context)?.settings.arguments as Picture;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Center(
          child: Text(picture.title),
        ),
      ),
    );
  }
}
