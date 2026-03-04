import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/helpers/date_formater_extension.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/presenter/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/presenter/home_presenter.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/widgets/picture_list_tile_widget.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;

  const HomePage({super.key, required this.presenter});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  bool _isAtEndOfList() =>
      _scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent;

  @override
  void initState() {
    super.initState();
    widget.presenter.getPictures();
    _scrollController.addListener(() {
      if (_isAtEndOfList() && widget.presenter.shouldPaginate.value) {
        widget.presenter.paginatePictures();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.presenter.search(value);
    });
  }

  Future<void> _onFilterByDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
      helpText: 'Select a date',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (date != null && mounted) {
      _textController.clear();
      widget.presenter.filterByDate(date);
    }
  }

  Future<void> _onFilterByDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
      helpText: 'Select date range',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (range != null && mounted) {
      _textController.clear();
      widget.presenter.filterByDateRange(range.start, range.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final presenter = widget.presenter;

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 4.0, 8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    leading: const Icon(Icons.search),
                    controller: _textController,
                    hintText: "Search by title...",
                    onChanged: _onSearchChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: "Filter by specific date",
                  onPressed: _onFilterByDate,
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: "Filter by date range",
                  onPressed: _onFilterByDateRange,
                ),
              ],
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: Listenable.merge([
            presenter.state,
            presenter.shouldPaginate,
            presenter.isDateFiltered,
          ]),
          builder: (context, _) {
            final state = presenter.state.value;

            switch (state) {
              case HomeStateLoading():
                return const Center(child: CircularProgressIndicator());
              case HomeStateError():
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      TextButton(
                        onPressed: () {
                          _textController.clear();
                          presenter.getPictures();
                        },
                        child: const Text("Try again"),
                      ),
                    ],
                  ),
                );
              case HomeStateSuccess():
                final shouldPaginate = presenter.shouldPaginate.value;
                final isDateFiltered = presenter.isDateFiltered.value;

                return Column(
                  children: [
                    SizedBox(height: 25.0),
                    if (isDateFiltered)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.filter_alt, size: 18.0),
                            const SizedBox(width: 6.0),
                            const Expanded(
                              child: Text(
                                "Date filter active",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                _textController.clear();
                                presenter.refreshPictures();
                              },
                              icon: const Icon(Icons.close, size: 16.0),
                              label: const Text("Clear"),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _textController.clear();
                            presenter.refreshPictures();
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.pictures.length + 1,
                            itemBuilder: (context, index) {
                              if (index < state.pictures.length) {
                                final picture = state.pictures[index];
                                return PictureListTileWidget(
                                  url: picture.url,
                                  title: picture.title,
                                  date: picture.date.formatDate(picture.date),
                                  onPressed:
                                      () => Navigator.pushNamed(
                                        context,
                                        "/details",
                                        arguments: picture,
                                      ),
                                  iconButtonKey: Key("icon-button-key-$index"),
                                );
                              } else {
                                if (shouldPaginate) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Center(
                                    child: Text(
                                      "You've reached the end of the list",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
