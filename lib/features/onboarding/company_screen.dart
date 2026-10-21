import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/app_text.dart';
import '../../core/widgets/brand_mark.dart';
import '../account/privacy_screen.dart';
import '../auth/login_screen.dart';
import 'company_connection.dart';

class CompanyScreen extends StatefulWidget {
  final Locale locale;
  final VoidCallback onToggleLanguage;

  const CompanyScreen({
    super.key,
    required this.locale,
    required this.onToggleLanguage,
  });

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _domain = TextEditingController(text: AppConfig.apiBaseUrl);

  @override
  void dispose() {
    _domain.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LoginScreen(
        company: CompanyConnection.parse(_domain.text),
        onToggleLanguage: widget.onToggleLanguage,
      ),
    ));
  }

  void _demo() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LoginScreen(onToggleLanguage: widget.onToggleLanguage),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: TextButton.icon(
              onPressed: widget.onToggleLanguage,
              icon: const Icon(Icons.language, size: 20),
              label: Text(context.text('English', 'العربية')),
            ),
          ),
        ]),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BrandMark(size: 64)),
                    const SizedBox(height: 22),
                    Text('Way33',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                        context.text('يوم عملك، في مكان واحد.',
                            'Your workday, in one place.'),
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(
                        context.text(
                            'الحضور والطلبات والراتب. خدمات الموظف أقرب إليك.',
                            'Attendance, requests and salary. Your employee services, close at hand.'),
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    const SizedBox(height: 28),
                    Card(
                        child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                    context.text('ابدأ بشركتك',
                                        'Start with your company'),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 8),
                                Text(
                                    context.text(
                                        'استخدم الرابط الذي حصلت عليه من جهة عملك.',
                                        'Use the domain provided by your employer.'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant)),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _domain,
                                  key: const Key('company-domain'),
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.url,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.go,
                                  onFieldSubmitted: (_) => _continue(),
                                  decoration: InputDecoration(
                                    labelText: context.text(
                                        'رابط الشركة', 'Company domain'),
                                    hintText: 'company.example.com',
                                    prefixIcon: const Icon(
                                        Icons.apartment_rounded,
                                        size: 22),
                                  ),
                                  validator: (value) {
                                    try {
                                      CompanyConnection.parse(value ?? '');
                                      return null;
                                    } on FormatException {
                                      return context.text(
                                          'أدخل نطاق الشركة الصحيح باستخدام HTTPS.',
                                          'Enter a valid company domain using HTTPS.');
                                    }
                                  },
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                    onPressed: _continue,
                                    child: Text(
                                        context.text('متابعة', 'Continue'))),
                                if (AppConfig.demoMode) ...[
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: _demo,
                                    icon: const Icon(Icons.explore_outlined,
                                        size: 20),
                                    label: Text(context.text(
                                        'استكشاف النسخة التجريبية',
                                        'Explore demo')),
                                  ),
                                ],
                              ],
                            ))),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const PrivacyScreen())),
                      icon: const Icon(Icons.privacy_tip_outlined, size: 18),
                      label: Text(context.text('الخصوصية', 'Privacy')),
                    ),
                  ],
                )),
          ),
        ))),
      );
}
