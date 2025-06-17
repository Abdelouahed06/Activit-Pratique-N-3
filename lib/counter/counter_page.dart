import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'StatefulWidget Counter:',
              style: TextStyle(fontSize: 20),
            ),
            const StatefulCounter(),
            const SizedBox(height: 50),
            const Text(
              'BLoC Counter:',
              style: TextStyle(fontSize: 20),
            ),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.count}',
                  style: const TextStyle(fontSize: 40),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'bloc_minus',
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementEvent());
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'bloc_plus',
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementEvent());
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatefulCounter extends StatefulWidget {
  const StatefulCounter({super.key});

  @override
  State<StatefulCounter> createState() => _StatefulCounterState();
}

class _StatefulCounterState extends State<StatefulCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$_count',
          style: const TextStyle(fontSize: 40),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'stateful_minus',
              onPressed: () {
                setState(() {
                  _count--;
                });
              },
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'stateful_plus',
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
} 