import 'package:flutter/material.dart';
import 'about.dart';
import 'info.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;

  const BaseAppBar({Key key, this.title, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: Info(), //Info.id,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      color: const Color(0xff01A0C7),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Info'),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: About(), //About.id,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.code,
                      color: const Color(0xff01A0C7),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('About'),
                    ),
                  ],
                ),
              ),
            ];
          },
          elevation: 4,
          onSelected: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => value),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
