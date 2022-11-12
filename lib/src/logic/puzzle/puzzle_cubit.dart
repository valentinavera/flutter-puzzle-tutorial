import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_puzzle/src/domain/models/puzzle.dart';
import 'package:my_puzzle/src/domain/models/tile.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(const PuzzleInitial());

  StartPuzzle _state = StartPuzzle(
    crossAxisCount: 3, 
    puzzle: Puzzle.create(3), 
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
  final ValueNotifier<int> time = ValueNotifier(0);
  Timer? _timer;


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
        _timer?.cancel();
        emit(const OnFinish());
      }
    }
  }

  void shuffle() {
    if (_timer != null) {
      time.value = 0;
      _timer!.cancel();
    }
    _state = puzzleState.copyWith(
      puzzle: puzzle.shuffle(),
      status: GameStatus.playing,
      moves: 0,
    );
    emit(_state);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        time.value++;
      },
    );
  }

  void changeGrid(int crossAxisCount) {
    _timer?.cancel();
    time.value = 0;
    final newState = StartPuzzle(
      crossAxisCount: crossAxisCount,
      puzzle: Puzzle.create(crossAxisCount),
      solved: false,
      moves: 0,
      status: GameStatus.created,
    );
    _state = newState;
    emit(_state);
  }

  void dispose() {
    _timer?.cancel();
  }
  
}
