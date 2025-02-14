import 'package:equatable/equatable.dart';
import 'package:my_puzzle/src/domain/models/position.dart';

class Tile extends Equatable {
  final int value;
  final Position position;
  final Position correctPosition;
  final String? image;

  const Tile({
    required this.value,
    required this.position,
    required this.correctPosition,
    this.image,
  });

  Tile move(Position newPosition) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      position: newPosition,
      image: image,
    );
  }

  @override
  List<Object?> get props => [
    position,
    correctPosition,
    value,
    image,
  ];
}
