import 'package:chat_app/login/page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout(BuildContext context) async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out successfully")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out error")));
    }
  }
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Text("Menu", style: TextStyle(fontSize: 24),),),
          InkWell(
            onTap:() => logout(context),
            child: ListTile(
              title: Text("Logout"),
            ),
          )
        ],
      ), 
    );
  }
}