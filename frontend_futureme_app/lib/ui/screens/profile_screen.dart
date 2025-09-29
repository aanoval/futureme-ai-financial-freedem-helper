// Layar untuk pengaturan profil pengguna.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
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
    _incomeController = TextEditingController(text: profile.monthlyIncome.toString());
    _expensesController = TextEditingController(text: profile.monthlyExpenses.toString());
    _savingsController = TextEditingController(text: profile.savings.toString());
    _debtsController = TextEditingController(text: profile.debts.toString());
    _targetAgeController = TextEditingController(text: profile.targetFreedomAge.toString());
    _goalsController = TextEditingController(text: profile.financialGoals);
    _challengesController = TextEditingController(text: profile.currentChallenges);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profileSetup)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(hint: 'Nama', controller: _nameController, validator: validateName),
              CustomTextField(hint: 'Umur', controller: _ageController, keyboardType: TextInputType.number, validator: validateAge),
              CustomTextField(hint: 'Pemasukan Bulanan', controller: _incomeController, keyboardType: TextInputType.number, validator: validateAmount),
              CustomTextField(hint: 'Pengeluaran Bulanan', controller: _expensesController, keyboardType: TextInputType.number, validator: validateAmount),
              CustomTextField(hint: 'Tabungan Saat Ini', controller: _savingsController, keyboardType: TextInputType.number, validator: validateAmount),
              CustomTextField(hint: 'Hutang Saat Ini', controller: _debtsController, keyboardType: TextInputType.number, validator: validateAmount),
              CustomTextField(
                hint: 'Target Umur Kebebasan Finansial',
                controller: _targetAgeController,
                keyboardType: TextInputType.number,
                validator: (val) => validateTargetAge(val, int.tryParse(_ageController.text) ?? 0),
              ),
              CustomTextField(hint: 'Tujuan Finansial', controller: _goalsController, maxLines: 3),
              CustomTextField(hint: 'Tantangan Saat Ini', controller: _challengesController, maxLines: 3),
              const SizedBox(height: 20),
              CustomButton(
                text: AppStrings.save,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final profile = UserProfile(
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                      monthlyIncome: double.parse(_incomeController.text),
                      monthlyExpenses: double.parse(_expensesController.text),
                      savings: double.parse(_savingsController.text),
                      debts: double.parse(_debtsController.text),
                      targetFreedomAge: int.parse(_targetAgeController.text),
                      financialGoals: _goalsController.text,
                      currentChallenges: _challengesController.text,
                    );
                    context.read<UserProvider>().updateProfile(profile);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil disimpan!')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _savingsController.dispose();
    _debtsController.dispose();
    _targetAgeController.dispose();
    _goalsController.dispose();
    _challengesController.dispose();
    super.dispose();
  }
}