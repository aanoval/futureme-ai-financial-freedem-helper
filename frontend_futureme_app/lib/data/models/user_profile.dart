// Model for user profile stored in SharedPreferences.
class UserProfile {
  String name;
  int age;
  String occupation;
  double monthlyIncome;
  double monthlyExpenses;
  double savings;
  double debts;
  int targetFreedomAge;
  String financialGoals;
  String currentChallenges;

  UserProfile({
    required this.name,
    required this.age,
    this.occupation = 'Freelancer',
    this.monthlyIncome = 0.0,
    this.monthlyExpenses = 0.0,
    this.savings = 0.0,
    this.debts = 0.0,
    required this.targetFreedomAge,
    this.financialGoals = '',
    this.currentChallenges = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'savings': savings,
      'debts': debts,
      'targetFreedomAge': targetFreedomAge,
      'financialGoals': financialGoals,
      'currentChallenges': currentChallenges,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      age: map['age'],
      occupation: map['occupation'],
      monthlyIncome: map['monthlyIncome'],
      monthlyExpenses: map['monthlyExpenses'],
      savings: map['savings'],
      debts: map['debts'],
      targetFreedomAge: map['targetFreedomAge'],
      financialGoals: map['financialGoals'],
      currentChallenges: map['currentChallenges'],
    );
  }
}