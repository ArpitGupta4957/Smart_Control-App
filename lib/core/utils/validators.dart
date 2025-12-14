class Validators {
  static String? validateApiKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'API Key is required';
    }
    if (value.length < 10) {
      return 'Invalid API Key format';
    }
    return null;
  }
  
  static String? validateRefreshToken(String? value) {
    if (value == null || value.isEmpty) {
      return 'Refresh Token is required';
    }
    if (value.length < 10) {
      return 'Invalid Refresh Token format';
    }
    return null;
  }
}