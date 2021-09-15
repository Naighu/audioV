import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppNavbar extends StatelessWidget {
  final String page;
  const AppNavbar({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcons(context, Iconsax.music_library_2, "audios",
              onPressed: () {}),
          _navIcons(context, Iconsax.video_play, "videos", onPressed: () {}),
          _navIcons(context, Iconsax.music_filter, "playlist",
              onPressed: () {}),
        ],
      ),
    );
  }

  Widget _navIcons(BuildContext context, IconData icon, String label,
      {required Function() onPressed}) {
    bool selected = page.toLowerCase() == label.toLowerCase();
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: selected ? Color(0xFF898989) : Colors.transparent),
      child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: !selected
                ? Theme.of(context).iconTheme.color
                : Color(0xFFF0F0F0),
          ),
          label: Text(label,
              style: TextStyle(
                  color: !selected
                      ? Theme.of(context).iconTheme.color
                      : Color(0xFFF0F0F0)))),
    );
  }
}
