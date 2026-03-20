# trie_dart

A generic Trie (prefix tree) data structure for Dart that supports synonym-based path chaining and sequential keyword search.

## Features

- Generic type parameter — store any data type (`T`) at trie nodes
- Synonym support — define multiple string synonyms for a single `TriePath`, so different spellings or aliases resolve to the same data
- Path chaining — insert multiple `TriePath` entries that are linked sequentially; the trie merges them so a search can match concatenated keywords in order
- Efficient prefix search — traverse character-by-character using Unicode runes, collecting all matched data along the way

## Getting started

Add `trie_dart` to your `pubspec.yaml`:

```yaml
dependencies:
  trie_dart: ^0.1.0
```

Then run:

```sh
dart pub get
```

## Usage

```dart
import 'package:trie_dart/trie_dart.dart';

void main() {
  var trie = Trie<String>.withInitialData(
    List.of({
      TriePath<String>.withData("ABC").addSynonym("abc"),
      TriePath<String>.withData("ABCD").addSynonym("abcd"),
    }),
  );

  // Search returns all data matched along the path.
  // For "abcabcd", it finds "ABC" at position 3 and "ABCD" at position 7.
  print(trie.search("abcabcd")); // [ABC, ABCD]
}
```

### API

**`Trie<T>.withInitialData(List<TriePath<T>> triePaths)`** — creates a trie from a list of paths that are chained sequentially.

**`Trie<T>.search(String keyword)`** — traverses the trie character-by-character and returns a `List<T>` of all data found along the way.

**`TriePath<T>.withData(T data)`** — creates a path entry carrying data.

**`TriePath<T>.withoutData()`** — creates a path entry without data (intermediate node).

**`TriePath<T>.addSynonym(String synonym)`** — adds a synonym string to the path. Multiple synonyms can be added via method chaining.

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.
