import 'package:test/test.dart';
import 'package:trie_dart/src/trie.dart';
import 'package:trie_dart/trie_dart.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('description', () {
      Trie<String> root = Trie.withInitialData(
        List.of({
          TriePath<String>.withData("ABC").addSynonym("abc"),
          TriePath<String>.withData("ABCD").addSynonym("abcd"),
        }),
      );

      print(root);

      var found = root.search("abcabcd");
      if (found != null) {
        print("found: " + found.toString());
      } else {
        print("Not Found");
      }
    });
  });
}
