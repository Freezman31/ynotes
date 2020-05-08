import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/animations/FadeAnimation.dart';
import 'package:ynotes/landGrades.dart';
import 'package:ynotes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/UI/gradesPage.dart';
import 'package:ynotes/usefulMethods.dart';

Color textButtonColor = Color(0xff252B62);
Color myColor = Color(0xff00bfa5);

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  Future<String> connectionData;
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _isFirstUse = true;
  String _obligationText = "";

  @override
  initState() {
    //tryToConnect();
    getFirstUse();
  }

  getFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstUse = prefs.getBool('firstUse') ?? true;
  }

  tryToConnect() async {
    String u = await storage.read(key: "username");
    String p = await storage.read(key: "password");
    if (u != null && p != null) {
      connectionData = connectionStatus(u, p);
      openLoadingDialog();
    }
  }

  openAlertBox() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                width: screenSize.size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Conditions d’utilisation",
                          style: TextStyle(fontSize: 24.0, fontFamily: "Asap"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10, bottom: 10),
                        child: SingleChildScrollView(
                            child: Container(
                          child: Text(
                            "En utilisant cette application ainsi que les services tiers vous acceptez et comprenez les conditions suivantes :\n- Mon identifiant ainsi que mon mot de passe ne sont pas enregistrés sur des serveurs, seulement sur votre appareil. Mais vous vous portez responsables en cas de perte de ces derniers.\n - YNote ne se porte pas responsable en cas de suppression ou altération de la qualité de votre compte EcoleDirecte par une entité externe.\n - YNote est un client libre et gratuit et non officiel\n - YNote n’est en aucun cas affilié ou relié à une quelconque entité\n - EcoleDirecte est un produit de la société STATIM",
                            style: TextStyle(
                              fontFamily: "Asap",
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ))),
                    RaisedButton(
                      padding: EdgeInsets.only(
                          left: 60, right: 60, top: 15, bottom: 18),
                      color: Color(0xff27AE60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(router(carousel()));
                      },
                      child: Text(
                        "J'accepte",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openLoadingDialog() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                padding:
                    EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: connectionData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                            if (_isFirstUse == true) {
                              openAlertBox();
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(router(homePage()));
                            }
                          });
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.lightGreen,
                              ),
                              Text(
                                snapshot.data,
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            children: <Widget>[
                              Icon(
                                Icons.error,
                                size: MediaQuery.of(context).size.width / 5,
                                color: Colors.redAccent,
                              ),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else {
                          return Container(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xff444A83),
                              ));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

//BEGINNING OF THE STYLE OF THE WINDOW
    return Container(
      color:Color(0xFF252B62) ,
          child: SafeArea(
        
          child: Container(
              height: screenSize.size.height -
                  screenSize.padding.top -
                  screenSize.padding.bottom,
              decoration: BoxDecoration(color: Color(0xFF252B62)),
              child: SingleChildScrollView(
                child: Container(
                    height: screenSize.size.height -
                        screenSize.padding.top -
                        screenSize.padding.bottom,
                    width: screenSize.size.width,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: screenSize.size.width / 5 * 0.4,
                          bottom: screenSize.size.height / 10 * 5 +
                              screenSize.size.width / 5 * 0.6,
                          child: Transform.rotate(
                              angle: -0.2,
                              child: FadeAnimation(
                                  0.7,
                                  Icon(
                                    MdiIcons.emoticonHappyOutline,
                                    size: screenSize.size.width / 5 * 0.8,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          left: screenSize.size.width / 5 * 2,
                          bottom: screenSize.size.height / 10 * 0.4,
                          child: Transform.rotate(
                              angle: 0.3,
                              child: FadeAnimation(
                                  0.71,
                                  Icon(
                                    MdiIcons.bookshelf,
                                    size: screenSize.size.width / 5 * 0.8,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          left: -screenSize.size.width / 5 * 0.2,
                          bottom: screenSize.size.height / 10 * 0.9,
                          child: Transform.rotate(
                              angle: -0.1,
                              child: FadeAnimation(
                                  0.72,
                                  Icon(
                                    MdiIcons.information,
                                    size: screenSize.size.width / 5 * 1,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          left: screenSize.size.width / 5 * 1.5,
                          top: screenSize.size.height / 10 * 1.2,
                          child: Transform.rotate(
                              angle: 0.2,
                              child: FadeAnimation(
                                  0.73,
                                  Icon(
                                    MdiIcons.starCircle,
                                    size: screenSize.size.width / 5 * 0.95,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          right: screenSize.size.width / 5 * -0.1,
                          bottom: screenSize.size.height / 10 * 0.5,
                          child: Transform.rotate(
                              angle: -0.4,
                              child: FadeAnimation(
                                  0.74,
                                  Icon(
                                    MdiIcons.schoolOutline,
                                    size: screenSize.size.width / 5 * 1.2,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          left: screenSize.size.width / 5 * 0.1,
                          top: screenSize.size.height / 10 * 0.1,
                          child: Transform.rotate(
                              angle: 0,
                              child: FadeAnimation(
                                  0.75,
                                  Icon(
                                    MdiIcons.pencil,
                                    size: screenSize.size.width / 5 * 0.7,
                                    color: Colors.white.withOpacity(0.2),
                                  ))),
                        ),
                        Positioned(
                          right: screenSize.size.width / 5 * 0.25,
                          top: screenSize.size.height / 10 * 0.15,
                          child: Transform.rotate(
                              angle: 0,
                              child: Image(
                                  image: AssetImage(
                                      'assets/images/LogoYNotes.png'), width: screenSize.size.width / 5 * 0.7,)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FadeAnimation(
                            0.8,
                            Container(
                              width: screenSize.size.width / 5 * 4,
                              height: screenSize.size.height / 10 * 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25)),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Bienvenue sur YNotes",
                                            style: TextStyle(
                                                fontFamily: 'Asap',
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenSize.size.width /
                                                    5 *
                                                    0.32,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          width: screenSize.size.width / 5 * 3,
                                          child: Text(
                                            "Connectez vous à votre espace scolaire",
                                            style: TextStyle(
                                                fontFamily: 'Asap',
                                                fontSize: screenSize.size.width /
                                                    5 *
                                                    0.22,
                                                color: Colors.black),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenSize.size.height / 10 * 0.3,
                                      left: screenSize.size.height / 10 * 0.4,
                                      bottom: screenSize.size.height / 10 * 0.1,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Identifiant",
                                          style: TextStyle(
                                              fontFamily: 'Asap',
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(_obligationText,
                                            style: TextStyle(color: Colors.red))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.size.width / 5 * 3.2,
                                    margin: EdgeInsets.only(
                                      left: screenSize.size.height / 10 * 0.1,
                                    ),
                                    height: screenSize.size.height / 10 * 0.4,
                                    child: TextFormField(
                                      controller: _username,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: screenSize.size.height / 10 * 0.3,
                                      left: screenSize.size.height / 10 * 0.4,
                                      bottom: screenSize.size.height / 10 * 0.1,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Mot de passe",
                                          style: TextStyle(
                                              fontFamily: 'Asap',
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenSize.size.width / 5 * 3.2,
                                    margin: EdgeInsets.only(
                                      left: screenSize.size.height / 10 * 0.1,
                                    ),
                                    height: screenSize.size.height / 10 * 0.4,
                                    child: TextFormField(
                                      controller: _password,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                        width: screenSize.size.width / 5 * 1.8,
                                        height:
                                            screenSize.size.height / 10 * 0.55,
                                        margin: EdgeInsets.only(
                                            top: screenSize.size.height /
                                                10 *
                                                0.55,
                                            right:
                                                screenSize.size.width / 5 * 0.3),
                                        child: GestureDetector(
                                          onTapDown: (details) {
                                            setState(() {
                                              textButtonColor = Colors.white;
                                            });
                                          },
                                          onTapCancel: () {
                                            setState(() {
                                              textButtonColor = Color(0xff252B62);
                                            });
                                          },
                                          child: OutlineButton(
                                            color: Color(0xff252B62),
                                            highlightColor: Color(0xff252B62),
                                            focusColor: Color(0xff252B62),
                                            borderSide: BorderSide(
                                                color: Color(0xff252B62)),
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                            highlightedBorderColor:
                                                Color(0xff252B62),
                                            onPressed: () {
                                              //Actions when pressing the ok button
                                              if (_username.text != "") {
                                                connectionData = connectionStatus(
                                                    _username.text,
                                                    _password.text);
                                                openLoadingDialog();
                                              } else {
                                                _obligationText =
                                                    " (obligatoire)";
                                                setState(() {});
                                              }
                                            },
                                            child: Text(
                                              "Allons-y",
                                              style: TextStyle(
                                                  fontFamily: "Asap",
                                                  fontSize:
                                                      screenSize.size.width /
                                                          5 *
                                                          0.3,
                                                  fontWeight: FontWeight.bold,
                                                  color: textButtonColor),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ))),
    );
  }
}

//Planet widget
class Planet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return Stack(children: <Widget>[
      Positioned.fill(
        left: 70,
        top: (screenSize.size.height) / 1.6,
        child: Stack(children: <Widget>[
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.8, 150, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(800.0)),
              color: Color(0xffE1BAA3),
              child: Container(
                width: 326,
                height: 318,
              ),
            ),
          ),
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.7, 270, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(500.0)),
              color: Color(0xffEBCDBC),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                  borderRadius: BorderRadius.all(Radius.circular(500.0)),
                ),
                width: 74,
                height: 71,
              ),
            ),
          ),
          Container(
            transform:
                Matrix4.translationValues(screenSize.size.width / 1.45, 170, 0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(500.0)),
              color: Color(0xffEBCDBC),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 8.0, color: const Color(0xFFC5A492)),
                  borderRadius: BorderRadius.all(Radius.circular(500.0)),
                ),
                width: 74,
                height: 71,
              ),
            ),
          ),
        ]),
      )
    ]);
  }
}
