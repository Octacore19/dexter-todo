import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  const Shift({
    required this.type,
    required this.id,
  });

  factory Shift.empty() {
    return const Shift(type: '', id: '');
  }

  final String id;
  final String type;

  @override
  List<Object?> get props => [id, type];
}
