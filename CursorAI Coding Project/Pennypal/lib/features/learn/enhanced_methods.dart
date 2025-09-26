import 'package:flutter/material.dart';
import 'dart:math';
import '../../../core/theme/color_scheme.dart';

class LearnPageMethods {
  // Interactive Tool Methods
  static void openTool(BuildContext context, String toolName) {
    switch (toolName) {
      case 'Compound Interest Calculator':
        _showCompoundInterestCalculator(context);
        break;
      case 'Loan Payment Calculator':
        _showLoanCalculator(context);
        break;
      case 'Retirement Planner':
        _showRetirementPlanner(context);
        break;
      case 'Tax Estimator':
        _showTaxEstimator(context);
        break;
      default:
        _showComingSoonDialog(context, toolName);
    }
  }

  static void _showCompoundInterestCalculator(BuildContext context) {
    final principalController = TextEditingController();
    final rateController = TextEditingController();
    final timeController = TextEditingController();
    String result = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.success),
              SizedBox(width: 8),
              Text('Compound Interest Calculator'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: principalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Principal Amount (\$)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Annual Interest Rate (%)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Time Period (years)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final principal = double.tryParse(principalController.text) ?? 0;
                    final rate = (double.tryParse(rateController.text) ?? 0) / 100;
                    final time = double.tryParse(timeController.text) ?? 0;
                    
                    if (principal > 0 && rate > 0 && time > 0) {
                      final amount = principal * pow(1 + rate, time);
                      final interest = amount - principal;
                      setState(() {
                        result = 'Final Amount: \$${amount.toStringAsFixed(2)}\nInterest Earned: \$${interest.toStringAsFixed(2)}';
                      });
                    }
                  },
                  child: const Text('Calculate'),
                ),
                if (result.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      result,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  static void _showComingSoonDialog(BuildContext context, String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(toolName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            const Text(
              'This tool is coming soon!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'re working hard to bring you more financial tools.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  static void _showLoanCalculator(BuildContext context) {
    _showComingSoonDialog(context, 'Loan Payment Calculator');
  }

  static void _showRetirementPlanner(BuildContext context) {
    _showComingSoonDialog(context, 'Retirement Planner');
  }

  static void _showTaxEstimator(BuildContext context) {
    _showComingSoonDialog(context, 'Tax Estimator');
  }

  // Course Management
  static void startDetailedCourse(BuildContext context, Map<String, dynamic> course) {
    final lessons = getCourseContent(course['title'] as String);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${course['title']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (course['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      course['icon'] as IconData,
                      size: 48,
                      color: course['color'] as Color,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${course['lessons']} Lessons • ${course['duration']}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('${course['rating']} ⭐ Rating'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Course Curriculum:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: (course['color'] as Color),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        lessons[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                      dense: true,
                      onTap: () {
                        Navigator.pop(context);
                        showLessonDetail(context, course, lessons[index], index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showLessonDetail(context, course, lessons[0], 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: course['color'] as Color,
            ),
            child: const Text('Start Course'),
          ),
        ],
      ),
    );
  }

  static List<String> getCourseContent(String courseTitle) {
    switch (courseTitle) {
      case 'Personal Budgeting Mastery':
        return [
          'Introduction to Budgeting',
          'Understanding Your Income',
          'Tracking Your Expenses', 
          'The 50/30/20 Rule',
          'Creating Your First Budget',
          'Budget Apps and Tools',
          'Handling Budget Variations',
          'Building Better Money Habits'
        ];
      case 'Investment Fundamentals':
        return [
          'What is Investing?',
          'Risk vs Return',
          'Types of Investments',
          'Stock Market Basics',
          'Bonds and Fixed Income',
          'Mutual Funds & ETFs',
          'Portfolio Diversification',
          'Investment Psychology',
          'Tax-Advantaged Accounts',
          'Dollar-Cost Averaging',
          'Rebalancing Your Portfolio',
          'Long-term Investment Strategy'
        ];
      case 'Debt Management Strategies':
        return [
          'Understanding Different Types of Debt',
          'Calculating Your Debt-to-Income Ratio',
          'Debt Avalanche vs Snowball Methods',
          'Negotiating with Creditors',
          'Credit Score Improvement',
          'Debt Consolidation Options'
        ];
      case 'Retirement Planning':
        return [
          'Retirement Planning Basics',
          '401(k) and Employer Matching',
          'Traditional vs Roth IRAs',
          'Social Security Benefits',
          'Healthcare in Retirement',
          'Estate Planning Basics',
          'Withdrawal Strategies',
          'Creating Multiple Income Streams',
          'Medicare and Health Insurance',
          'Legacy Planning'
        ];
      case 'Tax Optimization':
        return [
          'Understanding Tax Brackets',
          'Standard vs Itemized Deductions',
          'Tax-Advantaged Investment Accounts',
          'Tax-Loss Harvesting',
          'Business Expense Deductions',
          'Charitable Giving Strategies',
          'Year-End Tax Planning'
        ];
      default:
        return ['Introduction', 'Fundamentals', 'Advanced Concepts', 'Practical Application'];
    }
  }

  static void showLessonDetail(BuildContext context, Map<String, dynamic> course, String lessonTitle, int lessonIndex) {
    final content = _getLessonContent(lessonTitle);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lesson ${lessonIndex + 1}: $lessonTitle'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (course['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: course['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                      const Text('Estimated time: 15 minutes'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Key Takeaways:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._getKeyTakeaways(lessonTitle).map((takeaway) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(takeaway)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Course'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lesson completed! Progress updated.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: course['color'] as Color,
            ),
            child: const Text('Mark Complete'),
          ),
        ],
      ),
    );
  }

  static String _getLessonContent(String lessonTitle) {
    switch (lessonTitle) {
      case 'Introduction to Budgeting':
        return '''A budget is a plan for your money. It helps you track your income and expenses, ensuring you live within your means and save for your goals.

Think of budgeting as creating a roadmap for your financial journey. Just like you wouldn't drive to a new city without directions, you shouldn't navigate your financial life without a budget.

The main benefits of budgeting include:
- Better control over your spending
- Reduced financial stress
- Ability to save for goals
- Preparation for emergencies
- Path to debt freedom

Budgeting isn't about restricting yourself - it's about making conscious choices with your money so you can spend on what matters most to you.''';
      
      case 'Understanding Your Income':
        return '''Your income is the foundation of your budget. This includes all money coming in: salary, side hustles, investment returns, and any other sources.

For budgeting purposes, always use your take-home pay (after taxes and deductions), not your gross income. This gives you a realistic picture of what you actually have to work with.

If your income varies (freelance, commission-based, etc.), use your lowest monthly income from the past year as your baseline. This ensures your budget works even in lean months.

Don't forget to include:
- Overtime pay (if regular)
- Side business income
- Investment dividends
- Rental income
- Any government benefits

Understanding your true income is crucial for creating a realistic and sustainable budget.''';

      case 'The 50/30/20 Rule':
        return '''The 50/30/20 rule is a simple budgeting framework that divides your after-tax income into three categories:

50% for NEEDS - Essential expenses you can't avoid:
- Housing (rent/mortgage, utilities)
- Transportation (car payment, gas, insurance)
- Groceries and basic clothing
- Minimum debt payments
- Insurance premiums

30% for WANTS - Things you enjoy but could live without:
- Dining out and entertainment
- Hobbies and subscriptions
- Travel and vacations
- Shopping for non-essentials
- Gym memberships

20% for SAVINGS & DEBT REPAYMENT:
- Emergency fund
- Retirement contributions
- Extra debt payments
- Other savings goals

This rule provides a balanced approach that ensures you cover necessities, enjoy life, and build wealth. Adjust percentages based on your situation - high earners might save more than 20%, while those with high debt might temporarily allocate more to debt repayment.''';

      default:
        return '''This lesson covers important financial concepts that will help you make better money decisions.

We'll explore practical strategies and real-world examples to help you understand and apply these concepts in your daily life.

Remember, financial literacy is a journey, not a destination. Each lesson builds upon the previous one, creating a comprehensive understanding of personal finance.

Take your time to absorb the information and don't hesitate to revisit lessons as needed. The key is consistent learning and application.''';
    }
  }

  static List<String> _getKeyTakeaways(String lessonTitle) {
    switch (lessonTitle) {
      case 'Introduction to Budgeting':
        return [
          'A budget is a plan for your money, not a restriction',
          'Budgeting reduces financial stress and increases control',
          'Track both income and expenses for a complete picture',
          'Focus on conscious spending aligned with your values'
        ];
      case 'Understanding Your Income':
        return [
          'Use take-home pay, not gross income, for budgeting',
          'Include all income sources for accuracy',
          'Use lowest monthly income if income varies',
          'Regularly review and update income changes'
        ];
      case 'The 50/30/20 Rule':
        return [
          '50% needs, 30% wants, 20% savings/debt repayment',
          'Adjust percentages based on your situation',
          'Prioritize essential expenses first',
          'Balance enjoying life with building wealth'
        ];
      default:
        return [
          'Consistent learning leads to better financial decisions',
          'Apply concepts gradually in real-life situations',
          'Review and practice regularly',
          'Build on previous knowledge'
        ];
    }
  }
}
