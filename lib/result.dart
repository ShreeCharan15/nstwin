import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'back.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {


  Widget ContentPane( paths){

    Map<String, dynamic> k=jsonDecode(paths);
    List<File> files=k.values.map((e) => File(e)).toList();
    List<Widget> li=files.map((e) => Center(child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.file(e,height: 300,),
          Flexible(child: Text(e.uri.pathSegments.last)),
        ],
      ),
    ))).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 400,
          child: Row(
            children: [
              Flexible(child: li[0]),
              Flexible(child: li[1]),
              Flexible(child: li[2])
            ],
          ),
        ),
        Container(
          height: 400,
          child: Row(
            children: [
              Flexible(child: li[3]),
              Flexible(child: li[4]),
              Flexible(child: li[5])
            ],
          ),
        ),
        Container(
          height: 400,
          child: Row(
            children: [
              Flexible(child: li[6]),
              Flexible(child: li[7]),
              Flexible(child: li[8])
            ],
          ),
        ),
        Container(
          height: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              li[9],
              li[10],
            ],
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Back>(context);
    List<Tab> tabs=provider.transformedPaths.keys.map((e) => Tab(text: e,)).toList();
    List<Widget> content=provider.transformedPaths.values.map((e) => ContentPane(e)).toList();
    List<Widget> loadingWidget=provider.loading?[
      const Text("Transforming.."),
      LinearProgressIndicator(
        // value: controller.value,
        value: provider.progress,
        semanticsLabel: 'Linear progress indicator',
      ),
    ]:[];


    return DefaultTabController(
      length: tabs.length,

      child: Column(
        children: [
          const SizedBox(height: 10,),
          ...loadingWidget,
          const SizedBox(height: 10,),
          TabBar(
            tabs: tabs,
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
          ),
          Container(
            width: MediaQuery.of(context).size.width-100,
              height: 1800,
              child: TabBarView(children: content))
        ],
      ),
    );
  }
}
