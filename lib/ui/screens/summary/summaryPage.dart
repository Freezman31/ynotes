import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/grades/gradesPage.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickGrades.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/quickSchoolLife.dart';
import 'package:ynotes/ui/screens/summary/summaryPageWidgets/summaryPageSettings.dart';

Future? donePercentFuture;

bool firstStart = true;

///First page to access quickly to last grades, homework and
class SummaryPage extends StatefulWidget {
  const SummaryPage({
    Key? key,
  }) : super(key: key);
  State<StatefulWidget> createState() {
    return SummaryPageState();
  }
}

class SummaryPageState extends State<SummaryPage> with YPageMixin {
  double? actualPage;
  late PageController _pageControllerSummaryPage;
  PageController? todoSettingsController;
  bool done2 = false;
  double? offset;
  ExpandableController alertExpandableDialogController = ExpandableController();
  PageController summarySettingsController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return YPage(
        title: "Résumé",
        actions: [
          IconButton(
              onPressed: () => openLocalPage(
                  YPageLocal(title: "Options", child: SummaryPageSettings())),
              icon: Icon(MdiIcons.wrench))
        ],
        body: VisibilityDetector(
            key: Key('sumpage'),
            onVisibilityChanged: (visibilityInfo) async {
              await Permission.notification.request();
              //Ensure that page is visible
              var visiblePercentage = visibilityInfo.visibleFraction * 100;
              if (visiblePercentage == 100) {
                await showUpdateNote();
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                separator(context, "Notes", "/grades"),
                QuickGrades(),
                separator(context, "Devoirs", "/homework"),
                QuickHomework(),
                if (appSys.settings?["system"]["chosenApi"] == 0)
                  separator(context, "Vie scolaire", "/school_life"),
                if (appSys.settings?["system"]["chosenApi"] == 0)
                  QuickSchoolLife(),
                SizedBox(
                  height: screenSize.size.height / 10 * 0.2,
                )
              ],
            )));
  }

  initLoginController() async {
    await appSys.loginController.init();
  }

  initState() {
    super.initState();
    todoSettingsController = new PageController(initialPage: 0);
    initialIndexGradesOffset = 0;
    _pageControllerSummaryPage = PageController();
    _pageControllerSummaryPage.addListener(() {
      setState(() {
        actualPage = _pageControllerSummaryPage.page;
        offset = _pageControllerSummaryPage.offset;
      });
    });
    //Init controllers
    appSys.gradesController.refresh(force: false);
    appSys.homeworkController.refresh(force: false);
    SchedulerBinding.instance!.addPostFrameCallback((!mounted
        ? null
        : (_) => {
              if (firstStart)
                {
                  initLoginController().then((var f) {
                    if (firstStart) {
                      firstStart = false;
                    }
                    appSys.gradesController.refresh(force: true);
                    appSys.homeworkController.refresh(force: true);
                  })
                }
            })!);
  }

  Future<void> refreshControllers() async {
    await appSys.gradesController.refresh(force: true);
    await appSys.homeworkController.refresh(force: true);
  }

  Widget separator(BuildContext context, String text, String routeName) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(
        top: screenSize.size.height / 10 * 0.1,
        left: screenSize.size.width / 5 * 0.25,
        bottom: screenSize.size.height / 10 * 0.1,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Text(
          text,
          style: TextStyle(
              color: ThemeUtils.textColor(),
              fontFamily: "Asap",
              fontSize: 25,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: screenSize.size.width / 5 * 0.25,
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, routeName),
          child: Row(
            children: [
              Text(
                "Accéder à la page",
                style: TextStyle(
                    color: ThemeUtils.textColor(),
                    fontFamily: "Asap",
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              Icon(Icons.chevron_right, color: ThemeUtils.textColor()),
            ],
          ),
        ),
      ]),
    );
  }

  showDialog() async {
    await helpDialogs[0].showDialog(context);
    await showUpdateNote();
  }

  showUpdateNote() async {
    if ((appSys.settings!["system"]["lastReadUpdateNote"] != "0.11.2")) {
      appSys.updateSetting(
          appSys.settings!["system"], "lastReadUpdateNote", "0.11.2");
      await CustomDialogs.showUpdateNoteDialog(context);
    }
  }

  void triggerSettings() {
    summarySettingsController.animateToPage(
        summarySettingsController.page == 1 ? 0 : 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease);
  }
}
