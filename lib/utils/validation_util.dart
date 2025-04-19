class ValidationUtil {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    } else if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^(?:\+88|88)?01[3-9]\d{8}$').hasMatch(value.trim())) {
      return 'Enter a valid Bangladeshi number';
    }
    return null;
  }

  static String? validateNote(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.contains(RegExp(r'[\n\r]'))) {
        return 'Note must be a single line';
      } else if (value.length > 40) {
        return 'Note must be within 40 characters';
      }
    }
    return null;
  }


  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
