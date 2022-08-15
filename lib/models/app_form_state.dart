import 'package:flutter/foundation.dart' show ValueNotifier, mapEquals, immutable;

@immutable
abstract class AppFormState<K, V> {
  AppFormState(Map<K, V> formState)
      : _formState = formState,
        _notifierList = [
          for (final key in formState.entries) ValueNotifier<Map<K, V>>({key.key: key.value})
        ];

  final Map<K, V> _formState;
  final List<ValueNotifier<Map<K, V>>> _notifierList;

  Map<K, V> get state => {..._formState};
  List<ValueNotifier<Map<K, V>>> get notifiers => _notifierList;

  ValueNotifier<Map<K, V>> getNotifier(K key) {
    final notifier = _notifierList.singleWhere(
      (element) => element.value.containsKey(key),
    );
    return notifier;
  }

  void delete(K key) {
    _formState.remove(key);
  }

  void updateFormOnly(K key, V newValue) {
    _formState.update(key, (value) => newValue);
  }

  void updateValuesFormOnly(Map<K, V> values) {
    _formState.addEntries(values.entries);
  }

  void updateValue(K key, V newValue) {
    _formState.update(key, (value) => newValue);
    for (final notifier in _notifierList) {
      if (notifier.value.containsKey(key)) {
        notifier.value = {key: newValue};
        break;
      }
    }
  }

  void updateValues(Map<K, V> values) {
    _formState.addEntries(values.entries);
    for (final entry in values.entries) {
      final toChange = _notifierList.firstWhere((element) => element.value.containsKey(entry.key));
      toChange.value = {entry.key: entry.value};
    }
  }

  V getValue(String key) => _formState[key]!;

  operator [](K key) => _formState[key];
  operator []=(K key, V newValue) {
    _formState.update(key, (value) => newValue);
    for (final notifier in _notifierList) {
      if (notifier.value.containsKey(key)) {
        notifier.value = {key: newValue};
        break;
      }
    }
  }

  @override
  String toString() => {..._formState}.toString();

  @override
  bool operator ==(Object other) {
    return other is AppFormState<K, V> && mapEquals(_formState, other._formState);
  }

  @override
  int get hashCode => _formState.hashCode ^ _notifierList.hashCode;
}
