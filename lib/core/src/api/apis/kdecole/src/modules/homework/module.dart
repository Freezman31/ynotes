part of kdecole;

class _HomeworkModule extends HomeworkModule<_HomeworkRepository> {
  _HomeworkModule(SchoolApi api)
      : super(api: api, repository: _HomeworkRepository(api));
}
