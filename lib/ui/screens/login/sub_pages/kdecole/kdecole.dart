import 'package:flutter/material.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginKdecolePage extends StatefulWidget {
  const LoginKdecolePage({Key? key}) : super(key: key);

  static String url = 'https://mobilite.agora06.fr/mobilite/';
  @override
  State<StatefulWidget> createState() => _LoginKdecolePageState();
}

class _LoginKdecolePageState extends State<LoginKdecolePage> {
  final Map<String, String> cas = const {
    'Agora 06': 'https://mobilite.agora06.fr/mobilite/',
    'Arsène 76': 'https://mobilite.arsene76.fr/mobilite/',
    'Au Collège Vaucluse': 'https://mobilite.aucollege84.vaucluse.fr/mobilite/',
    'Auvergne Rhones Alpes':
        'https://mobilite.ent.auvergnerhonealpes.fr/mobilite/',
    'Cyber Collèges 42': 'https://mobilite.cybercolleges42.fr/mobilite/',
    'Demo': 'https://mobilite.demo.skolengo.com/mobilite/',
    'Eclat BFC': 'https://mobilite.eclat-bfc.fr/mobilite/',
    'E-Collège 31': 'https://mobilite.ecollege.haute-garonne.fr/mobilite/',
    'ENT 27': 'https://mobilite.ent27.fr/mobilite/',
    'ENT Creuse': 'https://mobilite.entcreuse.fr/mobilite/',
    'Kosmos Education': 'https://mobilite.kosmoseducation.com/mobilite/',
    'Mon Bureau Numérique': 'https://mobilite.monbureaunumerique.fr/mobilite/',
    'Mon Collège Valdoise': 'https://mobilite.moncollege.valdoise.fr/mobilite/',
    'Mon ENT Occitanie': 'https://mobilite.mon-ent-occitanie.fr/mobilite/',
    'Savoirs Numériques 62':
        'https://mobilite.savoirsnumeriques62.fr/mobilite/',
    'Web Collège Seine St Denis':
        'https://mobilite.webcollege.seinesaintdenis.fr/mobilite/'
  };

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      subtitle: LoginContent.kdecole.subtitle,
      body: Column(
        children: [
          YDropdownButton<String>(
            items: cas.keys
                .map((e) => YDropdownButtonItem(value: cas[e]!, display: e))
                .toList(),
            onChanged: (n) {
              setState(() {
                LoginKdecolePage.url = n.toString();
              });
            },
            value: LoginKdecolePage.url,
          ),
          YVerticalSpacer(YScale.s10),
          LoginElementBox(
            children: [
              Icon(
                Icons.password,
                color: theme.colors.foregroundLightColor,
              ),
              YHorizontalSpacer(YScale.s4),
              Text(
                'Identifiants Temporaires (recommandé)',
                style: TextStyle(
                  fontSize: YFontSize.xl,
                  color: theme.colors.foregroundColor,
                  fontWeight: YFontWeight.bold,
                ),
              ),
            ],
            onTap: () {
              Navigator.pushNamed(context, '/login/kdecole/id');
            },
          ),
          YVerticalSpacer(YScale.s2),
          LoginElementBox(
            children: [
              Icon(
                Icons.lock,
                color: theme.colors.foregroundLightColor,
              ),
              YHorizontalSpacer(YScale.s4),
              Text(
                'Token',
                style: TextStyle(
                  fontSize: YFontSize.xl,
                  color: theme.colors.foregroundColor,
                  fontWeight: YFontWeight.bold,
                ),
              ),
            ],
            onTap: () {
              Navigator.pushNamed(context, '/login/kdecole/token');
            },
          ),
        ],
      ),
    );
  }
}
