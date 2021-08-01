import 'package:flutter/material.dart';
import '../pages/leyenda.dart';
import '../pages/about.dart';
import '../pages/donate.dart';
import '../pages/info.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;

  const BaseAppBar({Key key, this.title, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(child: title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.help, color: Colors.white),
          onPressed: () {
            return Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Leyenda()),
            );
          },
        ),
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
              PopupMenuItem(
                value: DonationPage(), //About.id,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.local_cafe,
                      color: const Color(0xff01A0C7),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Colaborar'),
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
