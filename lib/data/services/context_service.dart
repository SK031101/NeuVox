
abstract class ContextService {
  Future<void> addInteraction(String intent);
  Future<List<String>> getRecentHistory();
  Future<String> getContextualSuggestion(); // Simulates AI predicting next need
}

class ContextServiceImpl implements ContextService {
  final List<String> _history = [];
  
  @override
  Future<void> addInteraction(String intent) async {
    _history.add(intent);
    if (_history.length > 10) _history.removeAt(0);
  }

  @override
  Future<List<String>> getRecentHistory() async => _history;

  @override
  Future<String> getContextualSuggestion() async {
    // Mock logic: if last was "pain", suggest "doctor"
    if (_history.isNotEmpty) {
      final last = _history.last.toLowerCase();
      if (last.contains("pain")) return "Call Doctor";
      if (last.contains("water")) return "Food";
      if (last.contains("hello")) return "How are you";
    }
    return "";
  }
}
