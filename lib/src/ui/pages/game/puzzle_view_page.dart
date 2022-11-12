import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_puzzle/src/domain/models/tile.dart';
import 'package:my_puzzle/src/logic/puzzle/puzzle_cubit.dart';
import 'package:my_puzzle/src/ui/utils/time_parser.dart';

class PuzzleViewPage extends StatelessWidget {
  const PuzzleViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PuzzleCubit>(
      create: (context) => PuzzleCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TimeAndMoves(),
              Padding(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PuzzleGameInteractor(),
                ),
              ),
              PuzzleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeAndMoves extends StatelessWidget {
  const TimeAndMoves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = BlocProvider.of<PuzzleCubit>(context, listen: false).time;

    return BlocBuilder<PuzzleCubit, PuzzleState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: time,
              builder: (_, time, icon) {
                return Row(
                  children: [
                    icon!,
                    Text(
                      parseTime(time),
                    ),
                  ],
                );
              },
              child: const Icon(
                Icons.watch,
              ),
            ),
            if(state is StartPuzzle) Text("Moves: ${state.moves}"),
          ],
        );
      },
    );
  }
}

class PuzzleGameInteractor extends StatelessWidget {
  const PuzzleGameInteractor({Key? key}) : super(key: key);

  void _puzzleCubitListener(BuildContext context, PuzzleState state){
    if(state is OnFinish){
      final _puzzleFinishCubit = BlocProvider.of<PuzzleCubit>(context);
      _puzzleFinishCubit.initPuzzle();
      _showWinnerDialog(context, _puzzleFinishCubit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _puzzleCubit = BlocProvider.of<PuzzleCubit>(context);
    _puzzleCubit.initPuzzle();

    return Container(
      color: Colors.black12,
      child: BlocConsumer<PuzzleCubit, PuzzleState>(
        listener: _puzzleCubitListener,
        bloc: _puzzleCubit,
        builder: (context, state) {
          if(state is StartPuzzle){
            return LayoutBuilder(
              builder: (context, constraints) {
                final tileSize = constraints.maxWidth / state.crossAxisCount;
                return AbsorbPointer(
                  absorbing: state.status != GameStatus.playing,
                  child: Stack(
                    children: state.puzzle.tiles
                      .map(
                        (e) => PuzzleTile(
                          tile: e,
                          size: tileSize,
                          onTap: () => _puzzleCubit.onTileTapped(e),
                        ),
                      )
                      .toList(),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void _showWinnerDialog(
    BuildContext context,
    PuzzleCubit controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("GREAT JOB"),
            Text("moves: ${controller.puzzleState.moves}"),
            Text("time: ${parseTime(controller.time.value)}"),
            const SizedBox(height: 20),
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzleTile extends StatelessWidget {
  final Tile tile;
  final double size;
  final VoidCallback onTap;
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(
        milliseconds: 200,
      ),
      left: (tile.position.x - 1) * size,
      top: (tile.position.y - 1) * size,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(1),
          width: size - 2,
          height: size - 2,
          alignment: Alignment.center,
          child: //Image.asset(tile.image!),
          Text(
            tile.value.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class PuzzleButton extends StatelessWidget {
  const PuzzleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _puzzleCubit = BlocProvider.of<PuzzleCubit>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: BlocBuilder<PuzzleCubit, PuzzleState>(
        bloc: _puzzleCubit,
        builder: (context, state) {
          if(state is StartPuzzle){
            if( state.status == GameStatus.created){
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _puzzleCubit.shuffle(),
                    icon: const Icon(
                      Icons.replay_rounded,
                    ),
                    label: const Text(
                      "START",
                    ),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<int>(
                    items: [3, 4, 5, 6]
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text("${e}x$e"),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (crossAxisCount) {
                      if (crossAxisCount != null && crossAxisCount != state.crossAxisCount) {
                        _puzzleCubit.changeGrid(crossAxisCount);
                      }
                    },
                    value: state.crossAxisCount,
                  ),
                ],
              );
            }
            if( state.status == GameStatus.playing){
              return Center(
                child: TextButton.icon(
                  onPressed: () => _puzzleCubit.shuffle(),
                  icon: const Icon(
                    Icons.replay_rounded,
                  ),
                  label: const Text(
                    "RESET",
                  ),
                ),
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
