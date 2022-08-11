import 'package:flow_graph/src/graph.dart';

enum OperationType { delete, create }

class Operation {
  Operation(
      {this.children = const [],
      required this.node,
      required this.operationType,
      required this.prevNodeId});
  OperationType operationType;
  GraphNode node;
  int prevNodeId;
  List<GraphNode> children;
}

class OperarionController {
  static const int maxOperationLength = 5;

  List<Operation> operations = [];

  addOperation(Operation operation) {
    if (operations.length == maxOperationLength) {
      operations.removeAt(0);
    }
    operations.add(operation);
  }

  undo(Graph g) {
    if (operations.isEmpty) {
      return;
    }
    final lastOperation = operations.removeLast();
    // print(lastOperation.children.length);
    if (lastOperation.operationType == OperationType.delete) {
      for (final n in g.nodes) {
        if (n.id == lastOperation.prevNodeId) {
          n.addNext(lastOperation.node);
          lastOperation.node.prevList.add(n);
          break;
        }
      }

      for (final c in lastOperation.children) {
        lastOperation.node.addNext(c);
        c.prevList.add(lastOperation.node);
      }
    } else {
      lastOperation.node.deleteSelf();
    }
  }
}
