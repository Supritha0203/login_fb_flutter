import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_fb_flutter/ProfileScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initializing firebase
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  static Future<User?> loginWithEmailPassword({required String email,required String password, required BuildContext context}) async{
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try{
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    user= userCredential.user;
  }on FirebaseAuthException catch(e){
    if(e.code == "user-not-found"){
      print("no user found");
    }
  }
  return user;
  }
  @override
  Widget build(BuildContext context) {
    //text field controllers
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Text("Suppy App",style: TextStyle(fontSize: 28.0),),
          Text("Login to the app",style: TextStyle(fontSize: 56.0),),
          SizedBox(height: 44.0,),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "enter your mail id",
              prefixIcon: Icon(Icons.mail, color: Colors.black,)
            )
          ),
          SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "enter your password",
                prefixIcon: Icon(Icons.lock, color: Colors.black,)
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text("forgot password?",style: TextStyle(color: Colors.blue),),
          SizedBox(
            height: 56.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.blue,
              onPressed: () async{
              User? user = await loginWithEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
              print(user);
              if(user!= null){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfileScreen()));
              }
            },
              child: Text("Login",style: TextStyle(color: Colors.white),),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.9)),

            ),
          ),
        ],
      ),
    );
  }
}
