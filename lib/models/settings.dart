class Settings {
  bool isDarkMode;
  int primaryColorValue;

  Settings({
    this.isDarkMode = false,
    this.primaryColorValue = 0xFF2196F3, // Blue
  });

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode ? 1 : 0,
      'primaryColorValue': primaryColorValue,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      isDarkMode: map['isDarkMode'] == 1,
      primaryColorValue: map['primaryColorValue'] ?? 0xFF2196F3,
    );
  }
}
