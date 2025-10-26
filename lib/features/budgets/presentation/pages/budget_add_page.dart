import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';

/// Add/Edit budget page with savings goals functionality
class BudgetAddPage extends StatefulWidget {
  const BudgetAddPage({
    super.key,
    this.budgetId,
  });

  final String? budgetId;

  @override
  State<BudgetAddPage> createState() => _BudgetAddPageState();
}

class _BudgetAddPageState extends State<BudgetAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedType = 'spending'; // spending or savings
  String _selectedCategory = 'Food';
  String _selectedPeriod = 'Monthly';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));
  IconData _selectedIcon = Icons.restaurant;
  Color _selectedColor = AppColors.warning;
  
  final List<Map<String, dynamic>> _spendingCategories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': AppColors.warning},
    {'name': 'Transportation', 'icon': Icons.directions_car, 'color': AppColors.info},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': AppColors.secondary},
    {'name': 'Utilities', 'icon': Icons.electrical_services, 'color': AppColors.error},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': AppColors.primary},
    {'name': 'Healthcare', 'icon': Icons.health_and_safety, 'color': AppColors.success},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.purple},
    {'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Other', 'icon': Icons.category, 'color': AppColors.onSurface},
  ];

  final List<Map<String, dynamic>> _savingsGoals = [
    {'name': 'Emergency Fund', 'icon': Icons.security, 'color': AppColors.error},
    {'name': 'Vacation', 'icon': Icons.flight, 'color': Colors.blue},
    {'name': 'New Car', 'icon': Icons.directions_car, 'color': AppColors.info},
    {'name': 'House Down Payment', 'icon': Icons.home, 'color': AppColors.success},
    {'name': 'Wedding', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.purple},
    {'name': 'Retirement', 'icon': Icons.elderly, 'color': Colors.brown},
    {'name': 'Investment', 'icon': Icons.trending_up, 'color': AppColors.primary},
    {'name': 'Gadgets', 'icon': Icons.phone_android, 'color': Colors.orange},
    {'name': 'Other Goal', 'icon': Icons.flag, 'color': AppColors.secondary},
  ];

  final List<String> _periods = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  bool get _isEditing => widget.budgetId != null;
  bool get _isSavingsGoal => _selectedType == 'savings';

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadBudgetData();
    }
  }

  void _loadBudgetData() {
    // TODO: Load budget data from storage/database
    _titleController.text = 'Sample Budget';
    _amountController.text = '500.00';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Budget' : (_isSavingsGoal ? 'Create Savings Goal' : 'Create Budget')),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: _saveBudget,
            child: Text(
              _isEditing ? 'Update' : 'Save',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
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
              // Budget Type Selector
              _buildTypeSelector(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Title Input
              _buildTitleInput(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Category/Goal Selector
              _buildCategorySelector(),
              
              const SizedBox(height: AppTheme.xl),
              
              // Amount Input
              _buildAmountInput(),
              
              if (_isSavingsGoal) ...[
                const SizedBox(height: AppTheme.xl),
                _buildTargetAmountInput(),
                
                const SizedBox(height: AppTheme.xl),
                _buildTargetDateSelector(),
              ] else ...[
                const SizedBox(height: AppTheme.xl),
                _buildPeriodSelector(),
              ],
              
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
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        Row(
          children: [
            Expanded(
                child: _TypeCard(
                  title: 'Spending Budget',
                  icon: Icons.account_balance_wallet,
                  color: AppColors.warning,
                  isSelected: _selectedType == 'spending',
                  onTap: () => setState(() => _selectedType = 'spending'),
                ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
                child: _TypeCard(
                  title: 'Savings Goal',
                  icon: Icons.savings,
                  color: AppColors.success,
                  isSelected: _selectedType == 'savings',
                  onTap: () => setState(() => _selectedType = 'savings'),
                ),
            ),
          ],
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
          _isSavingsGoal ? 'Goal Name' : 'Budget Name',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        TextFormField(
          controller: _titleController,
                    decoration: InputDecoration(
            hintText: _isSavingsGoal ? 'e.g., "Vacation to Japan"' : 'e.g., "Monthly Food Budget"',
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
              return 'Please enter a name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final theme = Theme.of(context);
    final categories = _isSavingsGoal ? _savingsGoals : _spendingCategories;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isSavingsGoal ? 'Savings Goal' : 'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        SizedBox(
          height: 120,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppTheme.sm,
              mainAxisSpacing: AppTheme.sm,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory == category['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                    _selectedIcon = category['icon'];
                    _selectedColor = category['color'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary.withAlpha((0.1 * 255).round()) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: isSelected ? theme.colorScheme.primary : category['color'],
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onBackground,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildAmountInput() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isSavingsGoal ? 'Monthly Savings Amount' : 'Budget Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
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
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
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

  Widget _buildTargetAmountInput() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        TextFormField(
          controller: _targetAmountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
            decoration: InputDecoration(
              prefixText: '\$ ',
              prefixStyle: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize: 20,
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a target amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            final monthlyAmount = double.tryParse(_amountController.text) ?? 0;
            if (amount <= monthlyAmount) {
              return 'Target should be greater than monthly amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Period',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        DropdownButtonFormField<String>(
          value: _selectedPeriod,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
          items: _periods.map((period) => DropdownMenuItem(
            value: period,
            child: Text(period),
          )).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPeriod = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTargetDateSelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Date',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: AppTheme.md),
        GestureDetector(
          onTap: _selectTargetDate,
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
                  _formatTargetDate(_targetDate),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground,
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
            color: theme.colorScheme.onBackground,
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
        onPressed: _saveBudget,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          ),
        ),
        child: Text(
          _isEditing 
              ? (_isSavingsGoal ? 'Update Goal' : 'Update Budget')
              : (_isSavingsGoal ? 'Create Goal' : 'Create Budget'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _selectTargetDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    
    if (date != null) {
      setState(() {
        _targetDate = date;
      });
    }
  }

  String _formatTargetDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save budget/goal to storage/database
      final budget = {
        'id': _isEditing ? widget.budgetId : DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text,
        'category': _selectedCategory,
        'amount': double.parse(_amountController.text),
        'type': _selectedType,
        'period': _isSavingsGoal ? null : _selectedPeriod,
        'targetAmount': _isSavingsGoal ? double.parse(_targetAmountController.text) : null,
        'targetDate': _isSavingsGoal ? _targetDate : null,
        'icon': _selectedIcon,
        'color': _selectedColor,
        'notes': _notesController.text,
      };
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing 
                ? (_isSavingsGoal ? 'Goal updated successfully!' : 'Budget updated successfully!')
                : (_isSavingsGoal ? 'Goal created successfully!' : 'Budget created successfully!'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Go back to budgets page
      context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _targetAmountController.dispose();
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
  final theme = Theme.of(context);
  return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha((0.1 * 255).round()) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd.x),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.onSurface.withAlpha((0.2 * 255).round()),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : theme.colorScheme.onSurface,
              size: 32,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : theme.colorScheme.onBackground,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
