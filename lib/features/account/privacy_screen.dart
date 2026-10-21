import 'package:flutter/material.dart';

import '../../core/localization/app_text.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(context.text('الخصوصية', 'Privacy'))),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.text(
                          'خصوصية النسخة التجريبية', 'Demo privacy notice'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    Text(context.text(
                      'هذه المعلومات تخص النسخة التجريبية الحالية فقط. جميع أسماء الموظفين وبيانات الرواتب والأرصدة المعروضة افتراضية.',
                      'This notice applies to the current demo only. Employee names, payroll figures and balances shown are fictional.',
                    )),
                    const SizedBox(height: 16),
                    Text(context.text(
                      'لا ترسل النسخة التجريبية رابط الشركة أو الحضور أو أسباب الإجازة إلى خادم. تبقى التغييرات في ذاكرة الجلسة وتُمسح بالخروج أو إغلاق التطبيق. لا تُدخل بيانات شخصية أو معلومات موظفين حقيقية أثناء التجربة.',
                      'The demo does not send company domains, attendance or leave reasons to a server. Changes remain in session memory and are cleared on sign-out or when the app closes. Do not enter personal or actual employee information during the demo.',
                    )),
                    const SizedBox(height: 16),
                    Text(context.text(
                      'لا تحتوي هذه النسخة على إعلانات أو أدوات تحليل أو تتبع. ولا تطلب الوصول إلى الموقع أو الكاميرا أو جهات الاتصال أو البيانات الصحية.',
                      'This version has no advertising, analytics or tracking. It does not request location, camera, contacts or health access.',
                    )),
                    const SizedBox(height: 16),
                    Text(context.text(
                      'قبل تفعيل خدمة الشركة، ستُحدّث سياسة الخصوصية لتوضح الجهة المسؤولة، والبيانات التي تُعالج، ومدة الاحتفاظ بها، وطرق التواصل وطلبات حذف البيانات.',
                      'Before live company services are enabled, the privacy policy must identify the responsible organization, data processing and retention, contact details and data-deletion procedures.',
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
