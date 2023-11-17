import 'package:iziFile/ui/cards/white_card.dart';
import 'package:iziFile/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';

class BlankView extends StatefulWidget {
  @override
  _BlankViewState createState() => _BlankViewState();
}

class _BlankViewState extends State<BlankView> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _output = [];
  final _scrollController = ScrollController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Terminal View', style: CustomLabels.h1),
          SizedBox(height: 10),
          WhiteCard(
            title: 'Flutter Terminal',
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _output.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _output[index],
                        style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.green),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[800],
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'flutter@demo:~\$ ',
                        style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            color: Colors.green),
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _controller,
                          onFieldSubmitted: (value) {
                            _processCommand(value);
                            _controller.clear();
                            focusNode.requestFocus();
                          },
                          style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 16,
                              color: Colors.green),
                          cursorColor: Colors.green,
                          decoration: InputDecoration.collapsed(
                              hintText: '', border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _processCommand(String command) {
    setState(() {
      bool primrera = true;

      if (primrera == true) {
        _output.add('flutter@demo:~\$ $command');
        primrera = false;
      }
      if (command == 'clear') {
        _output.clear();
      }
      if (command == 'ls') {
        _output.add(
            'Descargas  Documentos  Escritorio  Imágenes  linux-6.5.7  Música  Plantillas  Público  Vídeos');
      }

      if (command == 'ls Escritorio') {
        _output.add('leeme.txt  script.js');
      }
      // Auto-scroll to the bottom
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }
}
