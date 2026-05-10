import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';

// Member Model
@JsonSerializable()
class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime joinDate;
  final bool isActive;

  Member({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    DateTime? joinDate,
    this.isActive = true,
  }) : id = id ?? const Uuid().v4(),
       joinDate = joinDate ?? DateTime.now();

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? joinDate,
    bool? isActive,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Expense Model
@JsonSerializable()
class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final String paidBy;
  final List<String> splitAmong;
  final DateTime date;
  final String receipt;

  Expense({
    String? id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.paidBy,
    required this.splitAmong,
    DateTime? date,
    this.receipt = '',
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? category,
    String? paidBy,
    List<String>? splitAmong,
    DateTime? date,
    String? receipt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paidBy: paidBy ?? this.paidBy,
      splitAmong: splitAmong ?? this.splitAmong,
      date: date ?? this.date,
      receipt: receipt ?? this.receipt,
    );
  }
}

// Meal Model
@JsonSerializable()
class Meal {
  final String id;
  final String name;
  final String mealType;
  final DateTime date;
  final List<String> attendees;
  final double costPerPerson;
  final String notes;

  Meal({
    String? id,
    required this.name,
    required this.mealType,
    DateTime? date,
    required this.attendees,
    required this.costPerPerson,
    this.notes = '',
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);

  Meal copyWith({
    String? id,
    String? name,
    String? mealType,
    DateTime? date,
    List<String>? attendees,
    double? costPerPerson,
    String? notes,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      date: date ?? this.date,
      attendees: attendees ?? this.attendees,
      costPerPerson: costPerPerson ?? this.costPerPerson,
      notes: notes ?? this.notes,
    );
  }
}

// Inventory Item Model
@JsonSerializable()
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final double unitPrice;
  final DateTime lastUpdated;
  final int minThreshold;

  InventoryItem({
    String? id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    DateTime? lastUpdated,
    required this.minThreshold,
  }) : id = id ?? const Uuid().v4(),
       lastUpdated = lastUpdated ?? DateTime.now();

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? unit,
    double? unitPrice,
    DateTime? lastUpdated,
    int? minThreshold,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      minThreshold: minThreshold ?? this.minThreshold,
    );
  }

  bool get isLowStock => quantity <= minThreshold;
}

// Bill Model
@JsonSerializable()
class Bill {
  final String id;
  final String memberId;
  final double totalAmount;
  final double paid;
  final double pending;
  final DateTime dueDate;
  final String status;
  final List<String> expenseIds;

  Bill({
    String? id,
    required this.memberId,
    required this.totalAmount,
    required this.paid,
    DateTime? dueDate,
    this.status = 'pending',
    required this.expenseIds,
  }) : id = id ?? const Uuid().v4(),
       pending = totalAmount - paid,
       dueDate = dueDate ?? DateTime.now().add(const Duration(days: 30));

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);

  Bill copyWith({
    String? id,
    String? memberId,
    double? totalAmount,
    double? paid,
    DateTime? dueDate,
    String? status,
    List<String>? expenseIds,
  }) {
    return Bill(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      totalAmount: totalAmount ?? this.totalAmount,
      paid: paid ?? this.paid,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      expenseIds: expenseIds ?? this.expenseIds,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != 'paid';
}

// Settlement Model
@JsonSerializable()
class Settlement {
  final String id;
  final String fromMemberId;
  final String toMemberId;
  final double amount;
  final DateTime date;
  final String description;
  final bool isSettled;

  Settlement({
    String? id,
    required this.fromMemberId,
    required this.toMemberId,
    required this.amount,
    DateTime? date,
    this.description = '',
    this.isSettled = false,
  }) : id = id ?? const Uuid().v4(),
       date = date ?? DateTime.now();

  factory Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);
  Map<String, dynamic> toJson() => _$SettlementToJson(this);

  Settlement copyWith({
    String? id,
    String? fromMemberId,
    String? toMemberId,
    double? amount,
    DateTime? date,
    String? description,
    bool? isSettled,
  }) {
    return Settlement(
      id: id ?? this.id,
      fromMemberId: fromMemberId ?? this.fromMemberId,
      toMemberId: toMemberId ?? this.toMemberId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}
