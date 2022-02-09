part of kdecole;

class _HomeworkRepository extends HomeworkRepository {
  _HomeworkRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    /*
    try {
      await client.setUserData();
      final Map<String, dynamic> map = {"homework": await getHw()};
      return Response(data: map);
    } catch (e) {
      Logger.error(e);
      return Response(error: 'On fetching homeworks : $e');
    }*/
    return const Response(error: 'Not implemented');
  }

  @override
  Future<Response<List<Homework>>> getDay(DateTime date) async {
    /*try {
      var hw = await getHw();
      return Response(
          data: hw
              .where((element) =>
                  element.date.day == date.day &&
                  element.date.month == date.month)
              .toList());
    } catch (e) {
      print(e);
      return Response(error: '$e');
    }
  }

  Future<List<Homework>> getHw() async {
    var ret = <Homework>[];
    var tHw = await client.getHomeworks();
    var hw = <k.Homework>[];

    for (var t in tHw) {
      hw.add(await client.getFullHomework(t));
    }
    for (var e in hw) {
      ret.add(Homework(
        content: e.content,
        done: e.isRealised,
        due: false,
        date: e.date,
        assessment: false,
        entryDate: e.date,
        entityId: e.uuid.toString(),
        pinned: false,
      ));
    }
    return ret;*/
    return const Response(error: 'Not implemented');
  }
}
