import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  const Patient._({
    required this.name,
    required this.id,
    required this.dob,
    required this.bloodGroup,
  });

  factory Patient.create({
    required String name,
    required String id,
    required String dob,
    required String bloodGroup,
  }) {
    return Patient._(
      name: name,
      id: id,
      dob: dob,
      bloodGroup: bloodGroup,
    );
  }

  factory Patient.empty() {
    return const Patient._(
      name: '',
      id: '',
      bloodGroup: '',
      dob: '',
    );
  }

  final String id;
  final String name;
  final String dob;
  final String bloodGroup;

  @override
  List<Object?> get props => [id, name, dob, bloodGroup];
}
