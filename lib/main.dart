import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocwebview/graphql_op/cl_graphql_client.dart';
import 'package:pocwebview/repositories/main/main_repository.dart';
import 'package:pocwebview/screens/main/provider/main.dart';
import 'package:pocwebview/screens/main/ui/main.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: myTheme(),
      home: ChangeNotifierProvider<MainProvider>(
        create: (context) => MainProvider(MainRepository(client: ClGraphqlClient().init())),
        child: MainPage(),
      ),
    );
  }
}

ThemeData myTheme() {
  return ThemeData(
    primarySwatch: Colors.blueGrey,
    primaryColor: Colors.grey,
    colorScheme: ColorScheme.light(onSurface: Colors.grey),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  List<String> urls = [
    'https://mattx-store.myshopify.com',
  ];

  void loadUrl(String url, Completer<WebViewController> completer) async {
    final c = await completer.future;
    c.loadUrl(url, headers: <String, String>{});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        child: WebView(
          initialUrl: urls[0],
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller.complete(controller);
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          loadUrl('', _controller);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int pos) {
          final url = urls[pos];
          setState(() {
            _selectedIndex = pos;
          });
          loadUrl(url, _controller);
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              activeIcon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeIcon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ),
    );
  }
}
