import 'package:chat_app/home/page/chat_page.dart';
import 'package:chat_app/home/widget/app_drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(title: Text("Chat Users"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(), 
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Error loading users"));
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index){
              final user = users[index];
              if(user.id == currentUser?.uid){
                return const SizedBox();
              }
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatPage(
                    receiverId: user.id,
                    receiverName: user['username'],
                    receiverphoto: user['photo'],
                  )));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user['photo'] ?? '?'),
                    
                  ),
                  title: Text(user['username'] ?? 'No name'),
                  subtitle: Text(user['email']),
                ),
              );
            }
          );

        }
      ),
    );
  }
}