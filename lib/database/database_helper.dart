import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'messbook.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Members table
    await db.execute(
      '''CREATE TABLE members(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        joinDate TEXT NOT NULL,
        isActive INTEGER NOT NULL
      )''',
    );

    // Expenses table
    await db.execute(
      '''CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        paidBy TEXT NOT NULL,
        splitAmong TEXT NOT NULL,
        date TEXT NOT NULL,
        receipt TEXT
      )''',
    );

    // Meals table
    await db.execute(
      '''CREATE TABLE meals(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        mealType TEXT NOT NULL,
        date TEXT NOT NULL,
        attendees TEXT NOT NULL,
        costPerPerson REAL NOT NULL,
        notes TEXT
      )''',
    );

    // Inventory table
    await db.execute(
      '''CREATE TABLE inventory(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit TEXT NOT NULL,
        unitPrice REAL NOT NULL,
        lastUpdated TEXT NOT NULL,
        minThreshold INTEGER NOT NULL
      )''',
    );

    // Bills table
    await db.execute(
      '''CREATE TABLE bills(
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        paid REAL NOT NULL,
        pending REAL NOT NULL,
        dueDate TEXT NOT NULL,
        status TEXT NOT NULL,
        expenseIds TEXT NOT NULL
      )''',
    );

    // Settlements table
    await db.execute(
      '''CREATE TABLE settlements(
        id TEXT PRIMARY KEY,
        fromMemberId TEXT NOT NULL,
        toMemberId TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        isSettled INTEGER NOT NULL
      )''',
    );
  }

  // ==================== MEMBER OPERATIONS ====================
  Future<void> insertMember(Member member) async {
    final db = await database;
    await db.insert('members', member.toJson());
  }

  Future<List<Member>> getAllMembers() async {
    final db = await database;
    final maps = await db.query('members');
    return List.generate(maps.length, (i) => Member.fromJson(maps[i]));
  }

  Future<Member?> getMemberById(String id) async {
    final db = await database;
    final maps = await db.query('members', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Member.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateMember(Member member) async {
    final db = await database;
    await db.update('members', member.toJson(), where: 'id = ?', whereArgs: [member.id]);
  }

  Future<void> deleteMember(String id) async {
    final db = await database;
    await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== EXPENSE OPERATIONS ====================
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert('expenses', {
      ...expense.toJson(),
      'splitAmong': expense.splitAmong.join(','),
    });
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query('expenses', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['splitAmong'] = (json['splitAmong'] as String).split(',');
      return Expense.fromJson(json);
    });
  }

  Future<List<Expense>> getExpensesByMember(String memberId) async {
    final db = await database;
    final maps = await db.query(
      'expenses',
      where: 'paidBy = ?',
      whereArgs: [memberId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['splitAmong'] = (json['splitAmong'] as String).split(',');
      return Expense.fromJson(json);
    });
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      {
        ...expense.toJson(),
        'splitAmong': expense.splitAmong.join(','),
      },
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== MEAL OPERATIONS ====================
  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert('meals', {
      ...meal.toJson(),
      'attendees': meal.attendees.join(','),
    });
  }

  Future<List<Meal>> getAllMeals() async {
    final db = await database;
    final maps = await db.query('meals', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['attendees'] = (json['attendees'] as String).split(',');
      return Meal.fromJson(json);
    });
  }

  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final maps = await db.query(
      'meals',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['attendees'] = (json['attendees'] as String).split(',');
      return Meal.fromJson(json);
    });
  }

  Future<void> updateMeal(Meal meal) async {
    final db = await database;
    await db.update(
      'meals',
      {
        ...meal.toJson(),
        'attendees': meal.attendees.join(','),
      },
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== INVENTORY OPERATIONS ====================
  Future<void> insertInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.insert('inventory', item.toJson());
  }

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final db = await database;
    final maps = await db.query('inventory');
    return List.generate(maps.length, (i) => InventoryItem.fromJson(maps[i]));
  }

  Future<List<InventoryItem>> getLowStockItems() async {
    final db = await database;
    final maps = await db.query(
      'inventory',
      where: 'quantity <= minThreshold',
    );
    return List.generate(maps.length, (i) => InventoryItem.fromJson(maps[i]));
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.update('inventory', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<void> deleteInventoryItem(String id) async {
    final db = await database;
    await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== BILL OPERATIONS ====================
  Future<void> insertBill(Bill bill) async {
    final db = await database;
    await db.insert('bills', {
      ...bill.toJson(),
      'expenseIds': bill.expenseIds.join(','),
    });
  }

  Future<List<Bill>> getAllBills() async {
    final db = await database;
    final maps = await db.query('bills');
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['expenseIds'] = (json['expenseIds'] as String).split(',');
      return Bill.fromJson(json);
    });
  }

  Future<Bill?> getBillById(String id) async {
    final db = await database;
    final maps = await db.query('bills', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final json = maps.first;
      json['expenseIds'] = (json['expenseIds'] as String).split(',');
      return Bill.fromJson(json);
    }
    return null;
  }

  Future<List<Bill>> getBillsByMember(String memberId) async {
    final db = await database;
    final maps = await db.query('bills', where: 'memberId = ?', whereArgs: [memberId]);
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['expenseIds'] = (json['expenseIds'] as String).split(',');
      return Bill.fromJson(json);
    });
  }

  Future<void> updateBill(Bill bill) async {
    final db = await database;
    await db.update(
      'bills',
      {
        ...bill.toJson(),
        'expenseIds': bill.expenseIds.join(','),
      },
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }

  Future<void> deleteBill(String id) async {
    final db = await database;
    await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== SETTLEMENT OPERATIONS ====================
  Future<void> insertSettlement(Settlement settlement) async {
    final db = await database;
    await db.insert('settlements', settlement.toJson());
  }

  Future<List<Settlement>> getAllSettlements() async {
    final db = await database;
    final maps = await db.query('settlements', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Settlement.fromJson(maps[i]));
  }

  Future<List<Settlement>> getPendingSettlements() async {
    final db = await database;
    final maps = await db.query(
      'settlements',
      where: 'isSettled = ?',
      whereArgs: [0],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Settlement.fromJson(maps[i]));
  }

  Future<void> updateSettlement(Settlement settlement) async {
    final db = await database;
    await db.update('settlements', settlement.toJson(), where: 'id = ?', whereArgs: [settlement.id]);
  }

  Future<void> deleteSettlement(String id) async {
    final db = await database;
    await db.delete('settlements', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== UTILITY OPERATIONS ====================
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('members');
    await db.delete('expenses');
    await db.delete('meals');
    await db.delete('inventory');
    await db.delete('bills');
    await db.delete('settlements');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
