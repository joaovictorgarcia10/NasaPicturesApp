import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/home/home_presenter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePresenter presenter = GetItAdapter().get<HomePresenter>();

  @override
  void initState() {
    super.initState();
    presenter.getAllPictures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa Pictures'),
      ),
      body: ValueListenableBuilder(
        valueListenable: presenter.picturesNotifier,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final picture = value[index];
                return ListTile(title: Text(picture.title));
              },
            );
          }
        },
      ),
    );
  }
}
