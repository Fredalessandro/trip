abstract class ILocalStorage {
  Future getString(String key);
  Future delete(String key);
  Future put(String key, dynamic value);
}