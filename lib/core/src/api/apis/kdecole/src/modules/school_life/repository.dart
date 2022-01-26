part of kdecole;

class _SchoolLifeRepository extends Repository {
  _SchoolLifeRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response();
  }
}
