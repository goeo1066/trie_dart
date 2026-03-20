class Trie<T> {
  final _TrieRoot<T> _root;

  Trie.withInitialData(List<TriePath<T>> triePaths) : _root = _TrieRoot() {
    _root.insertPath(triePaths);
  }

  List<T> search(String keyword) => _root.search(keyword);
}

class TriePath<T> {
  final List<String> _synonyms = [];
  T? _data;

  List<String> get synonyms => _synonyms;

  T? get data => _data;

  TriePath.withData(this._data);

  TriePath.withoutData();

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
