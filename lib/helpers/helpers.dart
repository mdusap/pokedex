class Helper {
  
  Helper._privateConstructor();
  static final Helper _instance = Helper._privateConstructor();
  static Helper get instance => _instance;

  String capitalize(String s) {
      if (s.isEmpty) {
        return '';
      }
      return s[0].toUpperCase() + s.substring(1);
    }
}