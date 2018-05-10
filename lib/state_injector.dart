 import 'package:reflectable/reflectable.dart' as reflectable;
// import "./main.dart"
import 'dart:io' show Platform;

//import 'state_injector.reflectable.dart';

// Annotation instance
const stateInjector = const StateInjector();

 // Annotation Class
class StateInjector extends reflectable.Reflectable {
  const StateInjector() : super(reflectable.invokingCapability);

  void doSomething() {
    print("Hi");
  }

  Object createState(String functionName, Function() fn) {
    bool runInjection = false;
    bool somethingElse = true;
    runInjection = runInjection || somethingElse || (Platform.environment["IS_TEST"] != null);

    if (runInjection) {
//      initializeReflectable(); // Set up reflection support => THIS FAILS, WHY?
      reflectable.InstanceInvokeMetaCapability;
      Object obj = fn();
      reflectable.InstanceMirror instanceMirror = stateInjector.reflect(obj);

      print(instanceMirror.invoke(functionName, []));

      // Can we figure out the runtime type of the object?
      Type runtimeType = obj.runtimeType;
      print(runtimeType);
      return obj;
    }
    else
      return fn();
  }

}


