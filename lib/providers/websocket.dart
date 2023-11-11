import 'dart:async';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dartssh2/dartssh2.dart';

class WebSocketSinkWrapper implements StreamSink<List<int>> {
  final WebSocketSink _webSocketSink;

  WebSocketSinkWrapper(this._webSocketSink);

  @override
  void add(List<int> data) {
    _webSocketSink.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _webSocketSink.addError(error, stackTrace);
  }

  @override
  Future<void> close() {
    return _webSocketSink.close();
  }

  @override
  Future<void> get done => _webSocketSink.done;

  @override
  Future<void> addStream(Stream<List<int>> stream) {
    return _webSocketSink.addStream(stream);
  }
}

class WebSocketSSHSocket implements SSHSocket {
  late final WebSocketChannel _channel;
  final StreamController<Uint8List> _streamController;
  final WebSocketSinkWrapper _sinkWrapper;

  WebSocketSSHSocket._(this._channel, this._sinkWrapper)
      : _streamController = StreamController<Uint8List>.broadcast() {
    _channel.stream.listen((data) {
      _streamController.add(Uint8List.fromList(data));
    }, onDone: () {
      _streamController.close();
    }, onError: (e) {
      _streamController.addError(e);
    });
  }

  static Future<WebSocketSSHSocket> connect(String host, int port, {Duration? timeout}) async {
    final uri = Uri.parse('ws://$host:$port');
    final channel = WebSocketChannel.connect(uri);
    final sinkWrapper = WebSocketSinkWrapper(channel.sink);
    return WebSocketSSHSocket._(channel, sinkWrapper);
  }

  @override
  Stream<Uint8List> get stream => _streamController.stream;

  @override
  StreamSink<List<int>> get sink => _sinkWrapper;

  @override
  Future<void> get done => _streamController.stream.drain();

  @override
  Future<void> close() async {
    await _sinkWrapper.close();
    await _channel.sink.close();
  }

  @override
  void destroy() {
    close();
  }
}
