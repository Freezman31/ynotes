import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/sub_pages/kdecole/kdecole.dart';
import 'package:ynotes/ui/screens/login/widgets/login_page_structure.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginKdecoleTokenPage extends StatefulWidget {
  const LoginKdecoleTokenPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginKdecoleTokenPageState();
}

class _LoginKdecoleTokenPageState extends State<LoginKdecoleTokenPage> {
  final key = GlobalKey<FormState>();
  String token = '';

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      subtitle: LoginContent.kdecole.tokenSubtitle,
      body: Column(
        children: [
          YForm(
            formKey: key,
            fields: [
              YFormField(
                type: YFormFieldInputType.password,
                label: 'Token',
                properties: YFormFieldProperties(),
                onChanged: (value) => token = value,
              ),
            ],
            onSubmit: (b) async {
              if (b) {
                key.currentState!.save();
                await login();
              }
            },
          ),
          YVerticalSpacer(YScale.s4),
          YButton(
            onPressed: () async {
              await login();
            },
            text: LoginContent.widgets.form.logIn,
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    final res = await schoolApi.authModule.login(
        username: '',
        password: token,
        parameters: {'url': LoginKdecolePage.url, 'token': true});
    if (res.error != null) {
      YSnackbars.error(context,
          title: LoginContent.widgets.form.error, message: res.error!);
      return;
    }
    YSnackbars.success(context,
        title: LoginContent.widgets.form.connected, message: res.data!);
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, "/terms");
  }
}
