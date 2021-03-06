
import 'package:floor/floor.dart';
import 'package:i_chaos/ichaos/todo/todo-domain/common/entity/todo_entity.dart';

const String _todoEntityTableName = 'tb_todo';

@dao
abstract class TodoDao {
  @insert
  Future<int> insertTodo(TodoEntity todo);

  @Query('SELECT * FROM $_todoEntityTableName WHERE id=:id')
  Future<TodoEntity?> findById(int id);

  @Query('SELECT * FROM tb_todo')
  Future<List<TodoEntity>> list();

  @Query('DELETE FROM $_todoEntityTableName WHERE id=:id')
  Future<void> deleteById(int id);

  @Query('DELETE FROM $_todoEntityTableName WHERE id in (:ids)')
  Future<void> deleteByIds(List<int> ids);

  @Query('DELETE FROM $_todoEntityTableName')
  Future<void> deleteAll();

  @Query('DELETE FROM $_todoEntityTableName WHERE valid_time >= :start and valid_time <= :end')
  Future<void> deleteAllOfDay(String start, String end);

  @Query('SELECT * FROM $_todoEntityTableName WHERE valid_time >= :start and valid_time <= :end')
  Future<List<TodoEntity>> listByTime(String start, String end);

  @Query("SELECT * FROM $_todoEntityTableName WHERE valid_time is null or valid_time = ''")
  Future<List<TodoEntity>> listByNoValidTime();

  @update
  Future<int> updateTodo(TodoEntity todo);

  @Query('UPDATE $_todoEntityTableName SET tag=null WHERE tag=:tagId')
  Future<int?> updateTodoTag(int tagId);
}