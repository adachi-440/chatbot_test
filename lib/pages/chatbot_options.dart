import 'dart:io';

import 'package:chatbot_test/pages/chatbot_input_form.dart';
import 'package:chatbot_test/viewmodel/chatbot_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatBotOptions extends StatelessWidget {
  const ChatBotOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();
    return model.options.isNotEmpty

        ? Container(
            color: Color(0xFFE5E5E5),
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: model.options
                    .map((option) => Padding(
                          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            child: ElevatedButton(
                              onPressed: () {
                                model.selectOption(option);
                              },
                              child: Text(
                                option,
                                style: TextStyle(color: Colors.black),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        : ChatBotInputForm();
  }
}
