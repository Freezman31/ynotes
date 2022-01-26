part of kdecole;

class _SchoolLifeModule extends SchoolLifeModule<_SchoolLifeRepository> {
  _SchoolLifeModule(SchoolApi api) : super(api: api, repository: _SchoolLifeRepository(api));

}