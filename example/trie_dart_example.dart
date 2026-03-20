import 'package:trie_dart/trie_dart.dart';

void main() {
  var trie = Trie<String>.withInitialData(
    List.of({
      TriePath<String>.withData("ABC").addSynonym("abc"),
      TriePath<String>.withData("ABCD").addSynonym("abcd"),
    }),
  );

  // Full match — entire input is consumed
  var result = trie.search("abcabcd");
  print(result.data);        // [ABC, ABCD]
  print(result.matched);     // abcabcd
  print(result.remaining);   // (empty)
  print(result.isFullMatch); // true

  // Partial match — "xyz" is not in the trie
  var partial = trie.search("abcxyz");
  print(partial.data);        // [ABC]
  print(partial.matched);     // abc
  print(partial.remaining);   // xyz
  print(partial.isFullMatch); // false

  // No match
  var noMatch = trie.search("zzz");
  print(noMatch.data);      // []
  print(noMatch.hasData);   // false
  print(noMatch.remaining); // zzz
}
