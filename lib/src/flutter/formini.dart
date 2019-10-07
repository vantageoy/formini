import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:formini/src/core/formini.dart';
import 'package:redux/redux.dart';
import 'package:schemani/schemani.dart';

class Formini<T> extends StatelessWidget {
  final Schema schema;
  final Widget child;

  const Formini({Key key, this.schema, this.child})
      : assert(schema != null || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: Store(
        forminiReducer,
        initialState: {
          schema: ForminiState(),
        },
        middleware: [loggingMiddleware],
      ),
      child: child,
    );
  }
}

loggingMiddleware(Store store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');
  print('${new DateTime.now()}: ${store.state}');

  next(action);
}
