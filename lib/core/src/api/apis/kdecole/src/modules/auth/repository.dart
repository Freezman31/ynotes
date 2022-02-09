part of kdecole;

class _AuthRepository extends AuthRepository {
  _AuthRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> login(
      {required String username,
      required String password,
      Map<String, dynamic>? parameters}) async {
    print('login');
    if (parameters == null || !parameters.containsKey('url')) {
      return const Response(error: 'Missing url parameter');
    }
    if (parameters.containsKey('token') || username == '') {
      print('Logging in with token');
      client = k.Client.fromToken(token: password, url: parameters['url']);
    } else {
      print('Logging in with username and password');
      client = k.Client(
          url: parameters['url'], username: username, password: password);
    }
    await client.setUserData();
    final data = client.info;
    AppAccount account = AppAccount(
      firstName: data.fullName.split(' ')[0],
      lastName: data.fullName.split(' ')[1],
      entityId: data.id.toString(),
    );
    api.modulesAvailability.schoolLife = false; //client.permissions.schoolLife;
    api.modulesAvailability.emails = client.permissions.emails;
    api.modulesAvailability.homework = false; //client.permissions.homeworks;
    api.modulesAvailability.grades = client.permissions.marks;
    await api.modulesAvailability.save();
    api.refreshModules();

    return Response(data: {
      'appAccount': account,
      'schoolAccount': SchoolAccount(
        entityId: data.id.toString(),
        school: data.etab,
        firstName: data.fullName.split(' ')[0],
        lastName: data.fullName.split(' ')[1],
        className: '',
        profilePicture: '',
      ),
    });
  }
}
