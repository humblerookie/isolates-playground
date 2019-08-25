import 'dart:isolate';

import 'package:rxdart/rxdart.dart';

Future<int> startIsolate(int a) async {
  ReceivePort receivePort = ReceivePort(); //port for this main isolate to receive messages.
  Isolate isolate = await Isolate.spawn(
      isolateTask, Pair(a, receivePort.sendPort),
      errorsAreFatal: true, paused: true);
  return await receivePort.first;
}

void isolateTask(Pair<int, SendPort> pair) {
  var value = calculateFib(pair.first);
  pair.second.send(value);

  Observable.fromFuture(startIsolate(100));
}

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);
}

int calculateFibN(int n) {
  return calculateFib(n);
}

int calculateFib(int n) {
  if (n <= 1)
    return n;
  else
    return calculateFib(n - 1) + calculateFib(n - 2);
}
