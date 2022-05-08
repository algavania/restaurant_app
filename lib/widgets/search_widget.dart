import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextFormField(
                cursorColor: Colors.black,
                controller: controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  icon: const Icon(CupertinoIcons.search, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}