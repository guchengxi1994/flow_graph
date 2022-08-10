import 'package:flow_graph/src/graph.dart';

enum OperationType { delete, create }

class Operation {
  Operation(
      {this.children = const [],
      required this.node,
      required this.operationType});
  OperationType operationType;
  GraphNode node;
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

  undo() {
    if (operations.isEmpty) {
      return;
    }
    final lastOperation = operations.removeLast();
    if (lastOperation.operationType == OperationType.delete) {
      lastOperation.node.visible = true;
      for (final i in lastOperation.children) {
        i.visible = true;
      }
    } else {
      lastOperation.node.visible = false;
    }
  }
}
