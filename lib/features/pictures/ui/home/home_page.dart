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
      if (inTheEndOfList() && presenter.shouldPaginate.value) {
        presenter.paginatePictures();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              controller: textEditingController,
              hintText: "Search pictures...",
              onChanged: (value) => presenter.search(value),
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: Listenable.merge(
            [
              presenter.picturesNotifier,
              presenter.shouldPaginate,
            ],
          ),
          builder: (context, _) {
            final pictures = presenter.picturesNotifier.value;
            final shouldPaginate = presenter.shouldPaginate.value;

            if (pictures == null) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No items found."),
                  TextButton(
                    onPressed: () => presenter.getAllPictures(),
                    child: const Text("Try again"),
                  )
                ],
              ));
            } else if (pictures.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    textEditingController.clear();
                    presenter.refreshPictures();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: pictures.length + 1,
                    itemBuilder: (context, index) {
                      if (index < pictures.length) {
                        final picture = pictures[index];
                        return PictureListTileWidget(
                          url: picture.url,
                          title: picture.title,
                          date: picture.date,
                        );
                      } else {
                        if (shouldPaginate) {
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
