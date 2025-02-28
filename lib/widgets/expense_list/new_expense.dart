// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  //will pass new property that will be a function
  final void Function(Expense expense) onAddExpense;
  //thisnaming pattern

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = Category.food;
  DateTime? _selectedDate; // This is the date picker

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text("Invalid Input"),
              content: Text("Please enter a valid title,amount and date"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
      );
      return; //show error massage
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  void disposer() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // var _enteredInput = '';

  // void _saveTitleInput(String titleInput) {
  //   _enteredInput = titleInput;
  // }

  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  // onChanged: _saveTitleInput,
                  maxLength: 50,
                  decoration: InputDecoration(label: Text("Your Expense"),),
                  // keyboardType:, can also use this one
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,

                  maxLength: 50,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: Text("Amount Used"),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items:
                    Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: _submitExpenseData,
                child: Text("Save Expense"),
              ),
            ],
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
