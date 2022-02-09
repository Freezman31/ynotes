part of app;

late SchoolApi schoolApi;

SchoolApi schoolApiManager(Apis api) {
  late SchoolApi _api;
  switch (api) {
    /*case Apis.ecoleDirecte:
      _api = EcoleDirecteApi();
      break;
    case Apis.kdecole:
      _api = KdecoleApi();
      break;*/
    default:
      _api = KdecoleApi();
      break;
  }
  Logger.log("SCHOOL API MANAGER", "Selected: ${_api.metadata.name}");
  return _api;
}

final List<SchoolApi> schoolApis = [EcoleDirecteApi(), KdecoleApi()];
