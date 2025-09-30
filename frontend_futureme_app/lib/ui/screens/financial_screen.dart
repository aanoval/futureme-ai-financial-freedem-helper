// Layar untuk AI Financial Adviser.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/financial_entry.dart';
import '../../providers/financial_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  _FinancialScreenState createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _type = 'pemasukan';
  File? _photo;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          _photo = File(picked.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e', style: AppTextStyles.body.copyWith(color: Colors.white)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final financials = context.watch<FinancialProvider>().entries;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.aiFinancial, style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Expanded(
                child: financials.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada catatan keuangan, tambahkan sekarang!',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: financials.length,
                        itemBuilder: (ctx, i) {
                          final entry = financials[i];
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  '${entry.type}: ${formatCurrency(entry.amount)}',
                                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                                ),
                                subtitle: Text(
                                  '${formatDate(entry.date)}${entry.description!.isNotEmpty ? ' - ${entry.description}' : ''}',
                                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                ),
                                trailing: entry.photoUrl != null ? const Icon(Icons.image, color: AppColors.primary) : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: _type,
                      items: ['pemasukan', 'pengeluaran']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTextStyles.body)))
                          .toList(),
                      onChanged: (val) => setState(() => _type = val!),
                      style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                      dropdownColor: AppColors.cardBackground,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      hint: 'Jumlah (Rp)',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                      validator: (val) {
                        if (val!.isEmpty) return 'Jumlah wajib diisi';
                        try {
                          double.parse(val);
                          return null;
                        } catch (e) {
                          return 'Masukkan jumlah yang valid';
                        }
                      },
                    ),
                    CustomTextField(
                      hint: 'Deskripsi (Opsional)',
                      controller: _descController,
                      prefixIcon: Icons.description_outlined,
                    ),
                    CustomButton(
                      text: AppStrings.takePhoto,
                      onPressed: _pickImage,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: AppStrings.save,
                      onPressed: () async {
                        if (_amountController.text.isNotEmpty) {
                          try {
                            final amount = double.tryParse(_amountController.text);
                            if (amount == null || amount < 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Masukkan jumlah yang valid', style: AppTextStyles.body.copyWith(color: Colors.white)),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                              return;
                            }
                            final entry = FinancialEntry(
                              amount: amount,
                              type: _type,
                              photoUrl: _photo?.path,
                              date: DateTime.now(),
                              description: _descController.text,
                            );
                            await context.read<FinancialProvider>().addEntry(context, entry);
                            _amountController.clear();
                            _descController.clear();
                            setState(() => _photo = null);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Catatan keuangan berhasil disimpan!', style: AppTextStyles.body.copyWith(color: Colors.white)),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menyimpan catatan: $e', style: AppTextStyles.body.copyWith(color: Colors.white)),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}