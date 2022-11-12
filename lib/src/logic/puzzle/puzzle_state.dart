part of 'puzzle_cubit.dart';

enum GameStatus {
  created,
  playing,
  solved,
}

abstract class PuzzleState extends Equatable{
  const PuzzleState();

  @override
  List<Object> get props => [];
}

class PuzzleInitial extends PuzzleState {
  const PuzzleInitial();
}

class OnFinish extends PuzzleState {
  const OnFinish ();
}

class StartPuzzle extends PuzzleState {
  const StartPuzzle({
    required this.crossAxisCount,
    required this.puzzle,
    required this.solved,
    required this.moves,
    required this.status,
  });
  final int crossAxisCount;
  final Puzzle puzzle;
  final bool solved;
  final int moves;
  final GameStatus status;

  StartPuzzle copyWith({
    int? crossAxisCount,
    int? moves,
    Puzzle? puzzle,
    bool? solved,
    GameStatus? status,
  }){
    return StartPuzzle(
      status: status ?? this.status,
      moves: moves ?? this.moves,
      crossAxisCount: crossAxisCount ?? this.crossAxisCount,
      puzzle: puzzle ?? this.puzzle,
      solved: solved ?? this.solved,
    );
  }

  @override
  List<Object> get props => [
    moves,
    crossAxisCount,
    puzzle,
    solved,
    status,
  ];
}