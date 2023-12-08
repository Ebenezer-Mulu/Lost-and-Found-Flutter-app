import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInwithGoogle() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    // auth details from request

    final GoogleSignInAuthentication gAuth = await guser!.authentication;

    // credential for user

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // sign in

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
