## 0.1.1

- Add `TrieResult<T>` class with `matched` and `remaining` fields
- Change `Trie.search` return type from `List<T>` to `TrieResult<T>`
- Add `hasData` and `isFullMatch` convenience getters

## 0.1.0

- Generic Trie data structure with type parameter `T`
- Synonym-based path definition via `TriePath`
- Sequential path chaining for compound keyword search
- Character-by-character prefix search using Unicode runes
