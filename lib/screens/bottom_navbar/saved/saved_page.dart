import 'package:chat_bot_app/screens/bottom_navbar/chat/new_chat.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Saved',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: () {}, icon: CircleAvatar()),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewChatPage(
                        appTitle: "New Chat",
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8, top: 8, left: 10, right: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                isDarkTheme ? Colors.black : Colors.white,
                            child: Icon(
                              Icons.add,
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "New Chat",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.search))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
