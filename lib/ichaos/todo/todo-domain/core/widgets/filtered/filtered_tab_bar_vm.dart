import 'dart:async';

import 'package:flutter/material.dart';
import 'package:i_chaos/base_framework/view_model/single_view_state_model.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/common/enums/todo_state.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/common/models/todo_vo.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/widgets/fba/home_fab_vm.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/widgets/todolist/single_todo_list.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/widgets/todolist/single_todo_list_vm.dart';

/// 事件状态切换tabBar视图模型
class FilteredTabBarVM extends SingleViewStateModel {
  // tabBar的总个数
  final _totalTabCnt = 2;
  int _currTabIndex = 0;

  late SingleTodoListVM _singleTodoListVM;
  late DateTime _selectDate;

  FilteredTabBarVM({DateTime? selectDate, required SingleTodoListVM singleTodoListVM}) {
    _singleTodoListVM = singleTodoListVM;
    _selectDate = selectDate ?? DateTime.now();
  }

  // tab下标切换
  void tabIndexSwitch(int targetIndex) {
    if (targetIndex < 0 || targetIndex > _totalTabCnt || targetIndex == _currTabIndex) {
      return;
    }
    _currTabIndex = targetIndex;
  }

  // 选择的日期切换
  Future<void> selectedDateChange(DateTime selectDate, {int calendarPageAnimationDuration = 400}) async {
    setBusy(true);
    Future.delayed(Duration(milliseconds: calendarPageAnimationDuration)).whenComplete(() async {
      await _singleTodoListVM.switchTodoListByDate(selectDate);
      _selectDate = selectDate;
      setBusy(false);
    });
  }

  // 获取未完成事件数量
  int get activeTodoCnt => _singleTodoListVM.activeTodoCnt;

  // 获取已完成事件数量
  int get completedTodoCnt => _singleTodoListVM.completedTodoCnt;

  // 获取当前选择日期
  DateTime get currentDate => _selectDate;

  // 获取当前tabBar下标
  int get currentTabBarIndex => _currTabIndex;

  // 获取对应状态的事件列表
  List<TodoVO> get activeTodoList => _singleTodoListVM.getTodoListByState(TodoState.active);

  List<TodoVO> get completedTodoList => _singleTodoListVM.getTodoListByState(TodoState.completed);

  TodoListScrollCallback getTodoListNotifyCallback(TodoHomeFloatingActionBtnVM btnVM, bool isActive) {
    int todoListCnt = isActive ? activeTodoCnt : completedTodoCnt;
    return TodoListScrollCallback(onTodoListScrollUpdate: () {
      if (todoListCnt > 0) {
        btnVM.floatingBtnDisplayChange(FloatBtnDisplayStatus.hide);
      }
    }, onTodoListScrollEnd: () {
      if (todoListCnt > 0) {
        btnVM.floatingBtnDisplayChange(FloatBtnDisplayStatus.show);
      }
    }, onTodoListOverScroll: () {
      if (todoListCnt > 0 && !btnVM.show) {
        btnVM.floatingBtnDisplayChange(FloatBtnDisplayStatus.show);
      }
    });
  }

  @override
  Future? loadData() {
    return null;
  }

  @override
  onCompleted(data) {}
}
