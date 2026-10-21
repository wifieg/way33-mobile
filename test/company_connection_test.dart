import 'package:flutter_test/flutter_test.dart';
import 'package:way_erp_mobile/features/onboarding/company_connection.dart';

void main() {
  test('normalizes a company hostname to an HTTPS origin', () {
    expect(CompanyConnection.parse(' acme.example.com ').origin.toString(),
        'https://acme.example.com/');
    expect(CompanyConnection.parse('https://acme.example.com/').origin.host,
        'acme.example.com');
  });

  for (final invalid in [
    '',
    'acme',
    'http://acme.example.com',
    'https://user:password@acme.example.com',
    'https://acme.example.com/path',
    'https://acme.example.com?company=other',
    'https://acme.example.com#other',
    'https://acme..example.com',
    'https://-acme.example.com',
    'https://acme.example.com.evil/path',
  ]) {
    test('rejects invalid company input: $invalid', () {
      expect(() => CompanyConnection.parse(invalid), throwsFormatException);
    });
  }
}
