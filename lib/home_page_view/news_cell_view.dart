import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/image_cubit_cubit.dart';
import '../extension/custom_text.dart';

class NewsCellView extends StatelessWidget {
  final String dateTime;
  final String imageUrl;
  final String titleText;
  const NewsCellView(this.imageUrl, this.titleText, this.dateTime, {super.key});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(dateTime);
    // String formattedDate =  DateFormat("MM-dd'").format(date);
    context.read<ImageCubit>().loadImage(imageUrl);
    return Column(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 1,
              child: 
              CachedNetworkImage(
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                height:100,
                width: 100,
               errorWidget: (context, url, error) =>
                      Container(color: Colors.white,)

              ),
            ),
            Flexible(
                flex: 2,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      height: 100,
                      color: Colors.white,
                      child: CustomText(
                        textContent: titleText,
                        textColor: Colors.black,
                        align: TextAlign.left,
                      ),
                    ),
                    Positioned(
                        right: 2,
                        bottom: 0,
                        child: SizedBox(
                          height: 20,
                          width: 80,
                          child:  CustomText(
                              textContent: '${date.month}/${date.day}',
                              textColor: Colors.grey),
                        ))
                  ],
                ))
          ],
        ),
        const Divider(
          height: 1,
        )
      ],
    );
  }
}
