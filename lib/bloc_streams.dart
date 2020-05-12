library blocarchitecture;
import 'dart:async';

///  A wrapper for the most common communications needs between blocs and widgets.
///
///  Works as a bidirectional transmission medium that handles one specific
///  data type (defined by the Generics parameter). Once created, it can send
///  one or more instances of the defined type to any listener.
///
///  When creating an instance of this class, don't forget to use the dispose
///  method accordingly to clean up any memory assigned to subscriptions.
class Pipe<T> {
  StreamController<T> _controller;
  T initialData;
  bool hasListeners = false;

  /// Use this attribute as the value for a stream parameter in Stream Builders
  /// or to create custom listeners, ex. receive.listen(...)
  Stream<T> get receive => _controller.stream;

  /// Initial data is useful for Stream Builders, so that the first build
  /// includes mocked or default data while the snapshot receives the first
  /// real data package.
  Pipe({this.initialData}) {
    _controller = StreamController<T>();
    _controller.onListen = () {
      hasListeners = true;
    };
  }

  void dispose() {
    _controller.close();
  }

  /// This is the method to use to transmit the data package. Returns false
  /// when the controller has been closed by some reason, for example if the
  /// pipe was still alive at the time the parent widget is removed from the
  /// screen and recycled.
  bool send(T data) {
    if (!_controller.isClosed) {
      _controller.sink.add(data);
      return true;
    }
    return false;
  }

  /// This method is used to send error response,
  /// which can be accessible from snapshot.hasError
  /// for example if any API sends network error instead of success response
  /// this can be triggered by stream builder where snapshot.hasError
  bool throwError(Object error) {
    if (!_controller.isClosed) {
      _controller.addError(error);
      return true;
    }
    return false;
  }
}

/// A class to allow communication between UI and Blocs without sending data.
///
/// On those occasions where no data is needed to be sent, it's better to create
/// an instance of this class.
class EventPipe extends Pipe<void> {
  /// Call this to start the communication and trigger any listening callbacks
  /// on the other end of the pipe.
  bool launch() {
    return send(null);
  }

  /// Receiving end of the pipe, just takes a callback without parameters.
  StreamSubscription<void> listen(void onData()) {
    return _controller.stream.listen((_) => onData());
  }

  /// Added to prevent using this method, since events should use listen instead
  @override
  get receive => null;
}

/// A class to handle multiple subscribers per data transmission
///
/// For scenarios where more than one listeners are needed (for example, when
/// sending the status of a checkbox to the Bloc, but also to a listener on
/// the UI to change the state value of the same checkbox).
class BroadcastPipe<T> extends Pipe<T> {
  BroadcastPipe({T initialData}) : super(initialData: initialData) {
    _controller = StreamController<T>.broadcast();
    _controller.onListen = () {
      hasListeners = true;
    };
  }
}

/// A class to allow communication between UI and Blocs without sending data.
///
/// On those occasions where no data is needed to be sent, it's better to create
/// an instance of this class.
class BroadcastEventPipe extends BroadcastPipe<void> {
  /// Call this to start the communication and trigger any listening callbacks
  /// on the other end of the pipe.
  bool launch() {
    return send(null);
  }

  /// Receiving end of the pipe, just takes a callback without parameters.
  StreamSubscription<void> listen(void onData()) {
    return _controller.stream.listen((_) => onData());
  }

  /// Added to prevent using this method, since events should use listen instead
  @override
  get receive => null;
}

