import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;

import 'package:flutter/widgets.dart';
import 'package:notes/services/sharedPref.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/cards.dart';
import '../services/database.dart';

class SettingsPage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  Function() triggerRefetch;
  SettingsPage(
      {Key key,
      Function(Brightness brightness) changeTheme,
      Function() triggerRefetch})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.triggerRefetch = triggerRefetch;
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedTheme;
  @override
  Widget build(BuildContext context) {
    setState(() {
      if (Theme.of(context).brightness == Brightness.dark) {
        selectedTheme = 'dark';
      } else {
        selectedTheme = 'light';
      }
    });

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding:
                        const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Icon(OMIcons.arrowBack)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                child: buildHeaderWidget(context),
              ),
              buildCardWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('App Theme',
                      style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24)),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 'light',
                        groupValue: selectedTheme,
                        onChanged: handleThemeSelection,
                      ),
                      Text(
                        'Light theme',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 'dark',
                        groupValue: selectedTheme,
                        onChanged: handleThemeSelection,
                      ),
                      Text(
                        'Dark theme',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              )),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          title: Text('Delete Note'),
                          content:
                              Text('All notes will be deleted permanently'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('DELETE',
                                  style: prefix0.TextStyle(
                                      color: Colors.red.shade300,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1)),
                              onPressed: () async {
                                await NotesDatabaseService.db
                                    .deleteAllNotesInDB();
                                widget.triggerRefetch();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text('CANCEL',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                },
                child: DeleteAllNotesCardComponent(),
              ),
              buildCardWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('About app',
                      style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                  Container(
                    height: 20,
                  ),
                  Center(
                    child: Text('Version: 1.0.0',
                        style: TextStyle(
                            fontFamily: 'ZillaSlab',
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text('Provided by'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1)),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Text(
                      'Snowclare Innovations',
                      style: TextStyle(fontFamily: 'ZillaSlab', fontSize: 24),
                    ),
                  )),
                  Container(
                    height: 15,
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: _launchURL,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                                fontFamily: 'ZillaSlab',
                                fontSize: 16,
                                color: colorList.elementAt(0)),
                          ),
                        )),
                  ),
                ],
              ))
            ],
          ))
        ],
      ),
    );
  }

  _launchURL() async {
    var privacyPolicyUrl =
        'https://snowclare.github.io/country_flags/matrix_notes_privacy_policy/';
    if (await canLaunch(privacyPolicyUrl)) {
      await launch(privacyPolicyUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  Widget buildCardWidget(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 8),
                color: Colors.black.withAlpha(20),
                blurRadius: 16)
          ]),
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
      child: Text(
        'Settings',
        style: TextStyle(
            fontFamily: 'ZillaSlab',
            fontWeight: FontWeight.w700,
            fontSize: 36,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  void handleThemeSelection(String value) {
    setState(() {
      selectedTheme = value;
    });
    if (value == 'light') {
      widget.changeTheme(Brightness.light);
    } else {
      widget.changeTheme(Brightness.dark);
    }
    setThemeinSharedPref(value);
  }

  void openGitHub() {
    launch('https://www.github.com/roshanrahman');
  }
}
