// ignore_for_file: curly_braces_in_flow_control_structures

extension StringExtension on String {
  get firstLetterToUpperCase {
    if (this != null)
      return this[0].toUpperCase() + substring(1).toLowerCase();
    else
      return null;
  }
}
