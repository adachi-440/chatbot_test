import 'dart:io';

import 'package:chatbot_test/entity/chat_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ChatBotModel extends ChangeNotifier {
  List<String> _options = [];
  int _selectedIndex = 0;
  List<ChatText> _chatTextList = [];
  File? _file;
  String _url = "";
  String _content = "";
  String _detail = "";
  String _name = "";
  String _address = "";
  String _email = "";
  String _phone = "";

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get url => _url;

  set url(String value) {
    _url = value;
    notifyListeners();
  }

  String get content => _content;

  set content(String value) {
    _content = value;
    notifyListeners();
  }

  String get detail => _detail;

  set detail(String value) {
    _detail = value;
    notifyListeners();
  }

  File? get file => _file;

  List<String> get options => _options;

  int get selectedIndex => _selectedIndex;

  List<ChatText> get chatTextList => _chatTextList;

  String get address => _address;

  set address(String value) {
    _address = value;
    notifyListeners();
  }

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  ChatBotModel() {
    ChatText chat1 = ChatText(content: "こんにちは！この度は、ご利用頂きありがとうございます。", isChatBot: true);
    ChatText chat2 = ChatText(content: "ご希望の内容はどちらですか？", isChatBot: true);
    _chatTextList.add(chat1);
    _chatTextList.add(chat2);
    _options.add('誹謗中傷に該当するか知りたい');
    _options.add('投稿を削除したい');
    _options.add('弁護士に相談したい');
    notifyListeners();
  }

  void selectOption(String option) async {
    ChatText chat1 = ChatText(content: option, isChatBot: false);
    _chatTextList.add(chat1);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    late ChatText chat2;
    if (option == '誹謗中傷に該当するか知りたい') {
      // todo 画像をアップロードして違法性診断を行う
      _selectedIndex = 1;
      chat2 = ChatText(content: "対象の画像をアップロードしてください。", isChatBot: true);
    } else if (option == '投稿を削除したい') {
      // todo 該当URLとスクリーンショット等の証拠を提出
      _selectedIndex = 2;
      chat2 = ChatText(content: "状況の整理をしたいので以下に入力してください。", isChatBot: true);
    } else {
      // todo 状況の整理
      _selectedIndex = 3;
      chat2 = ChatText(content: "相談内容を以下に入力してください。", isChatBot: true);
    }
    _chatTextList.add(chat2);
    _options = [];
    notifyListeners();
  }

  void uploadPicture() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _file = File(pickedFile.path);
        print('test');
        notifyListeners();
      }
    } on PlatformException catch (err) {
      print(err);
    }
  }
}
