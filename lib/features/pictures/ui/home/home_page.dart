import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';
 import 'package:nasa_pictures_app/features/pictures/ui/home/widgets/picture_list_tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final presenter = GetItAdapter().get<HomePresenter>();

  final textEditingController = TextEditingController();
  final scrollController = ScrollController();

  bool inTheEndOfList() => (scrollController.position.pixels ==
      scrollController.position.maxScrollExtent);

  @override
  void initState() {
    super.initState();
    presenter.getAllPictures();
    scrollController.addListener(() {
      if (inTheEndOfList() && presenter.shouldPaginate) {
        presenter.paginatePictures();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              controller: textEditingController,
              hintText: "Search pictures...",
              onChanged: (value) => presenter.search(value),
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: presenter.picturesNotifier,
          builder: (context, value, __) {
            // Validar o uso de um state pattern para manipular o estado
            if (value == null) {
              return const Center(child: Text("Nenhum item encontrado."));
            } else if (value.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    textEditingController.clear();
                    presenter.refreshPictures();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: value.length + 1,
                    itemBuilder: (context, index) {
                      if (index < value.length) {
                        final picture = value[index];

                        return PictureListTileWidget(
                          url: picture.url,
                          title: picture.title,
                          date: picture.date,
                        );
                      } else {
                        if (presenter.shouldPaginate) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
