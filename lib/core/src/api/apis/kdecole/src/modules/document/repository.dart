part of kdecole;

class _DocumentsRepository extends DocumentsRepository {
  _DocumentsRepository(SchoolApi api) : super(api);

  @override
  Response<Request> download(Document document) {
    return const Response();
  }

  @override
  Future<Response<Request>> upload(Document document) async {
    return const Response();
  }
}
