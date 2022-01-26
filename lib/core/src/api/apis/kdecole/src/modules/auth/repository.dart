part of kdecole;

class _AuthRepository extends AuthRepository {
  _AuthRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> login(
      {required String username,
      required String password,
      Map<String, dynamic>? parameters}) async {
    if (parameters == null || !parameters.containsKey('url')) {
      return const Response(error: 'Missing url parameter');
    }
    if (parameters.containsKey('token')) {
      print('Logging in with token');
      client = k.Client.fromToken(password, parameters['url']);
    } else {
      print('Logging in with username and password');
      client = k.Client(parameters['url'], username, password);
    }
    await client.setUserData();
    final data = client.getUserData();
    AppAccount account = AppAccount(
      firstName: data.fullName.split(' ')[0],
      lastName: data.fullName.split(' ')[1],
      id: data.id.toString(),
      accounts: [],
    );

    /*api.modulesAvailability.emails = client.perms.emails;
    api.modulesAvailability.homework = client.perms.homeworks;
    api.modulesAvailability.grades = client.perms.marks;
    await api.modulesAvailability.save();*/
    api.refreshModules();

    return Response(data: {
      'appAccount': account,
      'schoolAccount': SchoolAccount(
        id: data.id.toString(),
        school: data.etab,
        firstName: data.fullName.split(' ')[0],
        lastName: data.fullName.split(' ')[1],
        className: '',
        profilePicture: '',
      ),
    });
  }
}
