import 'package:trie_dart/trie_dart.dart';

void main() {
  // Build a trie with two chained paths.
  // The first path matches "abc" (with synonym "ABC"),
  // and the second path matches "abcd" (with synonym "ABCD").
  var trie = Trie<String>.withInitialData(
    List.of({
      TriePath<String>.withData("ABC").addSynonym("abc"),
      TriePath<String>.withData("ABCD").addSynonym("abcd"),
    }),
  );

  // Searching "abcabcd" traverses both paths sequentially:
  // - "abc" matches the first path → collects "ABC"
  // - "abcd" matches the second path → collects "ABCD"
  var results = trie.search("abcabcd");
  print(results); // [ABC, ABCD]

  // Searching a partial match
  var partial = trie.search("abc");
  print(partial); // [ABC]

  // Using synonyms — multiple strings can map to the same data
  var trieWithSynonyms = Trie<String>.withInitialData(
    List.of({
      TriePath<String>.withData("greeting")
          .addSynonym("hi")
          .addSynonym("hello"),
    }),
  );

  print(trieWithSynonyms.search("hi")); // [greeting]
  print(trieWithSynonyms.search("hello")); // [greeting]
}
