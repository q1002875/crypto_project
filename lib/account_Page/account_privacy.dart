import 'package:flutter/material.dart';

class AccountPrivacy extends StatelessWidget {
  const AccountPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                '隱私政策',
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
            body: ListView(
              children: const [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '## "您的應用名稱" 尊重您的隱私權並致力於保護您的個人資料。該隱私政策將告訴您我們如何處理您的個人資料，並解釋您的隱私權。\n\n',
                ),
                Text('### 我們收集什麼資訊？\n\n'
                    '當您使用我們的應用程式時，我們可能會收集以下資訊：\n\n'
                    '1. 您提供給我們的資訊，例如您的名字、google資訊。\n'
                    '2. 您的使用資訊，例如您在我們的應用程式上的行為。\n'),
                Text(
                  '### 我們如何使用您的資訊？\n\n'
                  '我們使用您的資訊來提供、改進和定製我們的服務。\n\n',
                ),
                Text(
                  '### 我們與誰分享您的資訊？\n\n'
                  '除非得到您的許可，否則我們不會將您的個人資料分享給第三方。我們可能會將您的資訊分享給我們的服務提供商，以便他們幫助我們提供和改進我們的服務。\n\n',
                ),
                Text(
                  '### 你的權利\n\n'
                  '您有權隨時訪問、更正或刪除您的個人資料。您也可以選擇不接受我們的電郵廣告。\n\n',
                ),
                Text(
                  '### 如何聯繫我們\n\n'
                  '如果您有任何關於此隱私政策的問題，請聯繫我們：q1002875@gmail.com\n\n',
                ),
              ],
            )));
  }
}
