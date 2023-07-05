import '../common.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerBox({
    super.key,
    this.width = 200.0,
    this.height = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
