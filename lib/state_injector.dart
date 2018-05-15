import 'package:reflectable/reflectable.dart' as reflectable;
// import "./main.dart"
import 'dart:io' show Platform;

//import 'state_injector.reflectable.dart';

// Annotation instance
const stateInjector = const StateInjector();

// Annotation Class
class StateInjector extends reflectable.Reflectable {
  const StateInjector() : super(reflectable.instanceInvokeCapability);

  Object createState(Function() fn, List<String> args) {
    // For some reason, breakpoints are never hit (tree shaking?) so you have to
    // just manually adjust this value and restart the app
    bool runInjection = true;

    if (runInjection) {
//      initializeReflectable(); // Set up reflection support => THIS FAILS, WHY?
//      reflectable.InstanceInvokeMetaCapability;
      Object obj = fn();

      // Can we figure out the runtime type of the object?
      Type runtimeType = obj.runtimeType;
      print(runtimeType);

      // Crash here.
      reflectable.InstanceMirror instanceMirror = stateInjector.reflect(obj);

      // Never gets here
      String functionName = args.first;
      args.removeAt(0);
      print(instanceMirror.invoke(functionName, args));

      return obj;
    }
    else
      return fn();
  }

}

