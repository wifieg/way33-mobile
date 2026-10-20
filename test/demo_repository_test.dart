import 'package:flutter_test/flutter_test.dart';
import 'package:way_erp_mobile/features/workspace/demo_repository.dart';

void main() {
  test('leave day entry supports Arabic and Persian digits', () {
    expect(parseLeaveDays(' ٢١ '), 21);
    expect(parseLeaveDays('۳'), 3);
    expect(parseLeaveDays('3'), 3);
    expect(parseLeaveDays('two'), isNull);
  });

  test('attendance enforces a single check-in then check-out per session', () {
    var now = DateTime(2026, 10, 20, 8);
    final repository = DemoRepository(clock: () => now);
    addTearDown(repository.dispose);
    var notifications = 0;
    repository.addListener(() => notifications++);

    repository.checkOut();
    expect(repository.checkedOutAt, isNull);
    expect(notifications, 0);

    repository.checkIn();
    final firstCheckIn = repository.checkedInAt;
    expect(repository.canCheckIn, isFalse);
    expect(repository.canCheckOut, isTrue);
    now = now.add(const Duration(hours: 8));
    repository.checkIn();
    expect(repository.checkedInAt, firstCheckIn);
    repository.checkOut();
    expect(repository.checkedOutAt, now);
    expect(repository.canCheckOut, isFalse);
    repository.checkOut();
    expect(notifications, 2);
  });

  test('leave requests validate data and retain newest first with unique IDs',
      () {
    final repository = DemoRepository(clock: () => DateTime(2026, 10, 20));
    addTearDown(repository.dispose);

    expect(() => repository.requestLeave(days: 0, reason: 'Rest'),
        throwsArgumentError);
    expect(() => repository.requestLeave(days: 22, reason: 'Rest'),
        throwsArgumentError);
    expect(() => repository.requestLeave(days: 1, reason: '  '),
        throwsArgumentError);
    expect(repository.requests, isEmpty);

    final first = repository.requestLeave(days: 3, reason: ' Family visit ');
    final second = repository.requestLeave(days: 2, reason: 'Rest');
    expect(repository.requests, [second, first]);
    expect(first.reason, 'Family visit');
    expect(first.id, isNot(second.id));
    expect(first.status, RequestStatus.pending);
    expect(() => repository.requests.clear(), throwsUnsupportedError);
    expect(repository.leaveDays, 21);
  });

  test('a new session contains no prior employee data', () {
    final first = DemoRepository();
    addTearDown(first.dispose);
    first.checkIn();
    first.requestLeave(days: 1, reason: 'Rest');
    final second = DemoRepository();
    addTearDown(second.dispose);
    expect(second.requests, isEmpty);
    expect(second.checkedInAt, isNull);
    expect(second.checkedOutAt, isNull);
  });
}
