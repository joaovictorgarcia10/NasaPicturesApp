import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/widgets/picture_list_tile_widget.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;

  const HomePage({
    Key? key,
    required this.presenter,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textEditingController = TextEditingController();
  final scrollController = ScrollController();

  bool inTheEndOfList() => (scrollController.position.pixels ==
      scrollController.position.maxScrollExtent);

  @override
  void initState() {
    super.initState();
    widget.presenter.getPictures();
    scrollController.addListener(() {
      if (inTheEndOfList() && widget.presenter.shouldPaginate.value) {
        widget.presenter.paginatePictures();
      }
    });
  }

  @override
  void dispose() {
    widget.presenter.state.dispose();
    widget.presenter.shouldPaginate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = widget.presenter;

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
              presenter.state,
              presenter.shouldPaginate,
            ],
          ),
          builder: (context, _) {
            final state = presenter.state.value;
            final shouldPaginate = presenter.shouldPaginate.value;

            if (state is HomeStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeStateSuccess) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    textEditingController.clear();
                    presenter.refreshPictures();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: state.pictures.length + 1,
                    itemBuilder: (context, index) {
                      if (index < state.pictures.length) {
                        final picture = state.pictures[index];
                        return PictureListTileWidget(
                          url: picture.url,
                          title: picture.title,
                          date: picture.date,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            "/details",
                            arguments: picture,
                          ),
                          iconButtonKey: Key("icon-button-key-$index"),
                        );
                      } else {
                        if (shouldPaginate) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              );
            }

            final errorState = state as HomeStateError;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorState.message),
                  TextButton(
                    onPressed: () {
                      textEditingController.clear();
                      presenter.getPictures();
                    },
                    child: const Text("Try again"),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
