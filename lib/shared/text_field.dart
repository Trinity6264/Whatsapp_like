import 'package:flutter/material.dart';

const InputDecoration txtField = const InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  fillColor: Colors.white,
  filled: true,
  border: InputBorder.none,
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
  ),
);
