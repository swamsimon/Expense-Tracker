import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/expense_list/expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,

      itemBuilder:
          (cxt, index) => Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin?.horizontal ?? 0,
              ),
            ),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expenses[index]),
          ),
    );
  }
}
