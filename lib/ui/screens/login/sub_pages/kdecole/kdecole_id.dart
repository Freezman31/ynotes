import 'package:flutter/cupertino.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/sub_pages/kdecole/kdecole.dart';
import 'package:ynotes/ui/screens/login/widgets/login_form.dart';

class LoginKdecoleIdPage extends StatelessWidget {
  const LoginKdecoleIdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginForm(
      subtitle: LoginContent.kdecole.idSubtitle,
      url: LoginKdecolePage.url,
    );
  }
}
