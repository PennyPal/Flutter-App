import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/transaction_service.dart';

/// Transactions list page with full functionality
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final TransactionService _transactionService = TransactionService();

  List<Map<String, dynamic>> get _filteredTransactions {
    var filtered = _transactionService.transactions.where((transaction) {
      final matchesSearch = transaction['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          transaction['category'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Income' && transaction['type'] == 'income') ||
          (_selectedFilter == 'Expense' && transaction['type'] == 'expense');
      
      return matchesSearch && matchesFilter;
    }).toList();

    // Sort by date (newest first)
    filtered.sort((a, b) => b['date'].compareTo(a['date']));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSearchDialog(),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(Icons.filter_list),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _showClearAllDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear All Transactions'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),
          
          // Filter Chips
          _buildFilterChips(),
          
          // Transactions List
          Expanded(
            child: _transactionService.transactions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.lg),
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return _TransactionCard(
                        transaction: transaction,
                        onTap: () => _showTransactionDetails(transaction),
                        onDelete: () => _deleteTransaction(transaction['id']),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(RouteNames.transactionAdd),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalIncome = _transactionService.totalIncome;
    final totalExpense = _transactionService.totalExpenses;
    final netAmount = _transactionService.netAmount;

    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Total Income',
              amount: totalIncome,
              color: AppColors.success,
              icon: Icons.trending_up,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: _SummaryCard(
              title: 'Total Expense',
              amount: totalExpense,
              color: AppColors.warning,
              icon: Icons.trending_down,
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: _SummaryCard(
              title: 'Net Amount',
              amount: netAmount,
              color: netAmount >= 0 ? AppColors.success : AppColors.error,
              icon: netAmount >= 0 ? Icons.account_balance_wallet : Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Income', 'Expense'];
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: AppTheme.sm),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.onBackground,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.lg),
          Text(
            'No transactions found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'All'
                ? 'Try adjusting your search or filter'
                : 'Add your first transaction to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.xl),
          ElevatedButton.icon(
            onPressed: () => context.go(RouteNames.transactionAdd),
            icon: const Icon(Icons.add),
            label: const Text('Add Transaction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.xl,
                vertical: AppTheme.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Transactions'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title or category...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Transactions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: AppTheme.lg),
            ...['All', 'Income', 'Expense'].map((filter) => ListTile(
              title: Text(filter),
              leading: Radio<String>(
                value: filter,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  Navigator.pop(context);
                },
                activeColor: AppColors.primary,
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.sm),
                    decoration: BoxDecoration(
                      color: transaction['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                    ),
                    child: Icon(
                      transaction['icon'],
                      color: transaction['color'],
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppTheme.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['title'],
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                        Text(
                          transaction['category'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.xl),
              _DetailRow(
                label: 'Amount',
                value: '\$${(transaction['amount'] as double).abs().toStringAsFixed(2)}',
                valueColor: transaction['type'] == 'income' ? AppColors.success : AppColors.error,
              ),
              _DetailRow(
                label: 'Type',
                value: transaction['type'] == 'income' ? 'Income' : 'Expense',
              ),
              _DetailRow(
                label: 'Date',
                value: _formatFullDate(transaction['date']),
              ),
              if (transaction['notes'] != null && transaction['notes'].isNotEmpty)
                _DetailRow(
                  label: 'Notes',
                  value: transaction['notes'],
                ),
              const SizedBox(height: AppTheme.xl),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('${RouteNames.transactionAdd}?id=${transaction['id']}');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteTransaction(transaction['id']);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTransaction(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _transactionService.deleteTransaction(id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Transactions'),
        content: const Text('Are you sure you want to delete all transactions? This will reset your transaction history to a blank state. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Clear all transactions
                _transactionService.clearAllTransactions();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All transactions have been cleared'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Clear All'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppTheme.sm),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.sm),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.md),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppColors.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction['type'] == 'income';
    final amount = transaction['amount'] as double;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.md),
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.sm),
              decoration: BoxDecoration(
                color: transaction['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
              ),
              child: Icon(
                transaction['icon'],
                color: transaction['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['title'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: AppTheme.xs),
                  Row(
                    children: [
                      Text(
                        transaction['category'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                      const SizedBox(width: AppTheme.sm),
                      Text(
                        '•',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                      const SizedBox(width: AppTheme.sm),
                      Text(
                        _formatDate(transaction['date']),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: AppTheme.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isIncome 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm.x),
                  ),
                  child: Text(
                    isIncome ? 'Income' : 'Expense',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isIncome ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}