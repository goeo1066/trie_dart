import 'package:test/test.dart';
import 'package:trie_dart/trie_dart.dart';

void main() {
  late Trie<String> trie;

  setUp(() {
    trie = Trie<String>.withInitialData(
      List.of({
        TriePath<String>.withData("ABC").addSynonym("abc"),
        TriePath<String>.withData("ABCD").addSynonym("abcd"),
      }),
    );
  });

  group('TrieResult', () {
    test('full match returns all data with empty remaining', () {
      var result = trie.search("abcabcd");
      expect(result.data, equals(["ABC", "ABCD"]));
      expect(result.matched, equals("abcabcd"));
      expect(result.remaining, isEmpty);
      expect(result.isFullMatch, isTrue);
      expect(result.hasData, isTrue);
    });

    test('partial match splits matched and remaining', () {
      var result = trie.search("abcxyz");
      expect(result.data, equals(["ABC"]));
      expect(result.matched, equals("abc"));
      expect(result.remaining, equals("xyz"));
      expect(result.isFullMatch, isFalse);
    });

    test('no match returns empty data with full remaining', () {
      var result = trie.search("zzz");
      expect(result.data, isEmpty);
      expect(result.matched, isEmpty);
      expect(result.remaining, equals("zzz"));
      expect(result.hasData, isFalse);
      expect(result.isFullMatch, isFalse);
    });

    test('empty keyword returns empty result', () {
      var result = trie.search("");
      expect(result.data, isEmpty);
      expect(result.matched, isEmpty);
      expect(result.remaining, isEmpty);
      expect(result.isFullMatch, isTrue);
    });

    test('toString provides readable output', () {
      var result = trie.search("abcxyz");
      expect(
        result.toString(),
        equals('TrieResult(data: [ABC], matched: "abc", remaining: "xyz")'),
      );
    });
  });
}
