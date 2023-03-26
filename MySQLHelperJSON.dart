import 'package:mysql1/mysql1.dart';
import 'dart:convert';

class MySQLHelper {
  late MySqlConnection _connection;

  MySQLHelper({
    required String host,
    required int port,
    required String user,
    required String password,
    required String db,
  }) {
    _connection = MySqlConnection(
      settings: ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db,
      ),
    );
  }

  Future<void> connect() async {
    await _connection.open();
  }

  Future<void> disconnect() async {
    await _connection.close();
  }

  Future<String> select(String table,
      {List<String>? columns, String? where, int? limit}) async {
    String query = 'SELECT ${columns != null ? columns.join(',') : '*'} '
        'FROM $table '
        '${where != null ? 'WHERE $where' : ''} '
        '${limit != null ? 'LIMIT $limit' : ''}';
    var result = await _connection.query(query);
    return jsonEncode(result.toList());
  }

  Future<void> update(String table, Map<String, dynamic> values,
      {String? where}) async {
    String query = 'UPDATE $table SET '
        '${values.entries.map((e) => '${e.key} = ${e.value}').join(',')} '
        '${where != null ? 'WHERE $where' : ''}';
    await _connection.query(query);
  }

  Future<void> delete(String table, {String? where}) async {
    String query = 'DELETE FROM $table '
        '${where != null ? 'WHERE $where' : ''}';
    await _connection.query(query);
  }

  Future<void> execute(String query) async {
    await _connection.query(query);
  }
}
