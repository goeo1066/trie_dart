/// A generic Trie (prefix tree) for Dart.
///
/// Provides a [Trie] data structure that supports synonym-based path chaining
/// and sequential keyword search. Define paths with [TriePath], attach
/// synonyms, and search concatenated keywords to collect matched data.
///
/// ```dart
/// import 'package:trie_dart/trie_dart.dart';
///
/// var trie = Trie<String>.withInitialData(
///   List.of({
///     TriePath<String>.withData("ABC").addSynonym("abc"),
///     TriePath<String>.withData("ABCD").addSynonym("abcd"),
///   }),
/// );
///
/// var result = trie.search("abcabcd");
/// print(result.data);      // [ABC, ABCD]
/// print(result.matched);   // abcabcd
/// print(result.remaining); // (empty)
/// ```
library;

export 'src/trie.dart' show Trie, TriePath, TrieResult;
