import 'package:flutter/material.dart';

/// Simple transaction service for data management
class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  // In-memory storage (would be replaced with actual database/storage)
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'title': 'Grocery Shopping',
      'amount': -85.50,
      'category': 'Food',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'expense',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
      'notes': 'Weekly grocery shopping at Whole Foods',
    },
    {
      'id': '2',
      'title': 'Salary Deposit',
      'amount': 2500.00,
      'category': 'Income',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'income',
      'icon': Icons.work,
      'color': Colors.green,
      'notes': 'Monthly salary deposit',
    },
    {
      'id': '3',
      'title': 'Coffee Shop',
      'amount': -12.00,
      'category': 'Food',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'expense',
      'icon': Icons.local_cafe,
      'color': Colors.brown,
      'notes': 'Morning coffee at Starbucks',
    },
    {
      'id': '4',
      'title': 'Gas Station',
      'amount': -45.00,
      'category': 'Transportation',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'type': 'expense',
      'icon': Icons.local_gas_station,
      'color': Colors.blue,
      'notes': 'Fill up gas tank',
    },
    {
      'id': '5',
      'title': 'Freelance Work',
      'amount': 300.00,
      'category': 'Income',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'type': 'income',
      'icon': Icons.computer,
      'color': Colors.green,
      'notes': 'Web development project payment',
    },
    {
      'id': '6',
      'title': 'Netflix Subscription',
      'amount': -15.99,
      'category': 'Entertainment',
      'date': DateTime.now().subtract(const Duration(days: 6)),
      'type': 'expense',
      'icon': Icons.movie,
      'color': Colors.red,
      'notes': 'Monthly Netflix subscription',
    },
    {
      'id': '7',
      'title': 'Electric Bill',
      'amount': -120.00,
      'category': 'Utilities',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'type': 'expense',
      'icon': Icons.electrical_services,
      'color': Colors.yellow,
      'notes': 'Monthly electricity bill',
    },
    {
      'id': '8',
      'title': 'Investment Return',
      'amount': 150.00,
      'category': 'Investment',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'type': 'income',
      'icon': Icons.trending_up,
      'color': Colors.green,
      'notes': 'Dividend payment from stock portfolio',
    },
  ];

  List<Map<String, dynamic>> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Map<String, dynamic> transaction) {
    _transactions.insert(0, transaction); // Add to beginning for newest first
  }

  void updateTransaction(String id, Map<String, dynamic> updatedTransaction) {
    final index = _transactions.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t['id'] == id);
  }

  void clearAllTransactions() {
    _transactions.clear();
  }

  Map<String, dynamic>? getTransaction(String id) {
    try {
      return _transactions.firstWhere((t) => t['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Analytics methods
  double get totalIncome {
    return _transactions
        .where((t) => t['type'] == 'income')
        .fold(0.0, (sum, t) => sum + (t['amount'] as double));
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t['type'] == 'expense')
        .fold(0.0, (sum, t) => sum + (t['amount'] as double).abs());
  }

  double get netAmount => totalIncome - totalExpenses;

  Map<String, double> get expensesByCategory {
    final Map<String, double> result = {};
    for (final transaction in _transactions.where((t) => t['type'] == 'expense')) {
      final category = transaction['category'] as String;
      final amount = (transaction['amount'] as double).abs();
      result[category] = (result[category] ?? 0) + amount;
    }
    return result;
  }

  Map<String, double> get incomeByCategory {
    final Map<String, double> result = {};
    for (final transaction in _transactions.where((t) => t['type'] == 'income')) {
      final category = transaction['category'] as String;
      final amount = transaction['amount'] as double;
      result[category] = (result[category] ?? 0) + amount;
    }
    return result;
  }

  List<Map<String, dynamic>> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      final date = t['date'] as DateTime;
      return date.isAfter(start.subtract(const Duration(days: 1))) && 
             date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  List<Map<String, dynamic>> getRecentTransactions([int limit = 5]) {
    final sorted = List<Map<String, dynamic>>.from(_transactions);
    sorted.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return sorted.take(limit).toList();
  }

  // Monthly analytics
  Map<String, double> getMonthlyTotals(int year, int month) {
    final monthTransactions = _transactions.where((t) {
      final date = t['date'] as DateTime;
      return date.year == year && date.month == month;
    });

    double income = 0;
    double expenses = 0;

    for (final transaction in monthTransactions) {
      if (transaction['type'] == 'income') {
        income += transaction['amount'] as double;
      } else {
        expenses += (transaction['amount'] as double).abs();
      }
    }

    return {
      'income': income,
      'expenses': expenses,
      'net': income - expenses,
    };
  }

  // Get top spending categories
  List<MapEntry<String, double>> getTopSpendingCategories([int limit = 5]) {
    final categories = expensesByCategory;
    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }
}
