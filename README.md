# berry

Simple dependency injection container.

## Usage

A simple usage example:

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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/criticalbh/berry/issues
