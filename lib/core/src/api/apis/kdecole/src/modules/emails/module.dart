part of kdecole;

class _EmailsModule extends EmailsModule {
  _EmailsModule(SchoolApi api)
      : super(api: api, repository: _EmailsRepository(api));
}
