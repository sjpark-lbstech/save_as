
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:save_as/data/user_data.dart';

class AccountManager{
  AccountManager._internal();

  static final AccountManager _instance = AccountManager._internal();
  factory AccountManager() => _instance;

  FirebaseUser _firebaseUser;
  UserData _userData;
  String _uid;
  String _name;
  String _email;

  String get uid => _uid;
  String get email => _email;
  String get name => _name;
  UserData get userData => _userData;
  bool get isAuth => _firebaseUser != null;
  FirebaseAuth get auth => FirebaseAuth.instance;

  /// 구글 로그인
  /// 로그인 성공시 true 반환, 실패시 false 반환.
  Future<bool> signInWithGoogle() async{
    if (_userData != null) signOut();

    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    FirebaseUser firebaseUser;
    await auth.signInWithCredential(credential).then((AuthResult result){
      firebaseUser = result.user;
    });

    if (firebaseUser != null){
      assert(firebaseUser.displayName != null);
      assert(googleUser.email != null);
      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      _firebaseUser = firebaseUser;
      _uid = _firebaseUser.uid;
      _name = _firebaseUser.displayName;
      _email = googleUser.email;

      return true;
    }else{
      return false;
    }

  }

  void signOut(){
    _firebaseUser = null;
    _userData = null;
    _uid = null;
    _name = null;
    _email = null;
  }

}
