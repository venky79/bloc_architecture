import 'package:flutter/material.dart';

import 'bloc_provider.dart';

class BlocInheritedProvider<T extends BlocBase> extends StatefulWidget {
  BlocInheritedProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BlocInheritedProviderState<T> createState() =>
      _BlocInheritedProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    _BlocProviderInherited<T> provider = context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()
        .widget;
    return provider.bloc;
  }
}

class _BlocInheritedProviderState<T extends BlocBase>
    extends State<BlocInheritedProvider<T>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _BlocProviderInherited<T>(
        child: widget.child,
        bloc: widget.bloc,
      ),
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => true;
}
