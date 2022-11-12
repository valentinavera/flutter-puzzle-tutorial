import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_puzzle/src/domain/models/tile.dart';
import 'package:my_puzzle/src/logic/puzzle/puzzle_cubit.dart';

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
              MovesWidget(),
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

class MovesWidget extends StatelessWidget {
  const MovesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<PuzzleCubit, PuzzleState>(
        builder: (context, state) {
          if(state is StartPuzzle) return Text("Moves: ${state.moves}");
          return Container();
        },
      ),
    );
  }
}

class PuzzleGameInteractor extends StatelessWidget {
  const PuzzleGameInteractor({Key? key}) : super(key: key);

  void _puzzleCubitListener(BuildContext context, PuzzleState state){
    if(state is OnFinish){
      BlocProvider.of<PuzzleCubit>(context).initPuzzle();
      _showWinnerDialog(context);
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
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("GREAT JOB"),
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
              return TextButton(
                onPressed: () => _puzzleCubit.shuffle(), 
                child: const Text(
                  "Comenzar",
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
