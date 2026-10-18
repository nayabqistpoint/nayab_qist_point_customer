class PlanFilterSortService {
  static List<Map<String, dynamic>> filterAndSort({
    required List<Map<String, dynamic>> allPlans,
    required String guaranteeFilter,
    required String advanceFilter,
    required int durationFilter,
    required String sortKey,
  }) {
    final filtered = allPlans.where((plan) {
      if (guaranteeFilter != 'ALL' && plan['guarantee'] != guaranteeFilter) {
        return false;
      }
      if (advanceFilter == 'WITH_ADV' && plan['hasAdvance'] == false) {
        return false;
      }
      if (advanceFilter == 'ZERO_ADV' && plan['hasAdvance'] == true) {
        return false;
      }
      if (durationFilter != 0 && plan['months'] != durationFilter) {
        return false;
      }
      return true;
    }).toList();

    if (sortKey == 'LOW_MONTHLY') {
      filtered.sort((a, b) => (a['monthly'] as int).compareTo(b['monthly'] as int));
    } else if (sortKey == 'SHORTEST_DURATION') {
      filtered.sort((a, b) => (a['months'] as int).compareTo(b['months'] as int));
    } else if (sortKey == 'LOWEST_TOTAL') {
      filtered.sort((a, b) {
        final int totalA = (a['advance'] as int) + ((a['monthly'] as int) * ((a['months'] as int) - 1));
        final int totalB = (b['advance'] as int) + ((b['monthly'] as int) * ((b['months'] as int) - 1));
        return totalA.compareTo(totalB);
      });
    } else {
      // ڈیفالٹ معیاری ترتیب (تمام کسٹمرز کے لیے یکساں):
      // 1. پہلے مدت (Months ASC)
      // 2. پھر گارنٹی (پہلے بینک چیک، پھر اشٹام)
      // 3. پھر ایڈوانس کی نوعیت (پہلے ایڈوانس کے ساتھ، پھر بغیر ایڈوانس)
      filtered.sort((a, b) {
        final int cmpDuration = (a['months'] as int).compareTo(b['months'] as int);
        if (cmpDuration != 0) return cmpDuration;

        final bool isChequeA = a['guarantee'] == 'BANK_CHEQUE';
        final bool isChequeB = b['guarantee'] == 'BANK_CHEQUE';
        if (isChequeA != isChequeB) {
          return isChequeA ? -1 : 1;
        }

        final bool hasAdvA = a['hasAdvance'] == true;
        final bool hasAdvB = b['hasAdvance'] == true;
        if (hasAdvA != hasAdvB) {
          return hasAdvA ? -1 : 1;
        }

        return (a['monthly'] as int).compareTo(b['monthly'] as int);
      });
    }
    return filtered;
  }
}