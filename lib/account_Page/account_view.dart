import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_model/user_infoModel.dart';
import '../extension/gobal.dart';
import 'login/bloc/login_bloc.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

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
    List<String> systemList = ['訂閱管理', '隱私權政策', '關於', '意見回饋', '申請刪除帳號', '登出帳號'];
    return Scaffold(body: SafeArea(
      child: Center(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                      color: const Color.fromARGB(255, 114, 161, 224),
                      child: _buildContent(context, state),
                    )),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: systemList.length,
                      itemBuilder: (context, index) {
                        return index != systemList.length - 1
                            ? Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors
                                          .grey, // Change this color as you like
                                      width: 1, // Change this width as you like
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
                                        child: Icon(Icons.album_sharp)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      textContent: systemList[index],
                                      textColor: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ],
                                )

                                // child: const Row(),
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
                                          textContent: systemList[index],
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
    ));
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
    return Flex(direction: Axis.vertical, children: [
      const SizedBox(
        height: 10,
      ),
      Flexible(
          flex: 3,
          child: Container(
            // color: Colors.pink,
            child: CustomText(
              textContent: user.displayName,
              fontSize: 16,
              textColor: Colors.black,
            ),
          )),
      Flexible(
          flex: 4,
          child: Container(
              // color: Colors.green,
              child: Flex(
            direction: Axis.horizontal,
            children: [
              const SizedBox(
                width: 10,
              ),
              ClipOval(
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ShimmerBox(),
                  imageUrl: user.photoUrl,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const CustomText(
                textContent: 'Crypto Member',
                textColor: Colors.black,
                fontSize: 14,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print('個人檔案');
                    _authBloc.add(LogoutEvent());
                  },
                  child: const CustomText(
                    textContent: '個人檔案>',
                    textColor: Colors.black,
                    fontSize: 14,
                    align: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          )

              // child: const Row(),
              )),
      Flexible(
          flex: 3,
          child: Container(
              // color: Colors.red,
              ))
    ]);
  }
}
