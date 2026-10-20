import 'package:flutter/material.dart';

import '../../core/localization/app_text.dart';
import 'demo_repository.dart';
import 'leave_request_form.dart';

class WorkspaceScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;

  const WorkspaceScreen({super.key, required this.onToggleLanguage});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final _repository = DemoRepository();
  int _selected = 0;

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Future<void> _newRequest() async {
    final saved =
        await Navigator.of(context).push<bool>(MaterialPageRoute<bool>(
      builder: (_) => LeaveRequestForm(repository: _repository),
    ));
    if (!mounted || saved != true) {
      return;
    }
    setState(() => _selected = 1);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(context.text('حُفظ الطلب في الجلسة التجريبية.',
          'Request saved in this demo session.')),
    ));
  }

  String _time(DateTime? value) => value == null
      ? '—'
      : MaterialLocalizations.of(context).formatTimeOfDay(
          TimeOfDay.fromDateTime(value),
        );

  Widget _card({required Widget child}) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      );

  Widget _heading(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      );

  Widget _home() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heading(
              context.text('أهلًا بك، موظف تجريبي', 'Hello, demo employee')),
          Text(context.text('خدماتك اليومية في مكان واحد.',
              'Your everyday services in one place.')),
          const SizedBox(height: 24),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _heading(context.text('الحضور التجريبي', 'Demo attendance')),
                Text(context.text(
                  'تجربة محلية واحدة في هذه الجلسة. لا تُسجل بصمة فعلية لدى الشركة.',
                  'One local attendance trial per session. No actual company attendance is recorded.',
                )),
                const SizedBox(height: 16),
                _row(context.text('وقت الحضور', 'Check-in'),
                    _time(_repository.checkedInAt)),
                _row(context.text('وقت الانصراف', 'Check-out'),
                    _time(_repository.checkedOutAt)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  key: const Key('check-in'),
                  onPressed:
                      _repository.canCheckIn ? _repository.checkIn : null,
                  icon: const Icon(Icons.login),
                  label:
                      Text(context.text('تجربة تسجيل الحضور', 'Try check-in')),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  key: const Key('check-out'),
                  onPressed:
                      _repository.canCheckOut ? _repository.checkOut : null,
                  icon: const Icon(Icons.logout),
                  label: Text(
                      context.text('تجربة تسجيل الانصراف', 'Try check-out')),
                ),
              ],
            ),
          ),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _heading(context.text('رصيد الإجازات', 'Leave balance')),
                Text(context.text('21 يومًا', '21 days'),
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(context.text('رصيد افتراضي للتوضيح فقط.',
                    'A fictional balance for demonstration.')),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _newRequest,
                  icon: const Icon(Icons.add),
                  label: Text(
                      context.text('طلب إجازة تجريبي', 'Demo leave request')),
                ),
              ],
            ),
          ),
        ],
      );

  String _status(RequestStatus status) => switch (status) {
        RequestStatus.pending =>
          context.text('بانتظار المراجعة', 'Pending review'),
        RequestStatus.approved => context.text('معتمد', 'Approved'),
        RequestStatus.rejected => context.text('مرفوض', 'Rejected'),
      };

  void _requestDetails(EmployeeRequest request) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _heading(
                context.text('تفاصيل الطلب التجريبي', 'Demo request details')),
            Text(request.id, textDirection: TextDirection.ltr),
            const SizedBox(height: 16),
            _row(context.text('الحالة', 'Status'), _status(request.status)),
            _row(context.text('عدد الأيام', 'Days'), '${request.days}'),
            _row(
                context.text('تاريخ الإنشاء', 'Created'),
                MaterialLocalizations.of(context)
                    .formatMediumDate(request.createdAt)),
            const SizedBox(height: 16),
            Text(request.reason),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.text('إغلاق', 'Close')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requests() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heading(context.text('طلبات الإجازة', 'Leave requests')),
          ElevatedButton.icon(
            onPressed: _newRequest,
            icon: const Icon(Icons.add),
            label: Text(context.text('طلب إجازة تجريبي', 'Demo leave request')),
          ),
          const SizedBox(height: 24),
          if (_repository.requests.isEmpty)
            _card(
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(context.text('لا توجد طلبات بعد', 'No requests yet'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(context.text('أنشئ طلبًا لتجربة متابعة حالته هنا.',
                      'Create a request to try tracking its status here.')),
                ],
              ),
            ),
          for (final request in _repository.requests)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                isThreeLine: true,
                leading: const Icon(Icons.event_note),
                title: Text(context.text('إجازة · ${request.days} يوم',
                    'Leave · ${request.days} days')),
                subtitle: Text('${request.id}\n${_status(request.status)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _requestDetails(request),
              ),
            ),
        ],
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 16,
          runSpacing: 8,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );

  Widget _salary() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heading(context.text('كشف راتب تجريبي', 'Sample payslip')),
          Text(context.text('شهر سبتمبر 2026 · جميع المبالغ بالريال السعودي',
              'September 2026 · All amounts in Saudi riyals')),
          const SizedBox(height: 24),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.text('صافي الراتب', 'Net salary')),
                const SizedBox(height: 8),
                Text('7,000.00',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 24),
                _row(
                    context.text('الراتب الأساسي', 'Basic salary'), '6,000.00'),
                _row(
                    context.text('بدل السكن', 'Housing allowance'), '1,000.00'),
                _row(
                    context.text('بدل النقل', 'Transport allowance'), '500.00'),
                const Divider(),
                _row(context.text('إجمالي المستحقات', 'Gross pay'), '7,500.00'),
                _row(
                    context.text(
                        'استقطاعات توضيحية', 'Illustrative deductions'),
                    '500.00'),
                const Divider(),
                _row(context.text('الصافي', 'Net pay'), '7,000.00'),
              ],
            ),
          ),
          Text(context.text(
            'أرقام افتراضية لعرض شكل الكشف، ولا تمثل مسير راتب فعليًا أو احتسابًا نظاميًا للاستقطاعات.',
            'Fictional figures to demonstrate a payslip. They do not represent actual payroll or statutory deduction calculations.',
          )),
        ],
      );

  Widget _account() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _heading(context.text('حساب الموظف', 'Employee account')),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.account_circle_outlined, size: 64),
                const SizedBox(height: 16),
                _row(context.text('الاسم', 'Name'),
                    context.text('موظف تجريبي', 'Demo employee')),
                _row(context.text('الرقم الوظيفي', 'Employee ID'), 'DEMO-001'),
                _row(context.text('الشركة', 'Company'),
                    context.text('شركة تجريبية', 'Demo company')),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(Icons.language),
            label:
                Text(context.text('Switch to English', 'التبديل إلى العربية')),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            key: const Key('sign-out'),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.logout),
            label: Text(
                context.text('خروج ومسح التجربة', 'Sign out and clear demo')),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _repository,
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Way33'),
            actions: [
              IconButton(
                onPressed: widget.onToggleLanguage,
                tooltip:
                    context.text('التبديل إلى الإنجليزية', 'Switch to Arabic'),
                icon: const Icon(Icons.language),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Text(
                    context.text(
                        'نسخة تجريبية · بيانات افتراضية لا تُرسل للشركة',
                        'Demo · Sample data, nothing is sent to your company'),
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: ValueKey(_selected),
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: switch (_selected) {
                          0 => _home(),
                          1 => _requests(),
                          2 => _salary(),
                          _ => _account(),
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selected,
            onDestinationSelected: (value) => setState(() => _selected = value),
            destinations: [
              NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: context.text('الرئيسية', 'Home')),
              NavigationDestination(
                  icon: const Icon(Icons.description_outlined),
                  selectedIcon: const Icon(Icons.description),
                  label: context.text('طلباتي', 'Requests')),
              NavigationDestination(
                  icon: const Icon(Icons.payments_outlined),
                  selectedIcon: const Icon(Icons.payments),
                  label: context.text('الراتب', 'Salary')),
              NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: context.text('حسابي', 'Account')),
            ],
          ),
        ),
      );
}
