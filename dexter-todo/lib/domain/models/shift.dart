import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  const Shift({
    required this.type,
    required this.id,
    required this.start,
  });

  factory Shift.empty() {
    return const Shift(
      type: '',
      id: '',
      start: '',
    );
  }

  final String id;
  final String type;
  final String start;

  @override
  List<Object?> get props => [id, type, start];
}
