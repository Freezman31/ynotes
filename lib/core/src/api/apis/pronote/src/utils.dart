part of pronote;

Response<String> getDownloadUrl(
    {required Document document,
    required Communication communication,
    required Encryption encryption,
    required attributes}) {
  final Map<String, dynamic> data = {"N": document.id, "G": document.type};
  final res = encryption.aesEncrypt(utf8.encode(jsonEncode(data)));
  if (res.hasError) return res;
  final String encrypted = res.data!;
  final String url = "${communication.urlRoot}/FichiersExternes/$encrypted/${document.name}?Session=${attributes['h']}";
  return Response(data: url);
}

String getHostname(String url) {
  var uri = Uri.parse(url);
  return '${uri.host}:${uri.port}';
}

List<String> getRootAdress(addr) {
  return [
    (addr.split('/').sublist(0, addr.split('/').length - 1).join("/")),
    (addr.split('/').sublist(addr.split('/').length - 1, addr.split('/').length).join("/"))
  ];
}

prepareTabs(List tabsList) {
  List output = [];
  if (tabsList.runtimeType != List) {
    return [tabsList];
  }
  tabsList.forEach((item) {
    if (item.runtimeType == Map) {
      item = item.values();
    }
    output.add(item);
  });
  return output;
}

String removeAlea(String text) {
  List sansalea = [];
  int i = 0;
  for (var rune in text.runes) {
    var character = String.fromCharCode(rune);
    if (i % 2 == 0) {
      sansalea.add(character);
    }
    i++;
  }

  return sansalea.join("");
}

List<String> splitAdress(String address) {
  final Uri uri = Uri.parse(address);
  return [
    "${uri.scheme}://${uri.host}${uri.port == 80 ? ':${uri.port}' : ''}",
    "${uri.path}${uri.query == '' ? '' : '?'}${uri.query}",
  ];
}

String _decodeBody(http.Response res) => const Utf8Decoder().convert(res.bodyBytes);

String _encodeBody(Map<String, dynamic>? body) {
  body ??= {};
  return "data=${jsonEncode(body)}";
}

gradeTranslate(String value) {
  List gradeTranslate = [
    'Absent',
    'Dispensé',
    'Non noté',
    'Inapte',
    'Non rendu',
    'Absent zéro',
    'Non rendu zéro',
    'Félicitations'
  ];
  if (value.contains("|")) {
    return gradeTranslate[int.parse(value[1]) - 1];
  } else {
    return value;
  }
}

dynamic mapGet(var map, List path) {
  assert(path.isNotEmpty);
  var m = map ?? {};
  for (int i = 0; i < path.length - 1; i++) {
    m = m[path[i]] ?? {};
  }

  return m[path.last];
}

shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else {
      return false;
    }
  }
