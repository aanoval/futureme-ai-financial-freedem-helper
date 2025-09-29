// Layar AI Goal Tracker dengan progress bar animasi.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../providers/goal_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../../data/models/goal.dart';

class GoalScreen extends StatelessWidget {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _targetDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) _targetDate = picked;
  }

  @override
  Widget build(BuildContext context) {
    final goals = context.watch<GoalProvider>().goals;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.aiGoal)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (ctx, i) {
                final goal = goals[i];
                return Card(
                  child: ListTile(
                    title: Text(goal.description),
                    subtitle: Text('Target: ${formatDate(goal.targetDate)} - ${formatCurrency(goal.targetAmount)}'),
                    trailing: CircularProgressIndicator(
                      value: calculateProgress(goal.currentProgress, goal.targetAmount),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomTextField(hint: 'Deskripsi Goal', controller: _descController),
                CustomTextField(hint: 'Target Jumlah', controller: _amountController),
                CustomButton(text: 'Pilih Tanggal', onPressed: () => _pickDate(context)),
                CustomButton(
                  text: AppStrings.setGoal,
                  onPressed: () {
                    if (_descController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                      final goal = Goal(
                        description: _descController.text,
                        targetDate: _targetDate,
                        targetAmount: double.parse(_amountController.text),
                      );
                      context.read<GoalProvider>().addGoal(context, goal);
                      _descController.clear();
                      _amountController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}