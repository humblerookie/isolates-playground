import 'package:rxdart/rxdart.dart';

class Service {
  // ignore: close_sinks
  PublishSubject<int> subject =
      new PublishSubject<int>(onListen: doOnSubscribe);
}

Service service = new Service();

void doOnSubscribe() {
  print("Someone subscribed to me, yeay :)!! But seems only once :(");
}
