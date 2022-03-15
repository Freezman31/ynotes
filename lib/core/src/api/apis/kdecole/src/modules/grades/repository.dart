part of kdecole;

class _GradesRepository extends Repository {
  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final random = Random();
    try {
      List<Subject> sub = <Subject>[];
      List<Grade> grades = <Grade>[];
      List<Period> per = <Period>[];
      final got = await client.getGrades();

      //This is temporary, it's just to simulate the data without calling the api
      /*
      var got = <k.Period>[];
      var res = jsonDecode((await http.get(Uri.parse(
              'https://raw.githubusercontent.com/maelgangloff/kdecole-api/master/tests/fakeData/fakeReleve.json')))
          .body);

      for (final period in res) {
        final List<k.Subject> subjects = [];
        for (final subject in period['matieres']) {
          final List<k.Grade> grades = [];
          for (final grade in subject['devoirs']) {
            grades.add(
              k.Grade(
                id: grade['id'],
                grade: double.parse(grade['note'] == null || grade['note'] == 'Non Noté' ? '0' : grade['note']),
                bareme: grade['bareme'],
                name: grade['titreDevoir'],
                date: DateTime.fromMillisecondsSinceEpoch(grade['date']),
                medium: double.parse(grade['moyenne'] == " - " ? '0' : grade['moyenne']),
                coefficient: double.parse(grade['coefficient'].toString()),
                best: double.parse(grade['noteMax'] == " - " ? '0' : grade['noteMax']),
              ),
            );
          }

          subjects.add(
            k.Subject(
              grades: grades,
              name: subject['matiereLibelle'],
              mid: double.parse(subject['moyenneEleve'].toString().replaceAll(',', '.')),
              midClass: double.parse(subject['moyenneClasse'].toString().replaceAll(',', '.')),
              teacher: subject['enseignants'][0],
            ),
          );
        }
        got.add(
          k.Period(
            className: period['libelleClasse'],
            id: period['idPeriode'],
            periodName: period['periodeLibelle'],
            subjects: subjects,
          ),
        );
      }*/

      for (var j = 0; j < got.length; j++) {
        var p = got[j];
        per.add(
          Period(
            entityId: p.id.toString(),
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
        var subs = p.subjects;
        final List<YTColor> colors = [
          AppColors.red,
          AppColors.pink,
          AppColors.purple,
          AppColors.deepPurple,
          AppColors.indigo,
          AppColors.blue,
          AppColors.lightBlue,
          AppColors.cyan,
          AppColors.teal,
          AppColors.green,
          AppColors.lightGreen,
          AppColors.lime,
          AppColors.yellow,
          AppColors.amber,
          AppColors.orange,
          AppColors.deepOrange,
          AppColors.brown,
        ];
        for (var i = 0; i < subs.length; i++) {
          final color = colors[random.nextInt(colors.length)];
          colors.remove(color);
          var subject = subs[i];
          sub.add(
            Subject(
              coefficient: 1,
              average: subject.mid,
              classAverage: subject.midClass,
              maxAverage: double.nan,
              minAverage: double.nan,
              entityId: i.toString(),
              name: subject.name,
              teachers: subject.teacher,
              color: color,
            )..period.value = per[j],
          );
          for (var g in subject.grades) {
            grades.add(
              Grade(
                classMax: g.best,
                classMin: double.nan,
                coefficient: g.coefficient,
                date: g.date,
                name: g.name,
                entryDate: g.date,
                type: '',
                classAverage: g.medium,
                value: g.grade,
                significant: true,
                outOf: g.bareme.toDouble(),
                custom: false,
              )
                ..subject.value = sub[i]
                ..period.value = per[j],
            );
          }
        }
      }
      Logger.log('GRADES', 'Successfully fetch grades');
      Logger.log('GRADES', 'Grades: ${grades.length}');
      return Response(data: {
        "periods": per..sort((a, b) => a.endDate.compareTo(b.endDate)),
        "subjects": sub..sort((a, b) => a.name.compareTo(b.name)),
        "grades": grades..sort((a, b) => a.entryDate.compareTo(b.entryDate)),
      });
    } catch (e, st) {
      Logger.error('GRADE ERROR : $e');
      Logger.error('GRADE ERROR STACK : $st');
      return Response(
        error: '$e',
      );
    }
  }
}
