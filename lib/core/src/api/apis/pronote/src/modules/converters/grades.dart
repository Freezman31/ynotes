part of pronote;

class PronoteGradesConverter {
  static subjects(PronoteClient client, Map subjectsData) {
    List<Subject> subjects = [];
    final colors = List.from(AppColors.colors);
    final Random random = Random();
    final Map<String, YTColor> assignedColors = {};
    //Translate averages
    String generalAverage =
        gradeTranslate(safeMapGetter(subjectsData, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    String classGeneralAverage =
        gradeTranslate(safeMapGetter(subjectsData, ['donneesSec', 'donnees', 'moyClasse', 'V']) ?? "");

    var rawSubjects = safeMapGetter(subjectsData, ['donneesSec', 'donnees', 'listeServices', 'V']) ?? [];
    rawSubjects.forEach((rawSubject) {
      late YTColor color;

      String disciplineName = safeMapGetter(rawSubject, ["L"]);
      List<Grade> gradesList = [];
      double minClassAverage = gradeTranslate(safeMapGetter(rawSubject, ["moyMin", "V"]));
      double maxClassAverage = gradeTranslate(safeMapGetter(rawSubject, ["moyMax", "V"]));
      double classAverage = gradeTranslate(safeMapGetter(rawSubject, ["moyClasse", "V"]));
      double average = gradeTranslate(safeMapGetter(rawSubject, ["moyEleve", "V"]));
      List<String> teachers = [];
      if (assignedColors.containsKey(disciplineName.hashCode.toString())) {
        color = assignedColors[disciplineName.hashCode.toString()]!;
      } else {
        color = colors[random.nextInt(colors.length)];
        assignedColors[disciplineName.hashCode.toString()] = color;
        colors.remove(color);
      }
      subjects.add(Subject(
          name: disciplineName,
          entityId: disciplineName.hashCode.toString(),
          minAverage: minClassAverage,
          maxAverage: maxClassAverage,
          average: average,
          classAverage: classAverage,
          coefficient: 1,
          color: color,
          teachers: teachers.first)
        ..grades.addAll(gradesList));
    });
    var rawGrades = safeMapGetter(subjectsData, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    //get grades
    List<Grade> _grades = grades(client, rawGrades, subjects);
    return subjects;
  }

  static List<Grade> grades(PronoteClient client, List gradesData, List<Subject> subjects) {
    List<Grade> grades = [];
    for (var gradeData in gradesData) {
      double value = gradeTranslate(safeMapGetter(gradeData, ["note", "V"]) ?? "");
      String testName = safeMapGetter(gradeData, ["commentaire"]) ?? "";
      String periodCode = safeMapGetter(gradeData, ["periode", "V", "N"]) ?? "";
      String periodName = safeMapGetter(gradeData, ["periode", "V", "L"]) ?? "";
      String disciplineCode = (safeMapGetter(gradeData, ["service", "V", "L"]) ?? "").hashCode.toString();
      //bool letters = (safeMapGetter(gradeData, ["note", "V"]) ?? "").contains("|");
      double coefficient = double.parse(safeMapGetter(gradeData, ["coefficient"]).toString());
      double scale = safeMapGetter(gradeData, ["bareme", "V"]);
      double min = gradeTranslate(safeMapGetter(gradeData, ["noteMin", "V"]) ?? "");
      double max = gradeTranslate(safeMapGetter(gradeData, ["noteMax", "V"]) ?? "");
      double classAverage = double.parse(gradeTranslate(safeMapGetter(gradeData, ["moyenne", "V"]) ?? ""));
      DateTime date = safeMapGetter(gradeData, ["date", "V"]) != null
          ? DateFormat("dd/MM/yyyy").parse(safeMapGetter(gradeData, ["date", "V"]))
          : DateTime.now();
      bool notSignificant = gradeTranslate(safeMapGetter(gradeData, ["note", "V"]) ?? "") == "NonNote";
      String testType = "Interrogation";
      DateTime entryDate = safeMapGetter(gradeData, ["date", "V"]) != null
          ? DateFormat("dd/MM/yyyy").parse(safeMapGetter(gradeData, ["date", "V"]))
          : DateTime.now();
      bool countAsZero = shouldCountAsZero(gradeTranslate(safeMapGetter(gradeData, ["note", "V"]) ?? ""));
      //bool optional = safeMapGetter(gradeData, ["estFacultatif"]) ?? false;

      grades.add(Grade(
        date: date,
        coefficient: coefficient,
        type: testType,
        classAverage: classAverage,
        classMax: max,
        classMin: min,
        name: testName,
        value: countAsZero ? 0 : value,
        significant: !notSignificant,
        outOf: scale,
        entryDate: entryDate,
        custom: false,
      )..subject.value = subjects.firstWhere((element) => element.id.toString() == disciplineCode));
      subjects.firstWhere((element) => element.id.toString() == disciplineCode).grades.add(grades.last);
    }
    return grades;
  }
}
