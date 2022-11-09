part of 'puzzle_cubit.dart';

enum GameStatus {
  created,
  playing,
  solved,
}

class PuzzleState extends Equatable {
  const PuzzleState({
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

  PuzzleState copyWith({
    int? crossAxisCount,
    int? moves,
    Puzzle? puzzle,
    bool? solved,
    GameStatus? status,
  }){
    return PuzzleState(
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

class PuzzleInitial extends PuzzleState {
  const PuzzleInitial({
    required int crossAxisCount, 
    required Puzzle puzzle, 
    required bool solved, 
    required int moves, 
    required GameStatus status
  }) : super(
    crossAxisCount: crossAxisCount, 
    puzzle: puzzle, 
    solved: solved, 
    moves: moves, 
    status: status
  );
}

// class OnFinish extends PuzzleState { csonst OnFinish() : super(crossAxisCount: 0, moves: 0, solved: true, puzzle: Puzzle.create(0), status: GameStatus.solved); }

