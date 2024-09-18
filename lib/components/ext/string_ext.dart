extension StringExt on String {
  String toRupiah({String separator='.', String trailing=''}) {
    return "Rp ${replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$separator')}$trailing";
  }
  bool parseBool() {
    return toLowerCase() == 'true';
  }

  String getInitials(String fullName) => fullName.isNotEmpty
      ? fullName
      .trim()
      .split(RegExp(' +'))
      .map((s) => s[0])
      .take(2)
      .join()
      : '';


  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}