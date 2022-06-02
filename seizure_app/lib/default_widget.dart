import 'package:flutter/material.dart';

SliverList sliverList({required Widget child}) {
  return SliverList(
    delegate: SliverChildListDelegate(
      <Widget>[child],
    ),
  );
}
