import 'package:trie_dart/trie_dart.dart';

void main() {
  var trie = Trie<String>.withInitialData(
    List.of({
      TriePath<String>.withData("ABC").addSynonym("abc"),
      TriePath<String>.withData("ABCD").addSynonym("abcd"),
    }),
  );

  print(trie.search("abc"));
}
