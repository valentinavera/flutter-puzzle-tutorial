import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_puzzle/src/domain/models/puzzle.dart';
import 'package:my_puzzle/src/domain/models/tile.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(const PuzzleInitial());

  StartPuzzle _state = StartPuzzle(
    crossAxisCount: 2, 
    puzzle: Puzzle.create(2), 
    solved: false, 
    moves: 0, 
    status: GameStatus.created
  );

  void initPuzzle(){
    emit(StartPuzzle(
      crossAxisCount: _state.crossAxisCount,
      puzzle: _state.puzzle,
      solved: _state.solved,
      moves: _state.moves,
      status: _state.status
    ));
  }
  
  StartPuzzle get puzzleState => _state;
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
        emit(const OnFinish());
      }
    }
  }

  void shuffle() {
    _state = puzzleState.copyWith(
      puzzle: puzzle.shuffle(),
      status: GameStatus.playing,
      moves: 0,
    );
    emit(_state);
  }
  
}
