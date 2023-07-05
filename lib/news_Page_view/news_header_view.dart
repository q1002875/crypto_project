import '../common.dart';
import '../extension/custom_text.dart';
import '../extension/image_url.dart';

class NewsHeaderView extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String image_url;
  final String titleText;
  const NewsHeaderView(this.image_url, this.titleText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: NetworkImageWithPlaceholder(
            imageUrl: image_url,
            width: double.infinity,
            height: 200,
          ),
        ),
        Positioned(
          top: 130,
          left: 10,
          bottom: 0,
          right: 10,
          child: Center(
              child: CustomText(
            textContent: titleText,
            textColor: Colors.white,
            fontSize: 20,
          )),
        )
      ],
    );
  }
}
