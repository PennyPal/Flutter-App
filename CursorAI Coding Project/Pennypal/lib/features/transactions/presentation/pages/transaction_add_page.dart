import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/transaction_service.dart';

/// Add/Edit transaction page with full functionality
class TransactionAddPage extends StatefulWidget {
  const TransactionAddPage({
    super.key,
    this.transactionId,
  });

  final String? transactionId;

  @override
  State<TransactionAddPage> createState() => _TransactionAddPageState();
}

class _TransactionAddPageState extends State<TransactionAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final TransactionService _transactionService = TransactionService();
  
  String _selectedType = 'expense';
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  IconData _selectedIcon = Icons.restaurant;
  
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': AppColors.warning},
    {'name': 'Transportation', 'icon': Icons.directions_car, 'color': AppColors.info},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': AppColors.secondary},
    {'name': 'Utilities', 'icon': Icons.electrical_services, 'color': AppColors.error},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': AppColors.primary},
    {'name': 'Healthcare', 'icon': Icons.health_and_safety, 'color': AppColors.success},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.purple},
    {'name': 'Travel', 'icon': Icons.flight, 'color': Colors.blue},
    {'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Gas', 'icon': Icons.local_gas_station, 'color': Colors.orange},
    {'name': 'Coffee', 'icon': Icons.local_cafe, 'color': Colors.brown},
    {'name': 'Salary', 'icon': Icons.work, 'color': AppColors.success},
    {'name': 'Investment', 'icon': Icons.trending_up, 'color': AppColors.primary},
    {'name': 'Other', 'icon': Icons.category, 'color': AppColors.onSurface},
  ];

  bool get _isEditing => widget.transactionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadTransactionData();
    }
  }

  void _loadTransactionData() {
    // TODO: Load transaction data from storage/database
    // For now, just populate with sample data
    _titleController.text = 'Sample Transaction';
    _amountController.text = '25.50';
    _selectedType = 'expense';
    _selectedCategory = 'Food';
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: _saveTransaction,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type Selector
              _buildTypeSelector(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Amount Input
              _buildAmountInput(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Title Input
              _buildTitleInput(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Category Selector
              _buildCategorySelector(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Date Selector
              _buildDateSelector(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Notes Input
              _buildNotesInput(),
              
              const SizedBox(height: AppTheme.xxl),
              
              // Save Button
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        Row(
          children: [
            Expanded(
              child: _TypeCard(
                title: 'Expense',
                icon: Icons.trending_down,
                color: AppColors.error,
                isSelected: _selectedType == 'expense',
                onTap: () => setState(() => _selectedType = 'expense'),
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: _TypeCard(
                title: 'Income',
                icon: Icons.trending_up,
                color: AppColors.success,
                isSelected: _selectedType == 'income',
                onTap: () => setState(() => _selectedType = 'income'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              color: _selectedType == 'income' ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
              focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: _selectedType == 'income' ? AppColors.success : AppColors.error,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTitleInput() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Enter transaction title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        SizedBox(
          height: 100,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: AppTheme.xs,
              mainAxisSpacing: AppTheme.xs,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                    _selectedIcon = category['icon'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary.withAlpha((0.1 * 255).round()) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category['icon'],
                        color: isSelected ? theme.colorScheme.primary : category['color'],
                        size: 18,
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          category['name'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              border: Border.all(
                color: theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.md),
                Text(
                  _formatDate(_selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: theme.colorScheme.onSurface,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesInput() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Add any additional notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          ),
        ),
        child: Text(
          _isEditing ? 'Update Transaction' : 'Add Transaction',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference == -1) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final selectedColor = _categories.firstWhere((cat) => cat['name'] == _selectedCategory)['color'];
      
      final transaction = {
        'id': _isEditing ? widget.transactionId : DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text,
        'amount': _selectedType == 'expense' ? -amount : amount,
        'category': _selectedCategory,
        'date': _selectedDate,
        'type': _selectedType,
        'icon': _selectedIcon,
        'color': selectedColor,
        'notes': _notesController.text,
      };
      
      if (_isEditing) {
        _transactionService.updateTransaction(widget.transactionId!, transaction);
      } else {
        _transactionService.addTransaction(transaction);
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Transaction updated successfully!' : 'Transaction added successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Go back to transactions page
      context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha((0.1 * 255).round()) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          border: Border.all(
            color: isSelected ? color : AppColors.onSurface.withAlpha((0.2 * 255).round()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.onSurface,
              size: 32,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : AppColors.onBackground,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}