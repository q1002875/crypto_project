import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';

class AccountPrivacy extends StatelessWidget {
  final List<String> privacyPolicyContents = [
    '# "Your Application Name" respects your privacy and is committed to protecting your personal data. This privacy policy will inform you as to how we handle your personal data and explain your privacy rights.\n\n',
    '## What information do we collect?\n\nWhen you use our application, we may collect the following information:\n\n1. Information you give us, such as your name, Google information.\n2. Usage information, such as your behavior on our application.\n',
    '### How do we use your information?\n\nWe use your information to provide, improve, and customize our services.\n\n',
    '#### Who do we share your information with?\n\nUnless we have your permission, we will not share your personal data with third parties. We may share your information with our service providers to assist us in providing and improving our services.\n\n',
    '##### Your Rights\n\nYou have the right to access, correct or delete your personal data at any time. You can also choose not to receive our email advertisements.\n\n',
    '###### How to contact us\n\nIf you have any questions about this privacy policy, please contact us at: q1002875@gmail.com\n\n',
  ];

  AccountPrivacy({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // 這裡的 Icon 可以自行更換
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            body: ListView.builder(
              itemCount: privacyPolicyContents.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: CustomText(
                      textColor: Colors.black,
                      align: TextAlign.start,
                      textContent: privacyPolicyContents[index],
                    ));
              },
            )));
  }
}






//  Text(
//                   '## "您的應用名稱" 尊重您的隱私權並致力於保護您的個人資料。該隱私政策將告訴您我們如何處理您的個人資料，並解釋您的隱私權。\n\n',
//                 ),
//                 Text('### 我們收集什麼資訊？\n\n'
//                     '當您使用我們的應用程式時，我們可能會收集以下資訊：\n\n'
//                     '1. 您提供給我們的資訊，例如您的名字、google資訊。\n'
//                     '2. 您的使用資訊，例如您在我們的應用程式上的行為。\n'),
//                 Text(
//                   '### 我們如何使用您的資訊？\n\n'
//                   '我們使用您的資訊來提供、改進和定製我們的服務。\n\n',
//                 ),
//                 Text(
//                   '### 我們與誰分享您的資訊？\n\n'
//                   '除非得到您的許可，否則我們不會將您的個人資料分享給第三方。我們可能會將您的資訊分享給我們的服務提供商，以便他們幫助我們提供和改進我們的服務。\n\n',
//                 ),
//                 Text(
//                   '### 你的權利\n\n'
//                   '您有權隨時訪問、更正或刪除您的個人資料。您也可以選擇不接受我們的電郵廣告。\n\n',
//                 ),
//                 Text(
//                   '### 如何聯繫我們\n\n'
//                   '如果您有任何關於此隱私政策的問題，請聯繫我們：q1002875@gmail.com\n\n',
//                 ),