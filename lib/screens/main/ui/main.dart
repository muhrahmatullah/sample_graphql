import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocwebview/screens/main/provider/main.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      print('fetch');
      await Provider.of<MainProvider>(context, listen: false).fetchRepo();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final provider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Github sample'),
      ),
      body: provider.repoResponse.data.isNotEmpty
          ? Container(
              child: ListView.builder(
                itemBuilder: (cxt, index) => ListTile(
                  title: Text(provider.repoResponse.data[index].name),
                ),
                itemCount: provider.repoResponse.data.length,
              ),
            )
          : provider.repoResponse.error
              ? Center(
                  child: Text(provider.repoResponse.message),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
