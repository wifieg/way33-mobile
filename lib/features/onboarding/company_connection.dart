class CompanyConnection {
  final Uri origin;

  const CompanyConnection(this.origin);

  factory CompanyConnection.parse(String input) {
    final value = input.trim();
    final uri = Uri.tryParse(value.contains('://') ? value : 'https://$value');
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/') ||
        !uri.host.contains('.') ||
        uri.host.length > 253 ||
        uri.host.split('.').any(
              (label) => !RegExp(
                r'^[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$',
              ).hasMatch(label),
            )) {
      throw const FormatException('Enter a valid HTTPS company domain');
    }
    return CompanyConnection(uri.replace(path: '/'));
  }
}
