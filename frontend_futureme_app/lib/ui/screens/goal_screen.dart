// Layar AI Goal Tracker dengan progress bar animasi.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/goal.dart';
import '../../providers/goal_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _targetDate = DateTime.now();
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
    _descController.dispose();
    _amountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  double safeCalculateProgress(double current, double target) {
    if (target <= 0 || current < 0) return 0.0;
    return (current / target).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final goals = context.watch<GoalProvider>().goals;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.aiGoal, style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
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
                child: goals.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada tujuan, tambahkan sekarang!',
                          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: goals.length,
                        itemBuilder: (ctx, i) {
                          final goal = goals[i];
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
                                title: Text(goal.description, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary)),
                                subtitle: Text(
                                  'Target: ${formatDate(goal.targetDate)} - ${formatCurrency(goal.targetAmount)}',
                                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                ),
                                trailing: CircularProgressIndicator(
                                  value: safeCalculateProgress(goal.currentProgress, goal.targetAmount),
                                  backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                ),
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
                    CustomTextField(
                      hint: 'Deskripsi Goal',
                      controller: _descController,
                      prefixIcon: Icons.flag_outlined,
                      validator: (val) => val!.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                    CustomTextField(
                      hint: 'Target Jumlah (Rp)',
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
                    CustomButton(
                      text: 'Pilih Tanggal',
                      onPressed: () => _pickDate(context),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: AppStrings.setGoal,
                      onPressed: () async {
                        if (_descController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                          try {
                            final amount = double.tryParse(_amountController.text);
                            if (amount == null || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Masukkan jumlah yang valid', style: AppTextStyles.body.copyWith(color: Colors.white)),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                              return;
                            }
                            final goal = Goal(
                              description: _descController.text,
                              targetDate: _targetDate,
                              targetAmount: amount,
                              currentProgress: 0.0,
                            );
                            await context.read<GoalProvider>().addGoal(context, goal);
                            _descController.clear();
                            _amountController.clear();
                            _targetDate = DateTime.now();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tujuan berhasil ditambahkan!', style: AppTextStyles.body.copyWith(color: Colors.white)),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menambahkan tujuan: $e', style: AppTextStyles.body.copyWith(color: Colors.white)),
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