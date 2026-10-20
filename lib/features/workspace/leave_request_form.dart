import 'package:flutter/material.dart';

import '../../core/localization/app_text.dart';
import 'demo_repository.dart';

class LeaveRequestForm extends StatefulWidget {
  final DemoRepository repository;

  const LeaveRequestForm({super.key, required this.repository});

  @override
  State<LeaveRequestForm> createState() => _LeaveRequestFormState();
}

class _LeaveRequestFormState extends State<LeaveRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _days = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _days.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.repository.requestLeave(
      days: parseLeaveDays(_days.text)!,
      reason: _reason.text,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.text('طلب إجازة تجريبي', 'Demo leave request')),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(context.text(
                        'هذا الطلب للتجربة فقط. لن يُرسل إلى مديرك ولن يؤثر على رصيد إجازتك.',
                        'This request is for demonstration only. It will not reach your manager or affect your leave balance.',
                      )),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const Key('leave-days'),
                        controller: _days,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: context.text('عدد الأيام', 'Number of days'),
                          helperText: context.text('من 1 إلى 21 يومًا', '1 to 21 days'),
                        ),
                        validator: (value) {
                          final days = parseLeaveDays(value ?? '');
                          return days == null || days < 1 || days > widget.repository.leaveDays
                              ? context.text('أدخل عددًا من 1 إلى 21.', 'Enter a number from 1 to 21.')
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const Key('leave-reason'),
                        controller: _reason,
                        minLines: 3,
                        maxLines: 6,
                        maxLength: 500,
                        decoration: InputDecoration(
                          labelText: context.text('سبب الإجازة', 'Reason for leave'),
                        ),
                        validator: (value) => (value ?? '').trim().isEmpty
                            ? context.text('أدخل سبب الإجازة.', 'Enter a reason for leave.')
                            : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(context.text('حفظ الطلب التجريبي', 'Save demo request')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
