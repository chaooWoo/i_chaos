import 'package:flutter/material.dart';
import 'package:i_chaos/ichaos/todos-module/todos-domain/todos-pages/todo-edit-page/editor/todo_base_editor.dart';
import 'package:i_chaos/ichaos/todos-module/todos-domain/todos-pages/todo-edit-page/editor/todo_editor.dart';

class TodoRemarkEditor extends TodoBaseEditor {
  late TextEditingController controller;

  TodoRemarkEditor(TodoEditor parentEditor) : super(parentEditor);

  @override
  bool attrVerify() => true;

  String? submit() => controller.value.text;

  @override
  void editorAttrInit() {
    controller = TextEditingController(text: parentEditor.todo.remark);
  }

  @override
  void releaseRes() {
    controller.dispose();
  }

  @override
  void writeTodoNewAttr() {
    parentEditor.todo.remark = controller.text;
  }

}