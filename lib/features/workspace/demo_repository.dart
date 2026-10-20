import 'package:flutter/foundation.dart';

enum RequestStatus { pending, approved, rejected }

int? parseLeaveDays(String value) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  var normalized = value.trim();
  for (var digit = 0; digit < 10; digit++) {
    normalized = normalized
        .replaceAll(arabic[digit], '$digit')
        .replaceAll(persian[digit], '$digit');
  }
  return int.tryParse(normalized);
}

class EmployeeRequest {
  final String id;
  final int days;
  final String reason;
  final DateTime createdAt;
  final RequestStatus status;

  const EmployeeRequest({
    required this.id,
    required this.days,
    required this.reason,
    required this.createdAt,
    this.status = RequestStatus.pending,
  });
}

/// Fictional, session-only data. Never connects to a company or posts attendance.
class DemoRepository extends ChangeNotifier {
  final DateTime Function() _clock;
  final List<EmployeeRequest> _requests = [];
  DateTime? _checkedInAt;
  DateTime? _checkedOutAt;
  int _nextRequest = 1;

  DemoRepository({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  List<EmployeeRequest> get requests => List.unmodifiable(_requests);
  int get leaveDays => 21;
  DateTime? get checkedInAt => _checkedInAt;
  DateTime? get checkedOutAt => _checkedOutAt;

  bool get canCheckIn => checkedInAt == null;
  bool get canCheckOut => checkedInAt != null && checkedOutAt == null;

  void checkIn() {
    if (!canCheckIn) {
      return;
    }
    _checkedInAt = _clock();
    notifyListeners();
  }

  void checkOut() {
    if (!canCheckOut) {
      return;
    }
    _checkedOutAt = _clock();
    notifyListeners();
  }

  EmployeeRequest requestLeave({required int days, required String reason}) {
    if (days < 1 || days > leaveDays || reason.trim().isEmpty) {
      throw ArgumentError('A reason and 1 to 21 days are required');
    }
    final request = EmployeeRequest(
      id: 'DEMO-${_nextRequest++}',
      days: days,
      reason: reason.trim(),
      createdAt: _clock(),
    );
    _requests.insert(0, request);
    notifyListeners();
    return request;
  }
}
