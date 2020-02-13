// Copyright (c) 2018, the Dart Team. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in
// the LICENSE file.

// Try out some reflective invocations.
// Build with `cd ..; pub run build_runner build example`.

// List All Objects!
@GlobalQuantifyCapability(r'\.Scaffold$', refector)
@GlobalQuantifyCapability(r'\.Color$', refector)

import 'package:reflectable/reflectable.dart';

class MyReflectable extends Reflectable {
  const MyReflectable() : super(invokingCapability, declarationsCapability);
}

const refector = const MyReflectable();

void createObjects(List<Object> objs) {
  objs.forEach((element) {
    ObjectMirror colorMirror = refector.reflect(element);
  });
}

List<String> getConstructorOptions(Type type) {
  ClassMirror mirror = refector.reflectType(type);

  List<DeclarationMirror> constructors =
      new List.from(mirror.declarations.values.where((declare) {
    return declare is MethodMirror && declare.isConstructor;
  }));
  List<String> _options = [];
  constructors.forEach((construtor) {
    if (construtor is MethodMirror) {
      List<ParameterMirror> parameters = construtor.parameters;
      parameters.forEach((param) {
        _options.add(param.simpleName);
      });
    }
  });
  return _options;
}
