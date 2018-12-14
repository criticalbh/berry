import 'package:berry/src/lib.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      instantiateBerry();
    });

    test('Professor service is not null test', () {
      expect(Berry()[ProfessorService], isNotNull);
    });
    test('Two berry instances are identical test', () {
      expect(identical(new Berry()[StudentService], new Berry()[StudentService]), true);
    });
    test('Berry operator test', () {
      StudentService studentService = new Berry()[StudentService];
      expect(studentService.serviceExists(), isTrue);
    });
    test('String values test', () {
      expect(new Berry()['key'], 'value');
    });
  });
}

void instantiateBerry() {
  new Berry({
    ProfessorService: Provider(
      provide: (arguments) => ProfessorService(arguments),
      resolve: [SchoolService],
    ),
    'GradeService': Provider(
      provide: () => GradeService(),
    ),
    SchoolService: Provider(
      provide: () => SchoolService(),
    ),
    StudentService: Provider(
      provide: (params) => StudentServiceImpl.fromDi(params),
      resolve: ['GradeService', ProfessorService],
    ),
    'key': Provider(
      provide: () => 'value',
    ),
  });
}

abstract class StudentService {
  serviceExists();
}

class StudentServiceImpl implements StudentService {
  final GradeService gradeService;
  final ProfessorService professorService;

  StudentServiceImpl(this.gradeService, this.professorService);

  bool serviceExists() {
    return this.gradeService != null && this.professorService != null;
  }

  factory StudentServiceImpl.fromDi(Map arguments) {
    return StudentServiceImpl(arguments['GradeService'], arguments[ProfessorService]);
  }
}

class GradeService {}

class ProfessorService {
  final SchoolService schoolService;

  ProfessorService(Map arguments) : schoolService = arguments[SchoolService];
}

class SchoolService {}
