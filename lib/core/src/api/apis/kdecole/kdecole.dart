library kdecole;

///Only for testing
///import 'dart:convert';
///import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:http/src/request.dart';
import 'package:kdecole_api/kdecole_api.dart' as k;
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/src/utilities/app_colors.dart';
import 'package:ynotes/core/src/utilities/logger/logger.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes_packages/theme.dart';

part 'src/api.dart';
//AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/repository.dart';
//DOCUMENT MODULE
part 'src/modules/document/module.dart';
part 'src/modules/document/repository.dart';
//EMAILS MODULE
part 'src/modules/emails/module.dart';
part 'src/modules/emails/repository.dart';
//GRADES MODULE
part 'src/modules/grades/module.dart';
part 'src/modules/grades/repository.dart';
//HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/repository.dart';
//SCHOOLLIFE MODULE
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/repository.dart';
