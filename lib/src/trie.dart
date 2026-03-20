/// A generic Trie (prefix tree) that supports sequential keyword search
/// with synonym-based path chaining.
///
/// Create a [Trie] by providing a list of [TriePath] entries. Each path can
/// carry data of type [T] and one or more synonym strings. The trie chains
/// the paths sequentially so that a search over a concatenated keyword string
/// collects all matched data along the way.
///
/// ```dart
/// var trie = Trie<String>.withInitialData(
///   List.of({
///     TriePath<String>.withData("ABC").addSynonym("abc"),
///     TriePath<String>.withData("ABCD").addSynonym("abcd"),
///   }),
/// );
///
/// trie.search("abcabcd"); // [ABC, ABCD]
/// ```
class Trie<T> {
  final _TrieRoot<T> _root;

  /// Creates a [Trie] from a list of [TriePath] entries.
  ///
  /// The paths are chained sequentially: after matching one path, the trie
  /// continues matching the next path from where the previous one ended.
  Trie.withInitialData(List<TriePath<T>> triePaths) : _root = _TrieRoot() {
    _root.insertPath(triePaths);
  }

  /// Searches the trie by traversing [keyword] character-by-character.
  ///
  /// Returns a [List<T>] of all data found at matching nodes along the path.
  /// If no matches are found, returns an empty list.
  List<T> search(String keyword) => _root.search(keyword);
}

/// Represents a path entry in a [Trie] with optional data and synonyms.
///
/// A [TriePath] defines one segment of the trie. It can carry data of type [T]
/// and have multiple synonym strings that all resolve to the same node.
///
/// ```dart
/// var path = TriePath<String>.withData("hello")
///   .addSynonym("hi")
///   .addSynonym("hey");
/// ```
class TriePath<T> {
  final List<String> _synonyms = [];
  T? _data;

  /// The list of synonym strings for this path.
  List<String> get synonyms => _synonyms;

  /// The data associated with this path, or `null` if none.
  T? get data => _data;

  /// Creates a [TriePath] carrying [_data].
  TriePath.withData(this._data);

  /// Creates a [TriePath] without any associated data.
  TriePath.withoutData();

  /// Adds a [synonym] string to this path.
  ///
  /// Returns `this` for method chaining.
  TriePath<T> addSynonym(String synonym) {
    _synonyms.add(synonym);
    return this;
  }
}

class _TrieRoot<T> {
  final root = _TrieNode<T>.ofRoot();

  List<T> search(String keyword) {
    _TrieNode<T>? node = root;
    List<T> dataFound = <T>[];

    for (var rune in keyword.runes) {
      var key = String.fromCharCode(rune);
      node = node!.get(key);
      if (node != null) {
        if (node.data != null) {
          dataFound.add(node.data!);
        }
      } else {
        break;
      }
    }

    return dataFound;
  }

  void insertPath(List<TriePath<T>> list) {
    var roots = <_TrieNode<T>>[];

    for (var value in list) {
      var root = _TrieNode<T>.ofRoot();
      for (var line in value.synonyms) {
        var node = root;
        for (var rune in line.runes) {
          var char = String.fromCharCode(rune);
          node = node.getOrCreate(char);
        }

        if (value.data != null) {
          node.assignData(value.data as T);
        }
      }
      roots.add(root);
    }

    var lastLeaves = [root];
    for (var root in roots) {
      for (var lastLeaf in lastLeaves) {
        lastLeaf.mergeNode(root);
      }
      lastLeaves = root.leafNodes;
    }
  }
}

class _TrieNode<T> {
  late final String _key;
  final Map<String, _TrieNode<T>> _map = <String, _TrieNode<T>>{};
  T? _data;

  _TrieNode.ofKey(this._key);

  _TrieNode.ofRoot() {
    _key = "";
  }

  String get key => _key;

  T? get data => _data;

  void assignData(T data) {
    _data = data;
  }

  _TrieNode<T>? get(String key) {
    return _map[key];
  }

  _TrieNode<T> getOrCreate(String key) {
    var node = _map[key];

    if (node == null) {
      _map[key] = (node = _TrieNode.ofKey(key));
    }

    return node;
  }

  void mergeNode(_TrieNode<T> node) {
    if (node.children.isEmpty) {
      return;
    }
    for (var thatChild in node.children) {
      var thisChild = _map[thatChild.key];
      if (thisChild == null) {
        _map[thatChild.key] = thatChild;
      } else {
        if (thatChild.data != null) {
          thisChild.assignData(thatChild.data as T);
        }
        thisChild.mergeNode(thatChild);
      }
    }
  }

  List<_TrieNode<T>> get leafNodes => _getLeafNodes();

  List<_TrieNode<T>> _getLeafNodes() {
    var list = <_TrieNode<T>>[];
    _getLeafNode(this, list);
    return list;
  }

  void _getLeafNode(_TrieNode<T> node, List<_TrieNode<T>> leafNodes) {
    if (node.children.isEmpty) {
      leafNodes.add(node);
      return;
    }

    for (var child in node.children) {
      _getLeafNode(child, leafNodes);
    }
  }

  List<_TrieNode<T>> get children => _map.values.toList(growable: false);
}
