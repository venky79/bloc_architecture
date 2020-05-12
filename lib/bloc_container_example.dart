import 'package:flutter/material.dart';
import 'bloc_provider.dart';

/// to create a bloc container for [ExamplesBloc] create a bloc and
/// use this class as a reference only and create your own bloc container
/// with the name that matches your created bloc.

class ExampleBlocContainer extends StatefulWidget {
  final Widget child;
  final ExamplesBloc bloc;
  ExampleBlocContainer({@required this.child, @required this.bloc});

  @override
  ExampleBlocContainerState createState() {
    return ExampleBlocContainerState();
  }

  static ExamplesBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<_InheritedBlocStateContainer>())
        .blocState
        .bloc;
  }
}

class ExampleBlocContainerState extends State<ExampleBlocContainer> {
  ExamplesBloc bloc;
  Widget child;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = widget.bloc;
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedBlocStateContainer(
      child: widget.child,
      blocState: this,
    );
  }
}

class _InheritedBlocStateContainer extends InheritedWidget {
  final ExampleBlocContainerState blocState;
  final Widget child;
  _InheritedBlocStateContainer({this.blocState, this.child});

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

// an example of bloc creation this class was created to
// to illustrate how to create a bloc and get its instance in the
// child classes instead of initiating a bloc every time

class ExamplesBloc extends BlocBase {
  ExamplesBloc();

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
