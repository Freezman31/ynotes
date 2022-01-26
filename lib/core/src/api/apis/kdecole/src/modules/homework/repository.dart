part of kdecole;

class _HomeworkRepository extends HomeworkRepository {
  _HomeworkRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    try {
      final Map<String, dynamic> map = {"homework": await getHw()};
      return Response(data: map);
    } catch (e) {
      return Response(error: '$e');
    }
  }

  @override
  Future<Response<List<Homework>>> getDay(DateTime date) async {
    try {
      var hw = await getHw();
      return Response(
          data: hw
              .where((element) =>
                  element.date.day == date.day &&
                  element.date.month == date.month)
              .toList());
    } catch (e) {
      return Response(error: '$e');
    }
  }

  Future<List<Homework>> getHw() async {
    var ret = <Homework>[];
    var hw = await client.getHomeworks();
    for (var e in hw) {
      ret.add(Homework(
        content: e.content,
        done: e.isRealised,
        due: false,
        date: e.date,
        assessment: false,
        entryDate: e.date,
        id: e.uuid.toString(),
        subjectId: e.sessionUuid.toString(),
        documentsIds: [],
        pinned: false,
      ));
    }
    return ret;
  }
}
