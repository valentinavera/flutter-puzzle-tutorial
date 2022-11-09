import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_puzzle/src/domain/models/puzzle.dart';
import 'package:my_puzzle/src/domain/models/tile.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() 
  : super(PuzzleInitial(
    crossAxisCount: 4, 
    moves: 0, 
    puzzle: Puzzle.create(4), 
    solved: false, 
    status: GameStatus.created,
  ));

  PuzzleState _state = PuzzleState(
    crossAxisCount: 4, 
    puzzle: Puzzle.create(4), 
    solved: false, 
    moves: 0, 
    status: GameStatus.created
  );

  PuzzleState get puzzleState => _state;
  Puzzle get puzzle => _state.puzzle;

  void onTileTapped(Tile tile) {
    final canMove = puzzle.canMove(tile.position);
    if (canMove) {
      final newPuzzle = puzzle.move(tile);
      final solved = newPuzzle.isSolved();
      _state = puzzleState.copyWith(
        puzzle: newPuzzle,
        moves: puzzleState.moves + 1,
        status: solved ? GameStatus.solved : puzzleState.status,
      );
      emit(puzzleState);
      if (solved) {
        // _streamController.sink.add(null);
      }
    }
  }

  void shuffle() {
    _state = state.copyWith(
      puzzle: puzzle.shuffle(),
      status: GameStatus.playing,
      moves: 0,
    );
    emit(_state);
  }
  
}
