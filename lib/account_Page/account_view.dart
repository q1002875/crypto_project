import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_model/user_infoModel.dart';
import '../extension/gobal.dart';
import '../routes.dart';
import 'login/bloc/login_bloc.dart';

class AccountPage extends StatefulWidget {
  bool needtologin;
  AccountPage({super.key, this.needtologin = false});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AuthenticationBloc _authBloc;
  bool _login = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark mode for status bar
    ));
    // List<String> systemList = ['訂閱管理', '隱私權政策', '關於', '意見回饋', '申請刪除帳號', '登出帳號'];
    final Map<String, String> systemMap = {
      'Privacy Policy': Routes.accountPrivacy,
      'About': Routes.accoundAbout,
      'Feedback': 'Routes.accountEmail',
      'Delete Account': '/deleteAccount',
      'Log Out': '/logout',
    };

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Center(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        color: Colors.blueGrey,
                        child: _buildContent(context, state),
                      )),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: systemMap.length,
                        itemBuilder: (context, index) {
                          final List<MapEntry<String, String>> entriesList =
                              systemMap.entries.toList();
                          final MapEntry<String, String> entry =
                              entriesList[index];
                          return index != systemMap.length - 1
                              ? GestureDetector(
                                  onTap: () {
                                    if (entry.key == 'Feedback') {
                                      _sendFeedbackEmail();
                                    } else if (entry.key == 'Delete Account') {
                                      _authBloc.add(LogoutEvent());
                                    } else {
                                      Navigator.pushNamed(context, entry.value);
                                    }
                                  },
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors
                                                .grey, // Change this color as you like
                                            width:
                                                1, // Change this width as you like
                                          ),
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: screenHeight / 8,
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const ClipOval(
                                              child: Icon(
                                            Icons.album_sharp,
                                            color: Colors.blueGrey,
                                          )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomText(
                                            textContent: entry.key.toString(),
                                            textColor: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ],
                                      )),
                                )
                              : _login
                                  ? Container(
                                      padding: const EdgeInsets.all(15),
                                      child: GestureDetector(
                                          onTap: () {
                                            _authBloc.add(LogoutEvent());
                                          },
                                          child: CustomText(
                                            align: TextAlign.center,
                                            fontSize: 18,
                                            textContent: entry.key,
                                            textColor: Colors.red,
                                          )))
                                  : Container();
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        widget.needtologin
            ? Positioned(
                top: 10,
                left: 5,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  // color: Colors.green,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_sharp)),
                ),
              )
            : Container()
      ],
    )));
  }

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authBloc.add(CheckisMember());
  }

  Widget _buildContent(BuildContext context, AuthenticationState state) {
    switch (state.runtimeType) {
      case AuthenticationLoading:
        return const Center(
          child: ShimmerBox(
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        );
      case AuthenticatedisMember:
        final isMember = (state as AuthenticatedisMember).isMember;
        final user = (state).user;
        if (isMember) {
          return _buildMemberView(user!);
        } else {
          return _buildLoginView();
        }
      case AuthenticatedState:
        final user = (state as AuthenticatedState).user;
        return _buildMemberView(user);

      case AuthenticationLoginOut:
        return _buildLoginView();

      case UnauthenticatedState:
        return _buildLoginView();

      default:
        return _buildLoginView();
    }
  }

  Widget _buildLoginView() {
    _login = false;
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 10),
            const CustomText(
              textContent: '歡迎加入 加密報',
              fontSize: 24,
              textColor: Colors.black,
            ),
            ElevatedButton(
              onPressed: () {
                _authBloc.add(LoginEvent());
              },
              child: const Text('Google登入'),
            )
          ],
        ));
  }

  Widget _buildMemberView(User user) {
    _login = true;
    return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        direction: Axis.vertical,
        children: [
          const SizedBox(
            height: 10,
          ),
          Flexible(
              flex: 1,
              child: Container(
                // color: Colors.pink,
                child: CustomText(
                  textContent: user.displayName,
                  fontSize: 16,
                  textColor: Colors.white,
                ),
              )),
          Flexible(
              flex: 4,
              child: Container(
                  // color: Colors.green,
                  child: Flex(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.vertical,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: screenWidth / 4.5,
                        height: screenWidth / 4.5,
                        child: CachedNetworkImage(
                          width: screenWidth / 4.5,
                          height: screenWidth / 4.5,
                          placeholder: (context, url) => const ShimmerBox(),
                          imageUrl: user.photoUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person_rounded),
                        ),
                      ),
                    ),
                  ),

                  // const SizedBox(
                  //   width: 10,
                  // ),
                  const CustomText(
                    textContent: 'Crypto Member',
                    textColor: Colors.white,
                    fontSize: 14,
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       print('個人檔案');
                  //       _authBloc.add(LogoutEvent());
                  //     },
                  //     child: const CustomText(
                  //       textContent: '個人檔案>',
                  //       textColor: Colors.white,
                  //       fontSize: 14,
                  //       align: TextAlign.right,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              )

                  // child: const Row(),
                  )),
          // Flexible(
          //     flex: 3,
          //     child: Container(
          //         // color: Colors.red,
          //         ))
        ]);
  }

  void _sendFeedbackEmail() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'q1002875@gmail.com',
        queryParameters: {
          'subject': 'App Feedback',
          'body': 'Hi Developer,\n\nI have some feedback...'
        });

    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch ${emailLaunchUri.toString()}';
    }
  }
}
