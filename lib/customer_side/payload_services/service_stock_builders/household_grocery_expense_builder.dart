class HouseholdGroceryExpenseBuilder {
  static Map<String, dynamic> buildDiscountsLossAccumulator({
    required Map<String, dynamic>? existingConfig,
    required int billAmount,
  }) {
    final Map<String, dynamic> config = existingConfig != null
        ? Map<String, dynamic>.from(existingConfig)
        : {
            'configId': 'discounts_config',
            'special_discount': 0,
            'general_discount': 0,
            'household_expense_loss': 0,
          };

    final int currentLoss = (config['household_expense_loss'] as num?)?.toInt() ?? 0;
    config['household_expense_loss'] = currentLoss + billAmount;
    config['lastUpdated'] = DateTime.now().toIso8601String();
    config['isSynced'] = false;
    config['status'] = 'PENDING';

    return config;
  }
}