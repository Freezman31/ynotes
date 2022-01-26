part of kdecole;

class _GradesRepository extends Repository {
  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response();
  }
}
