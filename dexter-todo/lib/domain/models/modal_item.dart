import 'package:equatable/equatable.dart';

class ModalItem extends Equatable {
  const ModalItem(this.key, this.value);

  final String key;
  final String value;

  @override
  List<Object?> get props => [key, value];
}
