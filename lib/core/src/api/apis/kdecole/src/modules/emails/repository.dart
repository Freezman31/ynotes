part of kdecole;

class _EmailsRepository extends EmailsRepository {
  _EmailsRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response();
  }

  @override
  Future<Response<String>> getEmailContent(Email email, bool received) async {
    return const Response();
  }

  @override
  Future<Response<void>> sendEmail(Email email) async {
    return const Response();
  }
}
