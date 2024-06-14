import 'package:flutter/material.dart';
import 'package:learnspace/states.dart';
import 'package:provider/provider.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _textEditingController = TextEditingController();

  String _getHint(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);
    if (myStates.searchedQuestion != "") {
      return myStates.searchedQuestion;
    } else {
      return "Search here...";
    }
  }

  @override
  Widget build(BuildContext context) {
    final myStates = Provider.of<MyStates>(context);

    //Provider.of<MyStates>(context, listen: false).resetSearch();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.98,
          child: SearchBar(
            hintText: _getHint(context),
            onSubmitted: (query) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              findPost(_textEditingController.text, context);
            },
            controller: _textEditingController,
            onChanged: (query) =>
                findPost(_textEditingController.text, context),
            leading: const Icon(Icons.search),
          )),
    );
  }

  void findPost(String currentText, BuildContext context) {
    final myStates = Provider.of<MyStates>(context, listen: false);
    myStates.searchQuestion(currentText);
  }
}
