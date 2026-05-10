import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/models.dart';

class MessProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Member> _members = [];
  List<Expense> _expenses = [];
  List<Meal> _meals = [];
  List<InventoryItem> _inventoryItems = [];
  List<Bill> _bills = [];
  List<Settlement> _settlements = [];

  // Getters
  List<Member> get members => _members;
  List<Expense> get expenses => _expenses;
  List<Meal> get meals => _meals;
  List<InventoryItem> get inventoryItems => _inventoryItems;
  List<Bill> get bills => _bills;
  List<Settlement> get settlements => _settlements;

  // Load all data
  Future<void> loadAllData() async {
    _members = await _db.getAllMembers();
    _expenses = await _db.getAllExpenses();
    _meals = await _db.getAllMeals();
    _inventoryItems = await _db.getAllInventoryItems();
    _bills = await _db.getAllBills();
    _settlements = await _db.getAllSettlements();
    notifyListeners();
  }

  // ==================== MEMBER OPERATIONS ====================
  Future<void> addMember(Member member) async {
    await _db.insertMember(member);
    _members.add(member);
    notifyListeners();
  }

  Future<void> updateMember(Member member) async {
    await _db.updateMember(member);
    final index = _members.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _members[index] = member;
      notifyListeners();
    }
  }

  Future<void> deleteMember(String id) async {
    await _db.deleteMember(id);
    _members.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ==================== EXPENSE OPERATIONS ====================
  Future<void> addExpense(Expense expense) async {
    await _db.insertExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    await _db.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ==================== MEAL OPERATIONS ====================
  Future<void> addMeal(Meal meal) async {
    await _db.insertMeal(meal);
    _meals.add(meal);
    notifyListeners();
  }

  Future<void> updateMeal(Meal meal) async {
    await _db.updateMeal(meal);
    final index = _meals.indexWhere((m) => m.id == meal.id);
    if (index != -1) {
      _meals[index] = meal;
      notifyListeners();
    }
  }

  Future<void> deleteMeal(String id) async {
    await _db.deleteMeal(id);
    _meals.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // ==================== INVENTORY OPERATIONS ====================
  Future<void> addInventoryItem(InventoryItem item) async {
    await _db.insertInventoryItem(item);
    _inventoryItems.add(item);
    notifyListeners();
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    await _db.updateInventoryItem(item);
    final index = _inventoryItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _inventoryItems[index] = item;
      notifyListeners();
    }
  }

  Future<void> deleteInventoryItem(String id) async {
    await _db.deleteInventoryItem(id);
    _inventoryItems.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // ==================== BILL OPERATIONS ====================
  Future<void> addBill(Bill bill) async {
    await _db.insertBill(bill);
    _bills.add(bill);
    notifyListeners();
  }

  Future<void> updateBill(Bill bill) async {
    await _db.updateBill(bill);
    final index = _bills.indexWhere((b) => b.id == bill.id);
    if (index != -1) {
      _bills[index] = bill;
      notifyListeners();
    }
  }

  Future<void> deleteBill(String id) async {
    await _db.deleteBill(id);
    _bills.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // ==================== SETTLEMENT OPERATIONS ====================
  Future<void> addSettlement(Settlement settlement) async {
    await _db.insertSettlement(settlement);
    _settlements.add(settlement);
    notifyListeners();
  }

  Future<void> updateSettlement(Settlement settlement) async {
    await _db.updateSettlement(settlement);
    final index = _settlements.indexWhere((s) => s.id == settlement.id);
    if (index != -1) {
      _settlements[index] = settlement;
      notifyListeners();
    }
  }

  Future<void> deleteSettlement(String id) async {
    await _db.deleteSettlement(id);
    _settlements.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ==================== ANALYTICS ====================
  double getTotalExpenses() {
    return _expenses.fold(0, (sum, e) => sum + e.amount);
  }

  double getTotalBillAmount() {
    return _bills.fold(0, (sum, b) => sum + b.totalAmount);
  }

  double getTotalPendingBills() {
    return _bills.fold(0, (sum, b) => sum + b.pending);
  }

  double getInventoryValue() {
    return _inventoryItems.fold(
      0,
      (sum, item) => sum + (item.quantity * item.unitPrice),
    );
  }

  Map<String, double> getExpensesByCategory() {
    final result = <String, double>{};
    for (var expense in _expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  List<InventoryItem> getLowStockItems() {
    return _inventoryItems.where((item) => item.isLowStock).toList();
  }

  List<Bill> getOverdueBills() {
    return _bills.where((bill) => bill.isOverdue).toList();
  }

  double getMemberBalance(String memberId) {
    double spent = 0;
    double owes = 0;

    for (var expense in _expenses) {
      if (expense.paidBy == memberId) {
        spent += expense.amount;
      }
      if (expense.splitAmong.contains(memberId)) {
        owes += expense.amount / expense.splitAmong.length;
      }
    }

    return spent - owes;
  }

  // Settlement suggestions
  Map<String, dynamic> calculateSettlements() {
    final balances = <String, double>{};

    for (var member in _members) {
      balances[member.id] = getMemberBalance(member.id);
    }

    return balances;
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _db.clearAllData();
    _members.clear();
    _expenses.clear();
    _meals.clear();
    _inventoryItems.clear();
    _bills.clear();
    _settlements.clear();
    notifyListeners();
  }
}
