import 'package:flutter/material.dart';

import '../../core/localization/app_text.dart';
import '../onboarding/company_connection.dart';
import '../workspace/workspace_screen.dart';

class LoginScreen extends StatelessWidget {
  final CompanyConnection? company;
  final VoidCallback onToggleLanguage;

  const LoginScreen({
    super.key,
    this.company,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.text('الدخول', 'Sign in')),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_outline, size: 56),
                    const SizedBox(height: 24),
                    Text(
                      company == null
                          ? context.text('جرّب مساحة الموظف',
                              'Explore the employee workspace')
                          : context.text('تم تحديد رابط الشركة',
                              'Company domain selected'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (company != null) ...[
                      SelectableText(company!.origin.toString(),
                          textDirection: TextDirection.ltr),
                      const SizedBox(height: 16),
                      Text(context.text(
                        'الدخول الفعلي غير متاح في هذه النسخة بعد. لم نتحقق من اتصال الشركة، ولن نطلب بيانات دخولك حتى يكتمل الربط.',
                        'Live sign-in is not available in this version yet. The company connection has not been verified. We will ask for credentials once integration is ready.',
                      )),
                    ] else ...[
                      Text(context.text(
                        'حساب توضيحي ببيانات افتراضية. لا تحتاج إلى كلمة مرور، ولا تُرسل أي بيانات إلى شركتك. تُمسح التغييرات عند الخروج.',
                        'A sample account with fictional data. No password is needed and nothing is sent to your company. Changes are cleared when you sign out.',
                      )),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => WorkspaceScreen(
                              onToggleLanguage: onToggleLanguage,
                            ),
                          ),
                        ),
                        child: Text(context.text(
                            'دخول الحساب التجريبي', 'Enter demo account')),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(context.text('العودة لاختيار الشركة',
                          'Back to company selection')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
