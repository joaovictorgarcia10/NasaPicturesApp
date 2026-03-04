import 'package:flutter/material.dart';

class PicturesAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  /// Controller for the search text field.
  final TextEditingController textController;

  /// Called whenever the search field value changes.
  final ValueChanged<String> onSearchChanged;

  /// Called when the user taps "Filter by specific date".
  final VoidCallback onFilterByDate;

  /// Called when the user taps "Filter by date range".
  final VoidCallback onFilterByDateRange;

  static const Duration _animDuration = Duration(milliseconds: 200);

  const PicturesAppBarWidget({
    super.key,
    required this.textController,
    required this.onSearchChanged,
    required this.onFilterByDate,
    required this.onFilterByDateRange,
  });

  @override
  Size get preferredSize => Size.fromHeight(180.0);

  @override
  State<PicturesAppBarWidget> createState() => _PicturesAppBarWidgetState();
}

class _PicturesAppBarWidgetState extends State<PicturesAppBarWidget> {
  bool _showFilters = false;

  void _toggleFilters() {
    if (_showFilters) {
      setState(() => _showFilters = false);
    } else {
      setState(() => _showFilters = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  controller: widget.textController,
                  hintText: 'Search by title...',
                  onChanged: widget.onSearchChanged,
                ),
              ),
              SizedBox(width: 10.0),
              IconButton(
                tooltip: _showFilters ? 'Hide filters' : 'Show filters',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list,
                  ),
                ),
                onPressed: _toggleFilters,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          AnimatedContainer(
            duration: PicturesAppBarWidget._animDuration,
            curve: Curves.easeInOut,
            height: _showFilters ? 48.0 : 0.0,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text("Filter by date"),
                  onPressed: widget.onFilterByDate,
                ),
                const SizedBox(width: 8.0),
                OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: const Text("Filter by date range"),
                  onPressed: widget.onFilterByDateRange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
