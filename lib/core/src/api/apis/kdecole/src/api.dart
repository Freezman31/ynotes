part of kdecole;

late k.Client client;

final Metadata metadata = Metadata(
  name: "KDecole",
  imagePath: "assets/images/icons/pronote/PronoteIcon.png",
  beta: true,
  color: AppColors.lightBlue,
  api: Apis.kdecole,
  coloredLogo: true,
  loginRoute: "/login/kdecole",
);

const ModulesSupport modulesSupport = ModulesSupport(
  grades: false,
  schoolLife: false,
  emails: false,
  homework: true,
  documents: false,
);

class KdecoleApi extends SchoolApi implements SchoolApiModules {
  KdecoleApi() : super(metadata: metadata, modulesSupport: modulesSupport);

  @override
  late AuthModule authModule = _AuthModule(this);

  @override
  late DocumentsModule documentsModule = _DocumentsModule(this);

  @override
  late EmailsModule emailsModule = _EmailsModule(this);

  @override
  late GradesModule gradesModule = _GradesModule(this);

  @override
  late HomeworkModule homeworkModule = _HomeworkModule(this);

  @override
  late SchoolLifeModule schoolLifeModule = _SchoolLifeModule(this);
}
