library kdecole;

import 'package:http/src/request.dart';
import 'package:kdecole_api/kdecole_api.dart' as k;
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/src/utilities/app_colors.dart';
import 'package:ynotes/packages/shared.dart';

part 'src/api.dart';

//AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/repository.dart';

//HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/repository.dart';

//GRADES MODULE
part 'src/modules/grades/module.dart';
part 'src/modules/grades/repository.dart';

//EMAILS MODULE
part 'src/modules/emails/module.dart';
part 'src/modules/emails/repository.dart';

//SCHOOLLIFE MODULE
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/repository.dart';

//DOCUMENT MODULE
part 'src/modules/document/module.dart';
part 'src/modules/document/repository.dart';
