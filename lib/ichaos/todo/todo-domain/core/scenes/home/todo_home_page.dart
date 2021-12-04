import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:i_chaos/base_framework/ui/widget/provider_widget.dart';
import 'package:i_chaos/base_framework/widget_state/page_state.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/calendar/calendar_bar.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/calendar/calendar_bar_vm.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/fba/home_fab.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/fba/home_fab_vm.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/filtered/filtered_tab_bar.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/core/scenes/home/widgets/filtered/filtered_tab_bar_vm.dart';

import 'widgets/todolist/single_todo_list_vm.dart';

class TodoHomePage extends PageState with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late SingleTodoListVM _singleTodoListVM;

  @override
  void initState() {
    super.initState();
    _singleTodoListVM = SingleTodoListVM();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return switchStatusBar2Dark(
        child: ProviderWidget<SingleTodoListVM>(
      model: _singleTodoListVM,
      onModelReady: (model) {
        model.initData();
      },
      builder: (ctx, singleTodoListVM, child) {
        return ProviderWidget<FilteredTabBarVM> (
            model: FilteredTabBarVM(singleTodoListVM: singleTodoListVM),
            builder: (ctx, filteredTabBarVM, child) {
              return ProviderWidget<CalendarBarVM>(
                model: CalendarBarVM(filteredTabBarVM: filteredTabBarVM),
                builder: (ctx, calendarBarVM, _) {
                  return Scaffold(
                    appBar: _getTodoAppBar(filteredTabBarVM),
                    body: Column(children: <Widget>[
                      CalendarBar().transformToPageWidget(),
                      FilteredTabBar(
                        filteredTabBarVM: filteredTabBarVM,
                      )
                    ]),
                    floatingActionButton: ProviderWidget<TodoHomeFloatingActionBtnVM>(
                      model: TodoHomeFloatingActionBtnVM(filteredTabBarVM: filteredTabBarVM, calendarBarVM: calendarBarVM),
                      builder: (ctx, actionBtnVM, _) {
                        return TodoHomeFloatingActionBtn(actionBtnVM: actionBtnVM).transformToPageWidget();
                      },
                    ),
                  );
                },
              );
            });
      },
    ));
  }

  PreferredSizeWidget _getTodoAppBar(FilteredTabBarVM filteredTabBarVM) {
    DateTime currDate = filteredTabBarVM.currentDate;
    DateTime now = DateTime.now();
    return AppBar(
      leading: const Icon(Icons.widgets),
      title: Row(
        children: <Widget>[
          const Text(
            'ToDO',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          10.hGap,
          if ((now.month != currDate.month && now.year == currDate.year) ||
              (now.month == currDate.month && now.year != currDate.year) ||
              (now.month != currDate.month && now.year != currDate.year))
            GFButton(
              onPressed: () {},
              textColor: Colors.white,
              color: const Color(0xCF5F9EA0),
              text: '${currDate.year}.${currDate.month}',
              size: 25,
              shape: GFButtonShape.pills,
              type: GFButtonType.solid,
              padding: const EdgeInsets.symmetric(horizontal: 0),
            ),
        ],
      ),
      titleSpacing: -5,
      toolbarHeight: 40,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Open shopping cart',
          onPressed: () {
            // handle the press
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Open shopping cart',
          onPressed: () {
            // handle the press
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          tooltip: 'Open shopping cart',
          onPressed: () {
            // handle the press
          },
        ),
      ],
    );
  }
}
