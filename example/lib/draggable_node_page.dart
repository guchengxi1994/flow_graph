import 'package:flow_graph/flow_graph.dart';
import 'package:flutter/material.dart';

class DraggableNodePage extends StatefulWidget {
  const DraggableNodePage({Key? key}) : super(key: key);

  @override
  _DraggableNodePageState createState() => _DraggableNodePageState();
}

class _DraggableNodePageState extends State<DraggableNodePage> {
  late GraphNode<FamilyNode> root;

  @override
  void initState() {
    root =
        GraphNode<FamilyNode>(data: FamilyNode(name: 'Family'), isRoot: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draggable Flow'),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  root.removeAllNext();
                });
              },
              child: const Text('重置'))
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                Draggable<GraphNodeFactory<FamilyNode>>(
                  data: GraphNodeFactory(
                      dataBuilder: () =>
                          FamilyNode(name: 'Child', singleChild: true)),
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: _singleOutNode(),
                  ),
                  feedback: Card(
                    color: Theme.of(context).backgroundColor,
                    elevation: 6,
                    child: _singleOutNode(),
                  ),
                ),
                const Divider(
                  height: 16,
                ),
                Draggable<GraphNodeFactory<FamilyNode>>(
                  data: GraphNodeFactory(
                      dataBuilder: () =>
                          FamilyNode(name: 'Child N', singleChild: false)),
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: _multiOutNode(),
                  ),
                  feedback: Card(
                    color: Theme.of(context).backgroundColor,
                    elevation: 6,
                    child: _multiOutNode(),
                  ),
                ),
                const Divider(
                  height: 16,
                ),
                Draggable<GraphNodeFactory<FamilyNode>>(
                  data: GraphNodeFactory(
                      dataBuilder: () => FamilyNode(
                          name: 'Child X',
                          singleChild: false,
                          multiParent: true)),
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: _multiParentNode(),
                  ),
                  feedback: Card(
                    color: Theme.of(context).backgroundColor,
                    elevation: 6,
                    child: _multiParentNode(),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 32,
          ),
          Expanded(
            child: DraggableFlowGraphView<FamilyNode>(
              root: root,
              willConnect: (node) {
                if (node.data?.singleChild == true) {
                  if (node.nextList.length == 1) {
                    return false;
                  } else {
                    return true;
                  }
                } else if (node.data != null && !node.data!.singleChild) {
                  return true;
                }
                return false;
              },
              willAccept: (node) {
                return node.data?.multiParent == true;
              },
              builder: (context, node) {
                return Container(
                  color: Colors.white60,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    (node.data as FamilyNode).name,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _singleOutNode() => Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.panorama_wide_angle),
            SizedBox(
              width: 16,
            ),
            Text('1 : 1')
          ],
        ),
      );

  Widget _multiOutNode() => Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.list),
            SizedBox(
              width: 16,
            ),
            Text('1 : n')
          ],
        ),
      );

  Widget _multiParentNode() => Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu),
            SizedBox(
              width: 16,
            ),
            Text('n : n')
          ],
        ),
      );
}

class FamilyNode {
  FamilyNode(
      {required this.name, this.singleChild = true, this.multiParent = false});

  String name;
  bool singleChild;
  bool multiParent;
}