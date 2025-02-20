import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/ui/screens/login/widgets/widgets.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/utilities.dart';

class _Credentials {
  String username;
  String password;
  String url;

  _Credentials({this.username = "", this.password = "", required this.url});
}

class LoginForm extends StatefulWidget {
  final String subtitle;
  final String url;

  const LoginForm({Key? key, required this.subtitle, this.url = ""}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late final _Credentials _credentials = _Credentials(url: widget.url);
  bool _canNavigate = true;

  Future<void> submit(bool b) async {
    setState(() {
      _loading = true;
    });
    if (b) {
      _formKey.currentState!.save();
      final res = await schoolApi.authModule.login(
          username: _credentials.username.trim(),
          password: _credentials.password.trim(),
          parameters: {"url": _credentials.url.trim(), "mobileCasLogin": false});
      if (res.error != null) {
        YSnackbars.error(context, title: LoginContent.widgets.form.error, message: res.error!);
        setState(() {
          _loading = false;
        });
        return;
      }
      setState(() {
        _canNavigate = false;
      });
      YSnackbars.success(context, title: LoginContent.widgets.form.connected, message: res.data!);
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, "/terms");
    }
    setState(() {
      _loading = false;
      _canNavigate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageStructure(
      backButton: _canNavigate,
      subtitle: widget.subtitle,
      body: Column(
        children: [
          YForm(
            formKey: _formKey,
            onSubmit: submit,
            autoSubmit: _canNavigate,
            fields: [
              YFormField(
                  properties: YFormFieldProperties(),
                  autofillHints: const [AutofillHints.username],
                  label: LoginContent.widgets.form.id,
                  type: YFormFieldInputType.text,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? LoginContent.widgets.form.requiredField : null;
                  },
                  onSaved: (String? value) {
                    _credentials.username = value ?? "";
                  }),
              YFormField(
                  properties: YFormFieldProperties(),
                  autofillHints: const [AutofillHints.password],
                  label: LoginContent.widgets.form.password,
                  type: YFormFieldInputType.password,
                  validator: (String? value) {
                    return value == null || value.isEmpty ? LoginContent.widgets.form.requiredField : null;
                  },
                  onSaved: (String? value) {
                    _credentials.password = value ?? "";
                  }),
            ],
          ),
          YVerticalSpacer(YScale.s6),
          YButton(
            text: LoginContent.widgets.form.logIn,
            onPressed: () {
              submit(_formKey.currentState!.validate());
            },
            block: true,
            isLoading: _loading,
            isDisabled: !_canNavigate,
          )
        ],
      ),
    );
  }
}
