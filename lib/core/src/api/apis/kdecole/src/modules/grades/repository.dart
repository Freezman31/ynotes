part of kdecole;

class _GradesRepository extends Repository {
  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final colors = AppColors.colors;
    var sub = <Subject>[];
    var grades = <Grade>[];
    var per = <Period>[];
    var got = await client.getGrades();
    for (var j = 0; j < got.length; j++) {
      var p = got[j];
      var subs = p.subjects;
      for (var i = 0; i < subs.length; i++) {
        final color = colors[Random().nextInt(colors.length)];
        colors.remove(color);
        var subject = subs[i];
        sub.add(
          Subject(
            coefficient: 1,
            average: subject.mid,
            classAverage: subject.midClass,
            maxAverage: double.nan,
            minAverage: double.nan,
            id: i.toString(),
            name: subject.name,
            teachers: subject.teacher,
            color: color,
          ),
        );
        for (var g in subject.grades) {
          grades.add(
            Grade(
              classMax: g.best,
              classMin: double.nan,
              coefficient: g.coef,
              date: g.date,
              name: g.name,
              entryDate: g.date,
              subjectId: i.toString(),
              type: '',
              classAverage: g.medium,
              value: g.grade,
              significant: false,
              outOf: g.bareme.toDouble(),
              periodId: p.id.toString(),
              custom: false,
            ),
          );
        }
      }
      per.add(
        Period(
          id: p.id.toString(),
          classAverage: double.nan,
          headTeacher: '',
          endDate: DateTime.now(),
          maxAverage: double.nan,
          minAverage: double.nan,
          name: p.periodName,
          overallAverage: double.nan,
          startDate: DateTime.now(),
        ),
      );
    }
    return Response(data: {
      "periods": per,
      "subjects": sub..sort((a, b) => a.name.compareTo(b.name)),
      "grades": grades..sort((a, b) => a.entryDate.compareTo(b.entryDate)),
    });
  }
}
