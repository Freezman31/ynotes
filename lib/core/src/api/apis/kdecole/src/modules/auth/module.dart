part of kdecole;

class _AuthModule extends AuthModule<_AuthRepository> {
  _AuthModule(SchoolApi api)
      : super(api: api, repository: _AuthRepository(api));
}
