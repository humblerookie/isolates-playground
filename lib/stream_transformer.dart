import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:isolate/isolate_runner.dart';
import 'package:isolate/load_balancer.dart';

class IoTransformer<S, T> implements StreamTransformer<S, T> {
  StreamController _controller;

  StreamSubscription _subscription;

  Function _transformer;
  int _streamCounter = 0;
  bool _sourceStreamClosed = false;
  bool cancelOnError;

  bool get isPending => _streamCounter != 0;

  // Original Stream
  Stream<S> _stream;

  IoTransformer(S transform(T value), {bool sync: false, this.cancelOnError}) {
    _transformer = transform;
    _controller = new StreamController<T>(
        onListen: _onListen,
        onCancel: _onCancel,
        onPause: () {
          _subscription.pause();
        },
        onResume: () {
          _subscription.resume();
        },
        sync: sync);
  }

  IoTransformer.broadcast({bool sync: false, bool this.cancelOnError}) {
    _controller = new StreamController<T>.broadcast(
        onListen: _onListen, onCancel: _onCancel, sync: sync);
  }

  void _onListen() {
    _subscription = _stream.listen(onData,
        onError: _controller.addError,
        onDone: onDone,
        cancelOnError: cancelOnError);
  }

  void _onCancel() {
    _subscription.cancel();
    _subscription = null;
  }

  /**
   * Transformation
   */

  void onDone() {
    if (!isPending) {
      _controller.close();
    }
    _sourceStreamClosed = true;
  }

  void onData(S data) {
    _streamCounter++;
    initLoadbalancer().then((val) {
      _loadBalancer.run(_transformer, data).then((transformed) {
        _controller.add(transformed as T);
        _pop_and_close();
      }, onError: (error) {
        _pop_and_close();
        throw error;
      });
    });
  }

  Stream<T> bind(Stream<S> stream) {
    this._stream = stream;
    return _controller.stream;
  }

  void _pop_and_close() {
    _streamCounter--;
    if (!isPending && _sourceStreamClosed) {
      _controller.close();
    }
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return null;
  }

  static LoadBalancer _loadBalancer;
  static const int POOL_SIZE = 6;

  static Future<void> initLoadbalancer() async {
    if (_loadBalancer == null) {
      _loadBalancer = await LoadBalancer.create(POOL_SIZE, IsolateRunner.spawn);
    }
  }
}