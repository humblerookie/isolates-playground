import 'dart:isolate';
import 'dart:isolate' as prefix0;

Future<int> startIsolate(int a) async {
  ReceivePort receivePort =
      ReceivePort(); //port for this main isolate to receive messages.
  prefix0.Isolate isolate = await Isolate.spawn(
      isolateTask, Pair(a, receivePort.sendPort),
      errorsAreFatal: true, paused: true);
  isolate.resume(isolate.pauseCapability);
  return await receivePort.first;
}

void isolateTask(Pair<int, SendPort> pair) {
  var value = calculateFib(pair.first);
  pair.second.send(value);
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
