import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverphoto;
  const ChatPage({super.key, required this.receiverId, required this.receiverName, required this.receiverphoto});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final messageController = TextEditingController();

  void sendMessage() async{
    if(messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('chats').add({
      'senderId': currentUser!.uid,
      'receiverId': widget.receiverId,
      'text': messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });
    messageController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.receiverphoto),
            ),
            SizedBox(width: 8,),
            Text(widget.receiverName)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').orderBy('timestamp', descending: false).snapshots(), 
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }
                final messages = snapshot.data!.docs.where((doc){
                  final senderId = doc['senderId'];
                  final receiverId = doc['receiverId'];
                  return (senderId == currentUser!.uid && receiverId == widget.receiverId) || 
                  (senderId == widget.receiverId && receiverId == currentUser!.uid);
                }).toList();
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index){
                    final msg = messages[index];
                    final isMe =msg['senderId'] == currentUser!.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Text(msg['text']),
                      ),
                    
                    );
                    
                  }
                );
                

              }
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      
                    ),
                    
                  ),
                  
                ),
                SizedBox(width: 8,),
                IconButton(
                  onPressed: sendMessage, 
                  icon: Icon(Icons.send)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}