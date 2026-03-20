## 0.1.3

- Fix null check operator warning on nullable type parameter (pana static analysis)

## 0.1.2

- Fix LICENSE file format for pub.dev recognition (Apache 2.0)
- Sync README dependency version

## 0.1.1

- Add `TrieResult<T>` class with `matched` and `remaining` fields
- Change `Trie.search` return type from `List<T>` to `TrieResult<T>`
- Add `hasData` and `isFullMatch` convenience getters

## 0.1.0

- Generic Trie data structure with type parameter `T`
- Synonym-based path definition via `TriePath`
- Sequential path chaining for compound keyword search
- Character-by-character prefix search using Unicode runes
