import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelListCard extends StatelessWidget {
  final Key key;
  final String title;
  final IconData icon;
  final Function editCallback;

  LabelListCard({this.key, this.title, this.icon, this.editCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 8, right: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(icon),
                ),
                Text(
                  this.title,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: editCallback,
              icon: Icon(FontAwesomeIcons.solidEdit),
            ),
          ],
        ),
      ),
    );
  }
}
