import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/localization/app_text.dart';
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
    if (!_formKey.currentState!.validate()) return;
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
        appBar: AppBar(
          actions: [
            TextButton.icon(
              onPressed: widget.onToggleLanguage,
              icon: const Icon(Icons.language),
              label: Text(context.text('English', 'العربية')),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.business_rounded,
                              size: 36,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Way33',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(context.text('مساحة عملك، أينما كنت',
                          'Your workspace, wherever you are'),
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(context.text(
                        'أدخل رابط شركتك للمتابعة، أو استكشف خدمات الموظف ببيانات تجريبية.',
                        'Enter your company domain, or explore employee services with sample data.',
                      )),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _domain,
                        key: const Key('company-domain'),
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (_) => _continue(),
                        decoration: InputDecoration(
                          labelText: context.text('رابط الشركة', 'Company domain'),
                          hintText: 'company.example.com',
                          prefixIcon: const Icon(Icons.link),
                        ),
                        validator: (value) {
                          try {
                            CompanyConnection.parse(value ?? '');
                            return null;
                          } on FormatException {
                            return context.text(
                              'أدخل نطاق الشركة الصحيح باستخدام HTTPS.',
                              'Enter a valid company domain using HTTPS.',
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _continue,
                        child: Text(context.text('متابعة', 'Continue')),
                      ),
                      if (AppConfig.demoMode) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _demo,
                          icon: const Icon(Icons.explore_outlined),
                          label: Text(context.text(
                              'استكشاف النسخة التجريبية', 'Explore demo')),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
