import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ynotes/UI/components/modalBottomSheets/disciplinesModalBottomSheet.dart';
import 'package:ynotes/UI/components/modalBottomSheets/gradesModalBottomSheet.dart';
import 'package:ynotes/main.dart';

import '../../classes.dart';
import '../../usefulMethods.dart';

class GradesPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _GradesPageState();
  }
}

double average = 0.0;
//This boolean show a little badge if true
bool newGrades = false;
//The periode to show at start
String periodeToUse = "";
//Filter to use
String filter = "all";
//If true, show a carousel
bool firstStart = true;
Future disciplinesListFuture;
int initialIndexGradesOffset = 0;
List specialties;
List<Period> periods;

class _GradesPageState extends State<GradesPage> {
  ItemScrollController gradesItemScrollController = ItemScrollController();
  void initState() {
    super.initState();

    initializeDateFormatting("fr_FR", null);

    //getListSpecialties();
    refreshLocalGradeListWithoutForce();
    //Get the actual periode (based on grades)
    getActualPeriode();
    getListSpecialties();
  }

  getListSpecialties() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        specialties = prefs.getStringList("listSpecialties");
      });
    }
  }

  @override
  Future<void> refreshLocalGradeList() async {
    setState(() {
      allGradesOld = null;
      disciplinesListFuture = localApi.getGrades(forceReload: true);
    });
    var realdisciplinesListFuture = await disciplinesListFuture;
  }

  Future<void> refreshLocalGradeListWithoutForce() async {
    setState(() {
      disciplinesListFuture = localApi.getGrades();
    });
    var realdisciplinesListFuture = await disciplinesListFuture;
  }

  //Get the actual periode
  getActualPeriode() async {
    List<Discipline> list = await localApi.getGrades();
    try {
      periodeToUse = list.lastWhere((list) => list.gradesList.length > 0).gradesList.last.nomPeriode;
    } catch (e) {
      if (periods != null && periods.length > 0) {
        periodeToUse = periods.last.name;
      }
      print("Error while returning actual periode");
    }
  }

  openSortBox() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              height: screenSize.size.height / 10 * 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(),
                    child: Material(
                      color: Color(0xff252B62),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "spécialités";
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/space/space.png'),
                              width: screenSize.size.width / 5 * 0.8,
                            ),
                            Container(
                              width: screenSize.size.width / 5 * 2.5,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Mes spécialités",
                                  style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500, fontFamily: "Asap", color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Material(
                      color: Color(0xff42735B),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "sciences";
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Icon(
                                  MdiIcons.atomVariant,
                                  size: screenSize.size.width / 5 * 0.5,
                                  color: Colors.white,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                              child: Text(
                                "Sciences",
                                style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500, fontFamily: "Asap", color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Material(
                      color: Color(0xff6C4273),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "littérature";
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Icon(
                                  MdiIcons.bookOpenVariant,
                                  size: screenSize.size.width / 5 * 0.5,
                                  color: Colors.white,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                              child: Text(
                                "Littérature",
                                style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500, fontFamily: "Asap", color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(),
                    child: Material(
                      color: isDarkModeEnabled ? Colors.white10 : Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "all";
                            Navigator.pop(context);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                child: Icon(
                                  MdiIcons.borderNoneVariant,
                                  size: screenSize.size.width / 5 * 0.5,
                                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.2),
                              child: Text(
                                "Aucun filtre",
                                style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///Calculate the user average
  void setAverage(List<Discipline> disciplineList) {
    average = 0;
    double counter = 0.0;
    disciplineList.where((i) => i.periode == periodeToUse).forEach((f) {
      try {
        var doubleAverage = double.tryParse(f.moyenne.replaceAll(',', '.'));
        if (doubleAverage != null) {
          average += doubleAverage;
          counter += 1;
        }
      } catch (e) {}
    });

    average = average / counter;
  }

  ///Get the corresponding disciplines and responding to the filter chosen
  List<Discipline> getDisciplinesForPeriod(List<Discipline> list, periode, String sortBy) {
    List<Discipline> toReturn = new List<Discipline>();
    list.forEach((f) {
      switch (sortBy) {
        case "all":
          if (f.periode == periode) {
            toReturn.add(f);
          }
          break;
        case "littérature":
          if (chosenParser == 0) {
            List<String> codeMatiere = ["FRANC", "HI-GE", "AGL1", "ESP2"];

            if (f.periode == periode &&
                codeMatiere.any((test) {
                  if (test == f.codeMatiere) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = ["FRANCAIS", "ANGLAIS", "ESPAGNOL", "ALLEMAND", "HISTOIRE", "PHILO"];

            if (f.periode == periode &&
                codeMatiere.any((test) {
                  if (f.nomDiscipline.contains(test)) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          }

          break;
        case "sciences":
          if (chosenParser == 0) {
            List<String> codeMatiere = ["SVT", "MATHS", "G-SCI", "PH-CH"];
            if (f.periode == periode &&
                codeMatiere.any((test) {
                  if (test == f.codeMatiere) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            List<String> codeMatiere = ["SVT", "MATH", "PHY", "PHYSIQUE", "SCI", "BIO"];
            List<String> blackList = ["SPORT"];
            if (f.periode == periode &&
                codeMatiere.any((test) {
                  if (f.nomDiscipline.contains(test) && !blackList.any((element) => f.nomDiscipline.contains(element))) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          }
          break;
        case "spécialités":
          if (specialties != null) {
            if (f.periode == periode &&
                specialties.any((test) {
                  if (test == f.nomDiscipline) {
                    return true;
                  } else {
                    return false;
                  }
                })) {
              toReturn.add(f);
            }
          } else {
            debugPrint("Specialties list is null");
          }
          break;
      }
    });
    setAverage(toReturn);
    return toReturn;
  }

  ///Start building grades box from here
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController controller = ScrollController();

    ///Button container
    return Container(
      height: screenSize.size.height,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.3),
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 6),
                height: screenSize.size.height / 10 * 0.7,
                width: screenSize.size.width / 5 * 4.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  border: Border.all(width: 0.00000, color: Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                      width: (screenSize.size.width / 5) * 2.2,
                      padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                        color: Theme.of(context).primaryColorDark,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Theme.of(context).primaryColorDark,
                              ),
                              child: FutureBuilder<List<Period>>(
                                  future: localApi.getPeriods(),
                                  builder: (context, snapshot) {
                                    return (snapshot.data == null || !snapshot.hasData || periodeToUse == "" || snapshot.data.length == 0)
                                        ? Container(
                                            child: Text(
                                              "Pas de periode",
                                              style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                            ),
                                          )
                                        : DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: periodeToUse,
                                              iconSize: 0.0,
                                              style: TextStyle(fontSize: 18, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  periodeToUse = newValue;
                                                });
                                              },
                                              focusColor: Theme.of(context).primaryColor,
                                              items: snapshot.data.toSet().map<DropdownMenuItem<String>>((Period period) {
                                                return DropdownMenuItem<String>(
                                                  value: period != null ? period.name : "-",
                                                  child: Text(
                                                    period != null ? period.name : "-",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 18, fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                      child: Material(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.15),
                          onTap: () {
                            openSortBox();
                          },
                          child: Container(
                              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                              padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.settings,
                                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                                    ),
                                    Text(
                                      "Trier",
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ///Grades container

              RefreshIndicator(
                onRefresh: refreshLocalGradeList,
                child: Container(
                  width: screenSize.size.width / 5 * 4.7,
                  padding: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                  height: screenSize.size.height / 10 * 5.8,
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.000000, color: Colors.transparent),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Theme.of(context).primaryColor),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FutureBuilder<void>(
                          future: disciplinesListFuture,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (getDisciplinesForPeriod(snapshot.data, periodeToUse, filter).any((element) {
                                return (element.gradesList.length > 0);
                              })) {
                                return ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: getDisciplinesForPeriod(snapshot.data, periodeToUse, filter).length,
                                    padding: EdgeInsets.symmetric(vertical: screenSize.size.width / 5 * 0.1, horizontal: screenSize.size.width / 5 * 0.125),
                                    itemBuilder: (BuildContext context, int index) {
                                      return GradesGroup(disciplinevar: getDisciplinesForPeriod(snapshot.data, periodeToUse, filter)[index]);
                                    });
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(image: AssetImage('assets/images/book.png'), width: screenSize.size.width / 5 * 4),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                      child: AutoSizeText("Pas de notes pour cette periode.", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        //Reload list
                                        refreshLocalGradeList();
                                      },
                                      child: snapshot.connectionState != ConnectionState.waiting
                                          ? Text("Recharger", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                                          : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                    )
                                  ],
                                );
                              }
                            }
                            if (snapshot.hasError) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage('assets/images/totor.png'),
                                    width: screenSize.size.width / 5 * 3.5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.5),
                                    child: AutoSizeText("Hum... on dirait que tout ne s'est pas passé comme prévu.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Asap",
                                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                                        )),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      //Reload list
                                      refreshLocalGradeList();
                                    },
                                    child: snapshot.connectionState != ConnectionState.waiting
                                        ? Text("Recharger",
                                            style: TextStyle(
                                              fontFamily: "Asap",
                                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                                            ))
                                        : FittedBox(child: SpinKitThreeBounce(color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0), side: BorderSide(color: Theme.of(context).primaryColorDark)),
                                  )
                                ],
                              );
                            } else {
                              //Loading group
                              return ListView.builder(
                                  itemCount: 5,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.3),
                                  itemBuilder: (BuildContext context, int index) {
                                    return GradesGroup();
                                  });
                            }
                          })),
                ),
              ),
            ],
          ),
        ),

        //Average section
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.3),
          color: Theme.of(context).primaryColor,
          child: Container(
            width: screenSize.size.width / 5 * 4.7,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 1.8,
         
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FutureBuilder<void>(
                    future: disciplinesListFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Discipline> disciplineList;
                      Discipline getLastDiscipline;
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          try {
                            getLastDiscipline = snapshot.data.lastWhere((disciplinesList) => disciplinesList.periode == periodeToUse);
                          } catch (exception) {}

                          //If everything is ok, show stuff
                          return Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 1.15,
                                  width: screenSize.size.width / 5 * 4,
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        blurRadius: 2.67,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 2.67),
                                      ),
                                    ],
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: FittedBox(
                                    child: Container(
                                      height: (screenSize.size.height / 10 * 8.8) / 10 * 1.15,
                                      width: screenSize.size.width / 5 * 3.3,
                                      child: FittedBox(
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.9),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  if (filter == "all")
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text("Moyenne de la classe :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.width / 5) * 0.18)),
                                                        Container(
                                                          margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.1),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xff2C2C2C)),
                                                          padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.1, vertical: (screenSize.size.width / 5) * 0.08),
                                                          child: Text(
                                                            (getLastDiscipline != null && getLastDiscipline.moyenneGeneraleClasse != null ? getLastDiscipline.moyenneGeneraleClasse : "-"),
                                                            style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: (screenSize.size.width / 5) * 0.18),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  if (filter == "all")
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text("Meilleure moyenne:", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.width / 5) * 0.18)),
                                                        Container(
                                                          margin: EdgeInsets.only(left: (screenSize.size.width / 5) * 0.1),
                                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Color(0xff2C2C2C)),
                                                          padding: EdgeInsets.symmetric(horizontal: (screenSize.size.width / 5) * 0.1, vertical: (screenSize.size.width / 5) * 0.08),
                                                          child: Text(
                                                            (getLastDiscipline != null && getLastDiscipline.moyenneGeneralClasseMax != null ? getLastDiscipline.moyenneGeneralClasseMax : "-"),
                                                            style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: (screenSize.size.width / 5) * 0.18),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  if (filter != "all")
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text("Moyenne du filtre ", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.width / 5) * 0.2)),
                                                        Text(filter, style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold, color: isDarkModeEnabled ? Colors.white : Colors.black, fontSize: (screenSize.size.width / 5) * 0.2)),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //Circle with the moyenneGenerale
                              Positioned(
                                left: screenSize.size.width / 6 * 0.015,
                                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.2,
                                child: Container(
                                  padding: EdgeInsets.all(screenSize.size.height / 10 * 0.3),
                                  width: screenSize.size.width / 5 * 1.5,
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 1.4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          blurRadius: 2.67,
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0, 2.67),
                                        ),
                                      ],
                                      color: (filter == "all" ? Colors.white : Colors.green)),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        (average.toString() != null && !average.isNaN ? average.toStringAsFixed(2) : "-"),
                                        style: TextStyle(color: Colors.black, fontFamily: "Asap", fontSize: (screenSize.size.width / 5) * 0.35),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Container();
                      }

                      //To do if it can't get the data
                      if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: isDarkModeEnabled ? Colors.white : Colors.black,
                              size: screenSize.size.width / 8,
                            ),
                          ],
                        );
                      } else {
                        return SpinKitFadingFour(
                          color: Theme.of(context).primaryColorDark,
                          size: screenSize.size.width / 5 * 0.7,
                        );
                      }
                    })),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class GradesGroup extends StatefulWidget {
  final Discipline disciplinevar;
  const GradesGroup({this.disciplinevar});

  State<StatefulWidget> createState() {
    return _GradesGroupState();
  }
}

class _GradesGroupState extends State<GradesGroup> {
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    String capitalizedNomDiscipline;
    String nomsProfesseurs;
    Color colorGroup;
    void callback() {
      setState(() {
        colorGroup = Color(widget.disciplinevar.color);
      });
    }

    if (widget.disciplinevar == null) {
      colorGroup = Theme.of(context).primaryColorDark;
      nomsProfesseurs = null;
      capitalizedNomDiscipline = null;
    } else {
      String nomDiscipline = widget.disciplinevar.nomDiscipline.toLowerCase();
      capitalizedNomDiscipline = "${nomDiscipline[0].toUpperCase()}${nomDiscipline.substring(1)}";
      if (widget.disciplinevar.color != null) {
        colorGroup = Color(widget.disciplinevar.color);
      }
      if (widget.disciplinevar.professeurs.length > 0) {
        nomsProfesseurs = widget.disciplinevar.professeurs[0];
        if (nomsProfesseurs != null) {
          widget.disciplinevar.professeurs.forEach((element) {
            if (widget.disciplinevar.professeurs.indexOf(element) > 0) {
              nomsProfesseurs += " - " + element + " - ";
            }
          });
        }
      }
    }
    //BLOCK BUILDER
    return Container(
      width: screenSize.size.width / 5 * 3.2,
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      child: Stack(
        children: <Widget>[
          //Label
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.0005),
              child: Material(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                color: colorGroup,
                child: InkWell(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  onTap: () {
                    if (widget.disciplinevar != null) {
                      disciplineModalBottomSheet(context, widget.disciplinevar, callback, this.widget);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(width: 0.0, color: Colors.transparent)),
                    width: screenSize.size.width / 5 * 4.5,
                    height: (screenSize.size.height / 10 * 8.8) / 10 * 0.75,
                    child: Center(
                      child: Stack(children: <Widget>[
                        if (widget.disciplinevar != null && capitalizedNomDiscipline != null)
                          Positioned(
                            left: screenSize.size.width / 5 * 0.15,
                            top: screenSize.size.height / 10 * 0.1,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      capitalizedNomDiscipline,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: screenSize.size.height / 10 * 0.15),
                                    ),
                                  ),
                                  if (nomsProfesseurs != null && nomsProfesseurs.length > 15)
                                    Container(
                                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5)),
                                        width: screenSize.size.width / 5 * 2,
                                        height: screenSize.size.height / 10 * 0.3,
                                        child: ClipRRect(
                                          child: Marquee(text: nomsProfesseurs, style: TextStyle(fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.15)),
                                        )),
                                  if (nomsProfesseurs != null && nomsProfesseurs.length <= 15)
                                    Container(
                                        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
                                        width: screenSize.size.width / 5 * 2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Text(nomsProfesseurs, style: TextStyle(fontFamily: "Asap", fontSize: screenSize.size.height / 10 * 0.2)),
                                        )),
                                ],
                              ),
                            ),
                          ),
                        if (widget.disciplinevar == null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Shimmer.fromColors(
                                baseColor: Color(0xff5D6469),
                                highlightColor: Color(0xff8D9499),
                                child: Container(
                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.3, bottom: screenSize.size.width / 5 * 0.2),
                                  width: screenSize.size.width / 5 * 1.5,
                                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.3,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).primaryColorDark),
                                )),
                          ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Body with columns
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.55),
                width: screenSize.size.width / 5 * 4.5,
                decoration: BoxDecoration(
                  color: isDarkModeEnabled ? Color(0xff333333) : Color(0xffE2E2E2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Column(
                    children: <Widget>[
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Ecrit",
                                style: TextStyle(
                                  fontFamily: "Asap",
                                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                                ),
                              )),
                      gradesColumn(0),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0) Divider(thickness: 2),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          Text("Oral",
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                              )),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0) gradesColumn(1),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  List<Grade> getGradesForDiscipline(int sousMatiereIndex, String chosenPeriode) {
    List<Grade> toReturn = List();

    if (widget.disciplinevar != null) {
      widget.disciplinevar.gradesList.forEach((element) {
        if (element.nomPeriode == periodeToUse) {
          if (widget.disciplinevar.codeSousMatiere.length > 1) {
            if (element.codeSousMatiere == widget.disciplinevar.codeSousMatiere[sousMatiereIndex]) {
              toReturn.add(element);
            }
          } else {
            toReturn.add(element);
          }
        }
      });
      return toReturn;
    } else {
      return null;
    }
  }

  //MARKS COLUMN
  gradesColumn(int sousMatiereIndex) {
    void callback() {
      setState(() {});
    }

    bool canShow = false;
    List<Grade> localList = getGradesForDiscipline(sousMatiereIndex, periodeToUse);
    if (localList == null) {
      canShow = false;
    } else {
      if (localList.length > 2) canShow = true;
    }

    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Theme.of(context).primaryColorDark;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = Color(widget.disciplinevar.color);
      }
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController marksColumnController = ScrollController();
    return Container(
        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
        child: ListView.builder(
            itemCount: (localList != null ? localList.length : 1),
            controller: marksColumnController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2, vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.15),
            itemBuilder: (BuildContext context, int index) {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(now);
              if (localList != null && localList.length != null) {
                try {
                  if (marksColumnController != null && marksColumnController.hasClients) {
                    marksColumnController.animateTo(localList.length * screenSize.size.width / 5 * 1.2, duration: new Duration(microseconds: 5), curve: Curves.ease);
                  }
                } catch (e) {}
                if (localList[index].dateSaisie == formattedDate) {
                  newGrades = true;
                }
              }

              return Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), border: Border.all(color: (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null) ? Colors.transparent : Colors.black, width: 1)),
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                    child: Material(
                      color: (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null) ? Colors.transparent : colorGroup,
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                        splashColor: colorGroup,
                        onTap: () {
                          gradesModalBottomSheet(context, localList[index], widget.disciplinevar, callback, this.widget);
                        },
                        /*
                        onLongPress: () {
                          shareBox(localList[index], widget.disciplinevar);
                        },*/
                        child: ClipRRect(
                          child: Stack(
                            children: <Widget>[
                              if (localList != null)
                                //Grade box
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //Grades
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.05),
                                        child: AutoSizeText.rich(
                                          //MARK
                                          TextSpan(
                                            text: (localList[index].nonSignificatif ? "(" + localList[index].valeur : localList[index].valeur),
                                            style: TextStyle(color: Colors.black, fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
                                            children: <TextSpan>[
                                              if (localList[index].noteSur != "20")

                                                //MARK ON
                                                TextSpan(text: '/' + localList[index].noteSur, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2)),
                                              if (localList[index].nonSignificatif == true) TextSpan(text: ")", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //COEFF
                                      if (localList[index].coef != "1")
                                        Container(
                                            padding: EdgeInsets.all(screenSize.size.width / 5 * 0.03),
                                            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
                                            width: screenSize.size.width / 5 * 0.25,
                                            height: screenSize.size.width / 5 * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                              color: Colors.grey.shade600,
                                            ),
                                            child: FittedBox(
                                                child: AutoSizeText(
                                              localList[index].coef,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold),
                                            ))),
                                    ],
                                  ),
                                ),
                              if (getGradesForDiscipline(sousMatiereIndex, periodeToUse) == null)
                                Shimmer.fromColors(
                                    baseColor: Color(0xff5D6469),
                                    highlightColor: Color(0xff8D9499),
                                    child: Container(
                                      width: screenSize.size.width / 5 * 3.2,
                                      height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.5), color: Theme.of(context).primaryColorDark),
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (localList != null)
                    if (localList[index].dateSaisie == formattedDate)
                      Positioned(
                        left: screenSize.size.width / 5 * 1.3,
                        top: screenSize.size.height / 15 * 0.01,
                        child: Badge(
                          animationType: BadgeAnimationType.scale,
                          toAnimate: true,
                          elevation: 0,
                          position: BadgePosition.topEnd(),
                          badgeColor: Colors.blue,
                        ),
                      ),
                ],
              );
            }));
  }

//Modal share box
  shareBox(Grade grade, Discipline discipline) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

    return showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  contentPadding: EdgeInsets.only(top: 10.0),
                  content: Container(
                    height: screenSize.size.height / 10 * 4,
                    width: screenSize.size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Partager cette note",
                          style: TextStyle(fontFamily: "Asap", color: Colors.white),
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            ),
                            child: Column(children: <Widget>[
                              Container(
                                  child: Center(
                                    child: Text(
                                      discipline.nomDiscipline,
                                      style: TextStyle(fontFamily: "Asap", color: Colors.black),
                                    ),
                                  ),
                                  width: screenSize.size.width / 5 * 5,
                                  height: screenSize.size.height / 10 * 0.5,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)), color: Color(discipline.color))),
                              Container(
                                width: screenSize.size.width / 5 * 5,
                                height: screenSize.size.height / 10 * 2,
                                decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)), color: Theme.of(context).primaryColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Note du " + DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(grade.date)),
                                        style: TextStyle(
                                          fontFamily: "Asap",
                                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                                        )),
                                    Text(grade.devoir, style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                    SizedBox(
                                      height: screenSize.size.height / 10 * 0.2,
                                    ),
                                    Text("Ma note :", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black, fontWeight: FontWeight.w300, fontSize: screenSize.size.height / 10 * 0.2), textAlign: TextAlign.center),
                                    Container(
                                      width: screenSize.size.width / 5 * 2,
                                      height: screenSize.size.height / 10 * 0.6,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Theme.of(context).primaryColorDark),
                                      child: Center(
                                        child: AutoSizeText.rich(
                                          //MARK
                                          TextSpan(
                                            text: grade.valeur,
                                            style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.3),
                                            children: <TextSpan>[
                                              if (grade.noteSur != "20")

                                                //MARK ON
                                                TextSpan(text: '/' + grade.noteSur, style: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              color: Color(0xffFFFC00),
                              shape: CircleBorder(),
                              onPressed: () {},
                              child: Container(
                                  width: screenSize.size.width / 5 * 0.8,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: Image(
                                    image: AssetImage('assets/images/snapchatLogo.png'),
                                    width: screenSize.size.width / 5 * 0.5,
                                  )),
                            ),
                            RaisedButton(
                              color: Colors.white,
                              shape: CircleBorder(),
                              onPressed: () {},
                              child: Container(
                                  width: screenSize.size.width / 5 * 0.8,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: Image(
                                    image: AssetImage('assets/images/whatsappLogo.png'),
                                    width: screenSize.size.width / 5 * 0.5,
                                  )),
                            ),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              shape: CircleBorder(),
                              onPressed: () {},
                              child: Container(
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  child: Icon(
                                    MdiIcons.dotsHorizontal,
                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                    size: screenSize.size.width / 5 * 0.5,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {});
  }
}
