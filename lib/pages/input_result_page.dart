import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:chatbot_test/entity/input_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class InputResultPage extends StatelessWidget {
  final int selectedIndex;
  final InputData data;

  const InputResultPage({Key? key, required this.selectedIndex, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // todo selectIndexごとに表示させる画面を変える
    /*
      1：違法性の判断を行う画面
      2：削除請求の書類を作成する画面
      3：証拠の表示と弁護士一覧の画面
     */
    if (selectedIndex == 1) {
      return _IllegalJudge();
    } else if (selectedIndex == 2) {
      return _CreateDocument();
    } else if (selectedIndex == 3) {
      return _LawyerList(
        data: data,
      );
    } else {
      return Container();
    }
  }
}

class _IllegalJudge extends StatelessWidget {
  const _IllegalJudge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const listItem = ["過去に不倫していると言われた事例", "過去に逮捕されたていたことを晒された事例", "コロナにかかったことを晒された事例"];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "違法性診断",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('違法性診断中です'),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFed2d2d),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                          child: Text(
                            'この投稿は誹謗中傷に該当する可能性があります',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 36),
                      child: Image.asset(
                        'assets/result.png',
                        width: 200,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 36),
                        child: Text('・〇〇さんと明確な主語が存在している\n・「逮捕された」という社会的評価を下げるような表現が利用されている')),
                    Text(
                      '類似の事例',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listItem.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10.0,
                                    // has the effect of softening the shadow
                                    spreadRadius: 0.2,
                                    // has the effect of extending the shadow
                                    color: Colors.black26,
                                    offset: Offset(0, 5))
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(listItem[index]),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "削除請求を行う",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF5e7ff7),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "弁護士に相談する",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF5e7ff7),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _CreateDocument extends StatefulWidget {
  const _CreateDocument({Key? key}) : super(key: key);

  _CreateDocumentState createState() => _CreateDocumentState();
}

class _CreateDocumentState extends State<_CreateDocument> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  final AsyncMemoizer memoizer = AsyncMemoizer();

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = "http://www.isplaw.jp/p_form.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    await Future.delayed(const Duration(seconds: 2));

    return completer.future;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "削除請求書類の作成",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save_alt,
                color: Colors.black,
              ),
              onPressed: () async {
                // await canLaunch(widget.url!) ? await launch(widget.url!) : throw 'Could not launch ${widget.url}';
              })
        ],
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: memoizer.runOnce(() async {
          return await createFileOfPdfUrl();
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('書類作成中です'),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    PDFView(
                      filePath: snapshot.data.path,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: true,
                      pageSnap: true,
                      defaultPage: currentPage!,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation: false,
                      // if set to true the link is handled in flutter
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        print('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                    errorMessage.isEmpty
                        ? !isReady
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container()
                        : Center(
                            child: Text(errorMessage),
                          )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _LawyerList extends StatelessWidget {
  final InputData data;

  const _LawyerList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const gridItem = [
      {"name": "足立智紀 弁護士", "office_name": "足立弁護士事務所", "address": "愛知県津島市莪原町西屋敷28"},
      {"name": "足立智紀 弁護士", "office_name": "足立弁護士事務所", "address": "愛知県津島市莪原町西屋敷28"},
      {"name": "足立智紀 弁護士", "office_name": "足立弁護士事務所", "address": "愛知県津島市莪原町西屋敷28"},
      {"name": "足立智紀 弁護士", "office_name": "足立弁護士事務所", "address": "愛知県津島市莪原町西屋敷28"}
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "弁護士への相談",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // todo 証拠の表示と相談内容
                        Container(height: 150, child: Image.file(data.file!)),
                        Padding(
                          padding: const EdgeInsets.only(top: 48, bottom: 24, right: 48, left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("URL",
                                  style: TextStyle(
                                      fontFamily: 'Hiragino Kaku Gothic Pro',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16)),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(data.url!,
                                      style: TextStyle(
                                          fontFamily: 'Hiragino Kaku Gothic Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFF707070),
                          height: 1, // 線の幅
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 24, right: 48, left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("相談の内容",
                                  style: TextStyle(
                                      fontFamily: 'Hiragino Kaku Gothic Pro',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16)),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(data.content!,
                                      style: TextStyle(
                                          fontFamily: 'Hiragino Kaku Gothic Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFF707070),
                          height: 1, // 線の幅
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 24, right: 48, left: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("詳細",
                                  style: TextStyle(
                                      fontFamily: 'Hiragino Kaku Gothic Pro',
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16)),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(data.detail!,
                                      style: TextStyle(
                                          fontFamily: 'Hiragino Kaku Gothic Pro',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFF707070),
                          height: 3, // 線の幅
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 16),
                          child: Text(
                            '以下の弁護士から相談ができます',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),

                        // todo 弁護士一覧表示
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: gridItem.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10.0,
                                          // has the effect of softening the shadow
                                          spreadRadius: 0.2,
                                          // has the effect of extending the shadow
                                          color: Colors.black26,
                                          offset: Offset(0, 5))
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                                        child: Text(
                                          gridItem[index]["name"]!,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(gridItem[index]["office_name"]!),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color: Colors.grey,
                                            ),
                                            Flexible(child: Text(gridItem[index]["address"]!)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            style: TextButton.styleFrom(
                                              backgroundColor: Color(0xFF5e7ff7),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.message,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                                Text('相談する')
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  )),
            );
          }
        },
      ),
    );
  }
}
