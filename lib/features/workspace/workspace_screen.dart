import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/brand_mark.dart';
import '../account/privacy_screen.dart';
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

  Widget _statTile(IconData icon, String title, String value, String detail) =>
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconBadge(icon),
            const SizedBox(height: 16),
            Text(title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );

  Widget _iconBadge(IconData icon, {Color? color}) {
    final accent = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, size: 22, color: accent),
    );
  }

  Widget _serviceTile(
          IconData icon, String title, String subtitle, VoidCallback onTap) =>
      Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              _iconBadge(icon),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          )),
                ],
              )),
              const SizedBox(width: 8),
              Icon(context.isArabic ? Icons.chevron_left : Icons.chevron_right,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ]),
          ),
        ),
      );

  Widget _attendanceTime(String title, DateTime? time) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Color(0xFFBFCDD9))),
          const SizedBox(height: 6),
          Text(_time(time),
              style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ],
      );

  Widget _attendance() => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF116F63), Color(0xFF123F43)],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Text(context.text('الحضور التجريبي', 'Demo attendance'),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _repository.canCheckIn
                          ? context.text('لم يبدأ الدوام', 'Not checked in')
                          : _repository.canCheckOut
                              ? context.text('داخل الدوام', 'Checked in')
                              : context.text(
                                  'انتهت التجربة', 'Trial completed'),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFFBCEAD9)),
                    ),
                  ),
                ]),
            const SizedBox(height: 26),
            Row(children: [
              Expanded(
                  child: _attendanceTime(context.text('وقت الحضور', 'Check-in'),
                      _repository.checkedInAt)),
              Container(
                  width: 1,
                  height: 48,
                  color: Colors.white.withValues(alpha: .15)),
              const SizedBox(width: 20),
              Expanded(
                  child: _attendanceTime(
                      context.text('وقت الانصراف', 'Check-out'),
                      _repository.checkedOutAt)),
            ]),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              key: const Key('check-in'),
              onPressed: _repository.canCheckIn ? _repository.checkIn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB9F0DC),
                foregroundColor: AppTheme.navy,
                disabledBackgroundColor: Colors.white.withValues(alpha: .08),
                disabledForegroundColor: const Color(0xFFBBC9D6),
              ),
              icon: const Icon(Icons.fingerprint, size: 22),
              label: Text(context.text('تجربة تسجيل الحضور', 'Try check-in')),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const Key('check-out'),
              onPressed: _repository.canCheckOut ? _repository.checkOut : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                disabledForegroundColor: const Color(0xFF9CB0C2),
                side: BorderSide(color: Colors.white.withValues(alpha: .2)),
              ),
              icon: const Icon(Icons.logout, size: 19),
              label:
                  Text(context.text('تجربة تسجيل الانصراف', 'Try check-out')),
            ),
            const SizedBox(height: 12),
            Text(
                context.text('تجربة محلية فقط؛ لا تُسجّل بصمة لدى الشركة.',
                    'Local trial only; no company attendance is recorded.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, height: 1.5, color: Color(0xFFBFCDD9))),
          ],
        ),
      );

  Widget _home() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.text('أهلًا بك،', 'Welcome back,'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 3),
                Text(context.text('موظف تجريبي', 'Demo employee'),
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            )),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant)),
              child: Icon(Icons.person_outline_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 28),
            ),
          ]),
          const SizedBox(height: 24),
          _attendance(),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final leave = _statTile(
                Icons.event_available_outlined,
                context.text('رصيد الإجازات', 'Leave balance'),
                '21',
                context.text('يومًا · رصيد توضيحي', 'days · sample balance'));
            final requests = _statTile(
                Icons.description_outlined,
                context.text('طلباتك', 'Your requests'),
                '${_repository.requests.length}',
                context.text('طلبات في هذه التجربة', 'requests in this demo'));
            if (constraints.maxWidth < 320 ||
                MediaQuery.textScalerOf(context).scale(14) > 20) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [leave, requests]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: leave),
              const SizedBox(width: 14),
              Expanded(child: requests),
            ]);
          }),
          const SizedBox(height: 8),
          _heading(context.text('خدماتك السريعة', 'Quick services')),
          _serviceTile(
              Icons.add_circle_outline,
              context.text('طلب إجازة تجريبي', 'Demo leave request'),
              context.text('أنشئ طلبًا وتابع حالته',
                  'Create a request and follow its status'),
              _newRequest),
          const SizedBox(height: 12),
          _serviceTile(
              Icons.receipt_long_outlined,
              context.text('كشف الراتب', 'View payslip'),
              context.text('تفاصيل المستحقات والاستقطاعات',
                  'Review earnings and deductions'),
              () => setState(() => _selected = 2)),
          const SizedBox(height: 8),
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
                trailing: Icon(context.isArabic
                    ? Icons.chevron_left
                    : Icons.chevron_right),
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
          Text(context.text('سبتمبر 2026', 'September 2026'),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
                color: AppTheme.navy, borderRadius: BorderRadius.circular(24)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: Color(0xFFB9F0DC), size: 28),
              const SizedBox(height: 22),
              Text(context.text('صافي الراتب', 'Net salary'),
                  style: const TextStyle(color: Color(0xFFBFCDD9))),
              const SizedBox(height: 4),
              const Text('7,000.00',
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(height: 6),
              Text(
                  context.text('ريال سعودي · عينة توضيحية',
                      'Saudi riyals · sample figures'),
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFB9F0DC))),
            ]),
          ),
          const SizedBox(height: 24),
          _heading(context.text('تفاصيل الكشف', 'Payslip breakdown')),
          _card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
              ])),
          Text(
              context.text(
                'أرقام افتراضية لعرض شكل الكشف، ولا تمثل مسير راتب فعليًا أو احتسابًا نظاميًا للاستقطاعات.',
                'Fictional figures to demonstrate a payslip. They do not represent actual payroll or statutory deduction calculations.',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
              Align(
                  child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle),
                child: Icon(Icons.person_outline_rounded,
                    size: 42, color: Theme.of(context).colorScheme.primary),
              )),
              const SizedBox(height: 16),
              Text(context.text('موظف تجريبي', 'Demo employee'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
              Text(context.text('شركة تجريبية', 'Demo company'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              const Divider(),
              _row(context.text('الرقم الوظيفي', 'Employee ID'), 'DEMO-001'),
              _row(context.text('نوع الحساب', 'Account type'),
                  context.text('حساب توضيحي', 'Demo account')),
            ],
          )),
          const SizedBox(height: 8),
          _heading(
              context.text('التفضيلات والخصوصية', 'Preferences and privacy')),
          _serviceTile(
              Icons.language,
              context.text('Switch to English', 'التبديل إلى العربية'),
              context.text('لغة العرض', 'Display language'),
              widget.onToggleLanguage),
          const SizedBox(height: 12),
          _serviceTile(
              Icons.privacy_tip_outlined,
              context.text('الخصوصية', 'Privacy'),
              context.text('كيف تتعامل التجربة مع بياناتك',
                  'How the demo handles your data'),
              () => Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (_) => const PrivacyScreen()))),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const Key('sign-out'),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            icon: const Icon(Icons.logout, size: 20),
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
            foregroundColor: Colors.white,
            backgroundColor: AppTheme.navy,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: Container(
                decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF14796F), Color(0xFF0E655D)],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd),
            )),
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              const BrandMark(size: 34),
              const SizedBox(width: 10),
              Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('Way33',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700)),
                    if (MediaQuery.textScalerOf(context).scale(11) <= 14)
                      Text(context.text('مساحة الموظف', 'Employee workspace'),
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFFE3F6F1))),
                  ])),
            ]),
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
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Text(
                    context.text('نسخة تجريبية · البيانات لا تُرسل للشركة',
                        'Demo · No data is sent to your company'),
                    style: TextStyle(
                        fontSize: 11,
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
            onDestinationSelected: (value) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              setState(() => _selected = value);
            },
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
