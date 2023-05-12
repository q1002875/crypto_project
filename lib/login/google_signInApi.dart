// class GoogleSignInApi {
//   static final _googleSignIn = GoogleSignIn();

//   static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

//   static Future<void> signOut() => _googleSignIn.signOut();

//   static Future<bool> isSignedIn() async {
//     final currentUser = _googleSignIn.currentUser;
//     return currentUser != null &&
//         await currentUser.authentication.isAccessTokenValid;
//   }

//   static Future<String?> getToken() async {
//     final currentUser = _googleSignIn.currentUser;
//     if (currentUser == null) {
//       return null;
//     }
//     final idToken = await currentUser.authentication.idToken;
//     return idToken;
//   }

//   static Future<void> init() async {
//     await Firebase.initializeApp();
//     final clientId = await FirebaseFunctions.instance
//         .httpsCallable('getClientId')()
//         .then((res) => res.data);
//     _googleSignIn.clientId = clientId;
//   }
// }
