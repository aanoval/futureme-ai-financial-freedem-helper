// Layar untuk AI Financial Adviser.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/financial_entry.dart';
import '../../providers/financial_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class FinancialScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _type = 'pemasukan';
  File? _photo;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) _photo = File(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    final financials = context.watch<FinancialProvider>().entries;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.aiFinancial)),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              initialItemCount: financials.length,
              itemBuilder: (ctx, i, animation) {
                final entry = financials[i];
                return FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    title: Text('${entry.type}: ${formatCurrency(entry.amount)}'),
                    subtitle: Text(formatDate(entry.date)),
                    trailing: entry.photoUrl != null ? Icon(Icons.image) : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _type,
                  items: ['pemasukan', 'pengeluaran'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => _type = val!,
                ),
                CustomTextField(hint: 'Jumlah', controller: _amountController),
                CustomTextField(hint: 'Deskripsi', controller: _descController),
                CustomButton(text: AppStrings.takePhoto, onPressed: _pickImage),
                CustomButton(
                  text: AppStrings.save,
                  onPressed: () {
                    if (_amountController.text.isNotEmpty) {
                      final entry = FinancialEntry(
                        amount: double.parse(_amountController.text),
                        type: _type,
                        photoUrl: _photo?.path,
                        date: DateTime.now(),
                        description: _descController.text,
                      );
                      context.read<FinancialProvider>().addEntry(context, entry);
                      _amountController.clear();
                      _descController.clear();
                      _photo = null;
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