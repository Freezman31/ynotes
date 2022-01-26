part of kdecole;

class _DocumentsModule extends DocumentsModule<_DocumentsRepository> {
  _DocumentsModule(SchoolApi api)
      : super(api: api, repository: _DocumentsRepository(api));
}
