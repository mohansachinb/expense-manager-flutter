import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  static const int _databaseVersion = 2;
  static const String _settingsTable = 'settings';
  static const String _monthlyBudgetKey = 'monthly_budget';

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'expense_manager.db');

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createTransactionsTable(db);
        await _createSettingsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createSettingsTable(db);
        }
      },
    );

    return _database!;
  }

  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<void> _createSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Save a transaction.
  Future<int> addTransaction(TransactionModel transaction) async {
    final db = await database;

    return db.insert('transactions', transaction.toMap()..remove('id'));
  }

  // Retrieve all transactions.
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');

    return rows.map(TransactionModel.fromMap).toList();
  }

  // Update a transaction.
  Future<int> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction ID is required.');
    }

    final db = await database;

    return db.update(
      'transactions',
      transaction.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Delete a transaction.
  Future<int> deleteTransaction(int id) async {
    final db = await database;

    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Read the saved monthly budget. Zero means no budget has been set.
  Future<double> getMonthlyBudget() async {
    final db = await database;

    final rows = await db.query(
      _settingsTable,
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [_monthlyBudgetKey],
      limit: 1,
    );

    if (rows.isEmpty) return 0.0;

    return double.tryParse(rows.first['value'].toString()) ?? 0.0;
  }

  // Save or update the monthly budget.
  Future<void> setMonthlyBudget(double amount) async {
    if (!amount.isFinite || amount < 0) {
      throw ArgumentError('Budget must be a valid non-negative amount.');
    }

    final db = await database;

    await db.insert(_settingsTable, {
      'key': _monthlyBudgetKey,
      'value': amount.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Calculate expenses for a specified month.
  // The end date is exclusive, so the first day of the next month is excluded.
  Future<double> getMonthlyExpenseTotal({DateTime? month}) async {
    final db = await database;
    final selectedMonth = month ?? DateTime.now();

    final start = DateTime(selectedMonth.year, selectedMonth.month, 1);

    final end = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

    final startDate = _dateKey(start);
    final endDate = _dateKey(end);

    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(amount), 0) AS total
      FROM transactions
      WHERE type = ?
        AND date >= ?
        AND date < ?
      ''',
      ['Expense', startDate, endDate],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
