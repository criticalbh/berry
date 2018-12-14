import 'package:berry/berry.dart';

main() {
  new Berry({
    ProfessorService: Provider(
      provide: () => ProfessorService(),
    ),
    'GradeService': Provider(
      provide: () => GradeService(),
    ),
    StudentService: Provider(
      provide: (params) => StudentServiceImpl.fromDi(params),
      resolve: ['GradeService', ProfessorService],
    ),
    'key': Provider(
      provide: () => 'value',
    ),
  });

  StudentService studentService = Berry()[StudentService];

  List<int> studentGrades = studentService.getGrades();

  print(studentGrades);
}

abstract class StudentService {
  List<int> getGrades();
}

class StudentServiceImpl implements StudentService {
  final GradeService gradeService;
  final ProfessorService professorService;

  StudentServiceImpl(this.gradeService, this.professorService);

  List<int> getGrades() {
    return this.gradeService.grades;
  }

  factory StudentServiceImpl.fromDi(Map arguments) {
    return StudentServiceImpl(arguments['GradeService'], arguments[ProfessorService]);
  }
}

class GradeService {
  List<int> grades = [1, 2, 1, 3];
}

class ProfessorService {}
