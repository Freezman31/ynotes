part of kdecole;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api)
      : super(api: api, repository: _GradesRepository(api));
}
