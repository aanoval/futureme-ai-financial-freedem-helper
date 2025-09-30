import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../../core/utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;
  late TextEditingController _incomeController;
  late TextEditingController _expensesController;
  late TextEditingController _savingsController;
  late TextEditingController _debtsController;
  late TextEditingController _targetAgeController;
  late TextEditingController _goalsController;
  late TextEditingController _challengesController;

  @override
  void initState() {
    super.initState();
    final profile = context.read<UserProvider>().profile;
    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _occupationController = TextEditingController(text: profile.occupation);
    _incomeController = TextEditingController(text: profile.monthlyIncome.toString());
    _expensesController = TextEditingController(text: profile.monthlyExpenses.toString());
    _savingsController = TextEditingController(text: profile.savings.toString());
    _debtsController = TextEditingController(text: profile.debts.toString());
    _targetAgeController = TextEditingController(text: profile.targetFreedomAge.toString());
    _goalsController = TextEditingController(text: profile.financialGoals);
    _challengesController = TextEditingController(text: profile.currentChallenges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _savingsController.dispose();
    _debtsController.dispose();
    _targetAgeController.dispose();
    _goalsController.dispose();
    _challengesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profileSetup, style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Pribadi',
                style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'Nama Lengkap',
                controller: _nameController,
                validator: validateName,
                prefixIcon: Icons.person_outline,
              ),
              CustomTextField(
                hint: 'Umur (Tahun)',
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: validateAge,
                prefixIcon: Icons.cake_outlined,
              ),
              CustomTextField(
                hint: 'Pekerjaan',
                controller: _occupationController,
                validator: (val) => val!.isEmpty ? 'Pekerjaan wajib diisi' : null,
                prefixIcon: Icons.work_outline,
              ),
              const SizedBox(height: 24),
              Text(
                'Keuangan Bulanan',
                style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'Pemasukan Bulanan (Rp)',
                controller: _incomeController,
                keyboardType: TextInputType.number,
                validator: validateAmount,
                prefixIcon: Icons.attach_money,
              ),
              CustomTextField(
                hint: 'Pengeluaran Bulanan (Rp)',
                controller: _expensesController,
                keyboardType: TextInputType.number,
                validator: validateAmount,
                prefixIcon: Icons.money_off_outlined,
              ),
              CustomTextField(
                hint: 'Tabungan Saat Ini (Rp)',
                controller: _savingsController,
                keyboardType: TextInputType.number,
                validator: validateAmount,
                prefixIcon: Icons.savings_outlined,
              ),
              CustomTextField(
                hint: 'Hutang Saat Ini (Rp)',
                controller: _debtsController,
                keyboardType: TextInputType.number,
                validator: validateAmount,
                prefixIcon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: 24),
              Text(
                'Tujuan Finansial',
                style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'Target Umur Kebebasan Finansial (Tahun)',
                controller: _targetAgeController,
                keyboardType: TextInputType.number,
                validator: (val) => validateTargetAge(val, int.tryParse(_ageController.text) ?? 0),
                prefixIcon: Icons.flag_outlined,
              ),
              CustomTextField(
                hint: 'Tujuan Finansial (Opsional)',
                controller: _goalsController,
                maxLines: 3,
                prefixIcon: Icons.star_outline,
              ),
              CustomTextField(
                hint: 'Tantangan Finansial Saat Ini (Opsional)',
                controller: _challengesController,
                maxLines: 3,
                prefixIcon: Icons.warning_amber_outlined,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.save,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final profile = UserProfile(
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                      occupation: _occupationController.text,
                      monthlyIncome: double.parse(_incomeController.text),
                      monthlyExpenses: double.parse(_expensesController.text),
                      savings: double.parse(_savingsController.text),
                      debts: double.parse(_debtsController.text),
                      targetFreedomAge: int.parse(_targetAgeController.text),
                      financialGoals: _goalsController.text,
                      currentChallenges: _challengesController.text,
                    );
                    context.read<UserProvider>().updateProfile(profile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Profil berhasil disimpan!',
                          style: AppTextStyles.body.copyWith(color: Colors.white),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}