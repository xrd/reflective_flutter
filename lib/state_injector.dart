 import 'package:reflectable/reflectable.dart' as reflectable;
// import "./main.dart"
import 'dart:io' show Platform;

//import 'state_injector.reflectable.dart';

// Annotation instance
const stateInjector = const StateInjector();

 // Annotation Class
class StateInjector extends reflectable.Reflectable {
  const StateInjector() : super(reflectable.instanceInvokeCapability);

  void doSomething() {
    print("Hi");
  }

  Object createState(String functionName, Function() fn) {
    bool runInjection = false;
    bool somethingElse = true;
    runInjection = runInjection || somethingElse || (Platform.environment["IS_TEST"] != null);

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
      print(instanceMirror.invoke(functionName, []));

      return obj;
    }
    else
      return fn();
  }

}


