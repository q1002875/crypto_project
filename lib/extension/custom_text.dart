import '../common.dart';

class CustomText extends StatelessWidget {
  final String textContent;
  final double fontSize;
  final Color textColor;
  final TextAlign align;
  const CustomText(
      {Key? key,
      required this.textContent,
      this.fontSize = 16,
      this.textColor = Colors.white,
      this.align = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent,
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize, // 字体大小
        fontWeight: FontWeight.bold, // 字体粗细
        color: textColor, // 字体颜色
        letterSpacing: 1.5, // 字母间距
        wordSpacing: 5.0, // 单词间距
        decorationStyle: TextDecorationStyle.dashed, // 装饰样式
      ),
    );
  }
}
