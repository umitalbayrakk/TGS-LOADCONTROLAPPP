import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:load_control/utils/colors.dart';

class AppBarWidgets extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;

  const AppBarWidgets({super.key, required this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(136.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.whiteSpot),
      backgroundColor: AppColors.snackBarRed,
      elevation: 8,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Image.asset(
              "assets/tgs.png",
              height: 200,
              width: 200,
            ),
          )
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: CustomSearchBar(
            onSearch: onSearch,
            hintText: 'Uçuş No, Ekip, Kuyruk ara...',
          ),
        ),
      ),
    );
  }
}


class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Ara...',
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.searcColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.whiteSpot.withOpacity(0.6)),
          prefixIcon: const Icon(FeatherIcons.search, color: AppColors.whiteSpot),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        style: const TextStyle(color: AppColors.whiteSpot),
        onChanged: (value) {
          widget.onSearch(value);
        },
      ),
    );
  }
}
