import 'package:chatbot_test/entity/input_data.dart';
import 'package:chatbot_test/pages/input_result_page.dart';
import 'package:chatbot_test/viewmodel/chatbot_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBotInputForm extends StatelessWidget {
  const ChatBotInputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();
    if (model.selectedIndex == 1) {
      return _PictureUpload();
    } else if (model.selectedIndex == 2) {
      return _PictureAndURL();
    } else if (model.selectedIndex == 3) {
      return _AllData();
    } else {
      return Container();
    }
  }
}

class _PictureUpload extends StatelessWidget {
  const _PictureUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();

    return Container(
      color: Color(0xFFE5E5E5),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(children: [
          model.file == null
              ? GestureDetector(
                  onTap: () async {
                    model.uploadPicture();
                  },
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.upload_sharp,
                        size: 36,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.file(model.file!)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              child: ElevatedButton(
                onPressed: () {
                  InputData data = InputData(file: model.file!);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InputResultPage(selectedIndex: model.selectedIndex, data: data), // 遷移先はココ
                      ));
                },
                child: Text(
                  "送信",
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
        ]),
      ),
    );
  }
}

class _PictureAndURL extends StatelessWidget {
  const _PictureAndURL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();

    return Expanded(
      child: Container(
        color: Color(0xFFE5E5E5),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '名前',
                  ),
                  onChanged: (value) {
                    model.name = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '住所',
                  ),
                  onChanged: (value) {
                    model.address = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'メールアドレス',
                  ),
                  onChanged: (value) {
                    model.email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '電話番号',
                  ),
                  onChanged: (value) {
                    model.phone = value;
                  },
                ),
              ),
              model.file == null
                  ? GestureDetector(
                      onTap: () async {
                        model.uploadPicture();
                      },
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.upload_sharp,
                            size: 36,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.file(model.file!)),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '該当URLを入力してください',
                  ),
                  onChanged: (value) {
                    model.url = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: ElevatedButton(
                    onPressed: () {
                      InputData data = InputData(
                          file: model.file!,
                          url: model.url,
                          name: model.name,
                          address: model.address,
                          email: model.email,
                          phone: model.phone);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InputResultPage(selectedIndex: model.selectedIndex, data: data), // 遷移先はココ
                          ));
                    },
                    child: Text(
                      "送信",
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
            ]),
          ),
        ),
      ),
    );
  }
}

class _AllData extends StatelessWidget {
  const _AllData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();

    return Expanded(
      child: Container(
        color: Color(0xFFE5E5E5),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                  hintText: '相談内容',
                ),
                onChanged: (value) {
                  model.content = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '詳細',
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    model.detail = value;
                  },
                ),
              ),
              model.file == null
                  ? GestureDetector(
                      onTap: () async {
                        model.uploadPicture();
                      },
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.upload_sharp,
                            size: 36,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.file(model.file!)),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '該当URLを入力してください',
                  ),
                  onChanged: (value) {
                    model.url = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 32,
                  child: ElevatedButton(
                    onPressed: () {
                      InputData data =
                          InputData(file: model.file!, url: model.url, content: model.content, detail: model.detail);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InputResultPage(selectedIndex: model.selectedIndex, data: data), // 遷移先はココ
                          ));
                    },
                    child: Text(
                      "送信",
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
            ]),
          ),
        ),
      ),
    );
  }
}
