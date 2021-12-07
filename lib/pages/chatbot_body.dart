import 'package:chatbot_test/viewmodel/chatbot_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBotBody extends StatelessWidget {
  const ChatBotBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatBotModel>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: model.chatTextList.map((chat) {
            if(chat.isChatBot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF5e7ff7),
                    child: Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                ),
                  ),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 84,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(chat.content),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 84,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF5e7ff7),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(chat.content, style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }).toList()
        ),
      ),
    );
  }
}
