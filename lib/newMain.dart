import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_fb_flutter/ProfileScreen.dart';
import 'package:login_fb_flutter/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MynewApp());
}

class MynewApp extends StatelessWidget {
  const MynewApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
    FirebaseApp firebaseApp =   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  static Future<UserCredential> googleSignin() async {
    UserCredential? user;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context){
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
          const Text("Login to the app",style: TextStyle(fontSize: 56.0),),
          const SizedBox(height: 44.0,),
          TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "enter your mail id",
                  prefixIcon: Icon(Icons.mail, color: Colors.black,)
              )
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: "enter your password",
                prefixIcon: Icon(Icons.lock, color: Colors.black,)
            ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          const Text("forgot password?",style: TextStyle(color: Colors.blue),),
          const SizedBox(
            height: 56.0,
          ),
          const Text("this is a sample text", style:TextStyle(color: Colors.black),),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.blue,
              onPressed: () async{
                UserCredential? user = await googleSignin();
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



