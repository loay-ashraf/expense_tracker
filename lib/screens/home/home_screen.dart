import 'package:flutter/material.dart';
import 'expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required List<Expense> expenses,
    required void Function({required Expense expense}) onRemoveExpense,
    required void Function(
            {required Expense expense, required int expenseIndex})
        onReaddExpense,
  })  : _expenses = expenses,
        _onRemoveExpense = onRemoveExpense,
        _onReaddExpense = onReaddExpense;

  final List<Expense> _expenses;
  final void Function({required Expense expense}) _onRemoveExpense;
  final void Function({required Expense expense, required int expenseIndex})
      _onReaddExpense;

  void _displayRemovedExpenseSnackBar(BuildContext context,
      {required Expense expense, required int expenseIndex}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _onReaddExpense(expense: expense, expenseIndex: expenseIndex);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _expenses,
        onRemoveExpense: ({required Expense expense}) {
          int removedExpenseIndex = _expenses.indexOf(expense);
          _onRemoveExpense(expense: expense);
          _displayRemovedExpenseSnackBar(context,
              expense: expense, expenseIndex: removedExpenseIndex);
        },
      );
    }

    return Column(
      children: [
        const Text('The chart'),
        Expanded(
          child: mainContent,
        ),
      ],
    );
  }
}
