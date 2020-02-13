// Copyright (c) 2018, the Dart Team. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be found in
// the LICENSE file.

// Try out some reflective invocations.
// Build with `cd ..; pub run build_runner build example`.

import 'dart:ui';

import 'package:flutter/material.dart';

@GlobalQuantifyCapability(r'\.Scaffold$', refector)
@GlobalQuantifyCapability(r'\.Color$', refector)
import 'package:reflectable/reflectable.dart';

class MyReflectable extends Reflectable {
  const MyReflectable() : super(invokingCapability, declarationsCapability);
}

const refector = const MyReflectable();

@refector
class A {
  A(this.value);

  int value;
  int arg0() => value;
  int arg1(int x) => x - value;
  int arg1to3(int x, int y, [int z = 0, w]) => x + y + z * value;
  int argNamed(int x, int y, {int z: 42}) => x + y - z;
  int operator +(x) => value + x;
  int operator [](x) => value + x;
  void operator []=(x, v) {
    f = x + v;
  }

  int operator -() => -f;
  int operator ~() => f + value;

  int f = 0;

  static int noArguments() => 42;
  static int oneArgument(x) => x - 42;
  static int optionalArguments(x, y, [z = 0, w]) => x + y + z * 42;
  static int namedArguments(int x, int y, {int z: 42}) => x + y - z;
}

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
