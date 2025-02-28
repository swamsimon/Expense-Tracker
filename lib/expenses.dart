import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/expense_list/expense_list.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/expense_list/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Groceries",
      amount: 100.0,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: "Uber",
      amount: 50.0,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _openAddExpenseOverlay() {
    //showModalBottomSheet needs a context and a builder function
    //context is the current context of the widget
    //builder is a function that returns a widget
    //ctx is the context of the modal

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    //add expense to the list
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text("Expense removed"),
        action: SnackBarAction(label: 'undo', onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        } ),)
    );
  }

  @override
  Widget build(context) {
    Widget mainContent = Center(
      child: Text('No expenses yet!Please add some.'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
           Expanded(
            child: mainContent,
            ),
          ],
        ),
    );
  }
}
