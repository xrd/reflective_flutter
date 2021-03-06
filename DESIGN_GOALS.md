# reflective flutter

## Steps to run 

* Open in Intellij.
* Run the app.
* Right now the app is hard coded to go into the inspection if-branch. If you want to see how it would run without that, change [true to false](https://github.com/xrd/reflective_flutter/blob/master/lib/state_injector.dart#L21).

## Goals

* make an "annotation" that can be added to a widget that injects at runtime an alternative stateful component (called [`@stateInjector`](https://github.com/xrd/reflective_flutter/blob/master/lib/main.dart#L33) here).
  * I would love to have the annotation actually override the `createState()` method, maybe by passing in a type. So, the annotation could look like `@stateInjector(MyHomePageState)`. But, in the meanwhile...
  * the easy way was for the annotation to have a [method](https://github.com/xrd/reflective_flutter/blob/master/lib/main.dart#L40) like this `Object createState(String methodName, Function() fn)`. It takes a function, which returns an object (that happens to inherit from ` State<T>` but the annotation should not need to know that before hand.
* the `createState` function from the stateInjector can either return the object created in the closure as-is, [or under certain conditions](https://github.com/xrd/reflective_flutter/blob/master/lib/state_injector.dart#L21), call methods defined in the signature of the call (right now the switch is just a boolean that I can change in the debugger).
* under normal conditions, the `createState` has exactly the same behavior as the default create state call you get when you create a new flutter project: `MyHomePageState createState() => new MyHomePageState();`
* Obviously, reflection does not handle private methods, so `_incrementCounter` needs to be changed to `incrementCounter`. 
* Does the private state object need to go from `_MyHomePageState` to `_MyHomePageState`? Since it is in a closure, can `reflectable` figure out the type, methods, etc at runtime?
* Is it an issue that the parent widget has not yet been rendered when the `incrementCounter` method is called? Seems like the rendering process should be independent of the state object? I can't imagine this is an issue, since we `createState() => new MyHomePageState()`. 

Problems so far:

**error with reflectable not initialized**

```
05-09 20:46:47.875 10144-10165/com.yourcompany.simpleflutter I/flutter: ══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════
05-09 20:46:47.887 10144-10165/com.yourcompany.simpleflutter I/flutter: The following StateError was thrown building Builder:
05-09 20:46:47.887 10144-10165/com.yourcompany.simpleflutter I/flutter: Bad state: Reflectable has not been initialized. Did you forget to add the main file to the
05-09 20:46:47.887 10144-10165/com.yourcompany.simpleflutter I/flutter: reflectable transformer's entry_points in pubspec.yaml?
05-09 20:46:47.894 10144-10165/com.yourcompany.simpleflutter I/flutter: When the exception was thrown, this was the stack:
05-09 20:46:47.908 10144-10165/com.yourcompany.simpleflutter I/flutter: #0      data (package:reflectable/src/reflectable_transformer_based.dart:172:5)
05-09 20:46:47.908 10144-10165/com.yourcompany.simpleflutter I/flutter: #1      data (package:reflectable/src/reflectable_transformer_based.dart:171:33)
05-09 20:46:47.908 10144-10165/com.yourcompany.simpleflutter I/flutter: #2      _DataCaching._data (package:reflectable/src/reflectable_transformer_based.dart:193:20)
```

I have tried to add `initializeReflectable();` to both the `main()` function and inside the state_injector.dart file 
but always get "The method initializeReflectable(); isn't defined for class StateInjector"

**testing package is not compatible with reflectable?**
 
I had to comment this out:
```
dev_dependencies:
#  flutter_test:
#    sdk: flutter
```

Otherwise, I get this:

```
$ flutter --no-color packages get
Running "flutter packages get" in simple_flutter...
The current Dart SDK version is 2.0.0-edge.c080951d45e79cd25df98036c4be835b284a269c.

Because reflectable >=2.0.0-dev.1.0 <2.0.0 depends on path >=1.2.0 <1.5.0 and reflectable >=1.0.1
  <1.0.4 depends on analyzer >=0.27.2 <0.30.0, reflectable >=1.0.1 <1.0.4 or >=2.0.0-dev.1.0 <2.0.0
  requires path >=1.2.0 <1.5.0 or analyzer >=0.27.2 <0.30.0.
And because reflectable >=0.5.3 <1.0.1 depends on analyzer ^0.27.2 and reflectable >=0.5.1 <0.5.3
  depends on analyzer 0.27.1, reflectable >=0.5.1 <1.0.4 or >=2.0.0-dev.1.0 <2.0.0 requires path
  >=1.2.0 <1.5.0 or analyzer 0.27.1 or >=0.27.2 <0.30.0.
And because reflectable >=0.5.0 <0.5.1 depends on analyzer ^0.27.0 and reflectable >=0.3.3 <0.3.4
  depends on analyzer ^0.26.1+10, reflectable >=0.3.3 <0.3.4 or >=0.5.0 <1.0.4 or >=2.0.0-dev.1.0
  <2.0.0 requires path >=1.2.0 <1.5.0 or analyzer >=0.26.1+10 <0.30.0.
And because reflectable >=0.1.2 <0.3.3 depends on analyzer ^0.26.0 which depends on args >=0.12.1
  <0.14.0, reflectable >=0.1.2 <0.3.4 or >=0.5.0 <1.0.4 or >=2.0.0-dev.1.0 <2.0.0 requires args
  >=0.12.1 <0.14.0 or path >=1.2.0 <1.5.0.
And because reflectable >=0.3.4 <0.5.0 depends on analyzer >=0.26.0 <=0.26.1+14 and reflectable
  <0.1.2 depends on analyzer ^0.25.0, reflectable <1.0.4 or >=2.0.0-dev.1.0 <2.0.0 requires args
  >=0.12.1 <0.14.0 or path >=1.2.0 <1.5.0 or analyzer >=0.25.0 <=0.26.1+14.
And because reflectable 2.0.0 depends on barback >=0.15.0 <0.15.2+15 and test >=0.12.24+7 depends
  on analyzer >=0.26.4 <0.32.0, if reflectable <1.0.4 or >=2.0.0-dev.1.0 <=2.0.0 and test
  >=0.12.24+7 then args >=0.12.1 <0.14.0 or path >=1.2.0 <1.5.0 or barback >=0.15.0 <0.15.2+15.
And because every version of flutter_test from sdk depends on both args 1.4.2 and barback
  0.15.2+15, if reflectable <1.0.4 or >=2.0.0-dev.1.0 <=2.0.0 and test >=0.12.24+7 and flutter_test
  any from sdk then path >=1.2.0 <1.5.0.
And because every version of flutter_test from sdk depends on both path 1.5.1 and test 0.12.34,
  flutter_test from sdk is incompatible with reflectable <1.0.4 or >=2.0.0-dev.1.0 <=2.0.0.
And because reflectable >=1.0.4 <2.0.0-dev.1.0 requires SDK version >=1.12.0 <2.0.0-dev.infinity
  and no versions of reflectable match >2.0.0, flutter_test from sdk is incompatible with
  reflectable.
So, because simple_flutter depends on both reflectable any and flutter_test any from sdk, version
  solving failed.
pub get failed (1)
Process finished with exit code 1

```
