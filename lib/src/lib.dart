import 'package:graphs/graphs.dart';

class _GraphDependency {
  final Map<_DependencyNode, List<_DependencyNode>> nodes;

  _GraphDependency(this.nodes);
}

class _DependencyNode {
  final dynamic id;

  _DependencyNode(this.id);

  @override
  bool operator ==(Object other) => other is _DependencyNode && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$id';
}

class Provider {
  final Function provide;
  final List<dynamic> resolve;

  Provider({this.provide, this.resolve = const []});

  create([args]) {
    if (args == null) {
      return this.provide();
    }
    return this.provide(args);
  }
}

class _Module {
  final Map<dynamic, Provider> _data;
  Map<dynamic, dynamic> instances;

  _Module(data) : _data = Map.from(data) {
    this.instances = _parseData();
  }

  _parseData() {
    Map<_DependencyNode, List<_DependencyNode>> dependencyNodes = _prepareDependencyNodes();

    List<List<_DependencyNode>> dependencyComponents =
        _generateDependencyComponents(dependencyNodes);

    var instances = _generateInstances(dependencyComponents);

    return instances;
  }

  Map<dynamic, dynamic> _generateInstances(List<List<_DependencyNode>> dependencyComponents) {
    Map<dynamic, dynamic> instances = Map();

    dependencyComponents.forEach((dependencyNode) {
      dynamic type = dependencyNode.first.id;
      Provider resolver = _data[type];
      if (resolver.resolve.isEmpty) {
        instances.putIfAbsent(type, () => resolver.create());
      } else {
        Map<dynamic, dynamic> dependencies = Map();
        resolver.resolve.forEach((id) => dependencies[id] = instances[id]);
        instances.putIfAbsent(type, () => resolver.create(dependencies));
      }
    });

    return instances;
  }

  List<List<_DependencyNode>> _generateDependencyComponents(
      Map<_DependencyNode, List<_DependencyNode>> dependencyNodes) {
    var graphDep = _GraphDependency(dependencyNodes);

    var dependencyComponents = stronglyConnectedComponents<_DependencyNode>(
        graphDep.nodes.keys, (node) => graphDep.nodes[node]);
    return dependencyComponents;
  }

  Map<_DependencyNode, List<_DependencyNode>> _prepareDependencyNodes() {
    Map<_DependencyNode, List<_DependencyNode>> dependencyNodes = Map();

    _data.forEach((type, resolver) {
      var node = _DependencyNode(type);
      var dependencies = resolver.resolve.map((dependency) => _DependencyNode(dependency)).toList();
      dependencyNodes.putIfAbsent(node, () => dependencies);
    });
    return dependencyNodes;
  }
}

class Berry {
  _Module _module;
  static final Berry _singleton = new Berry._internal();

  static Berry get instance => _singleton;

  factory Berry([configuration]) {
    if (_singleton._module == null) {
      _singleton._module = new _Module(configuration);
    }
    return _singleton;
  }

  Map<dynamic, dynamic> get instances => _module.instances;

  Berry._internal();

  dynamic operator [](type) {
    return instances[type];
  }
}
