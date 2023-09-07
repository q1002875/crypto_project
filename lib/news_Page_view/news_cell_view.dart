import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/image_cubit_cubit.dart';
import '../extension/ShimmerText.dart';
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
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.only(left: 3),
                  child: CachedNetworkImage(
                      placeholder: (context, url) => const ShimmerBox(),
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                      height: 100,
                      width: 100,
                      errorWidget: (context, url, error) => Container(
                            color: Colors.white,
                          )),
                )),
            Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(3),
                      alignment: Alignment.centerLeft,
                      height: 100,
                      color: Colors.white,
                      child: titleText.characters.length > 125
                          ? ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                CustomText(
                                  textContent: '$titleText。',
                                  textColor: Colors.black,
                                  align: TextAlign.left,
                                  fontSize: 14,
                                ),
                              ],
                            )
                          : CustomText(
                              textContent: '$titleText。',
                              textColor: Colors.black,
                              align: TextAlign.left,
                              fontSize: 14,
                            ),
                    ),
                    Positioned(
                        right: 2,
                        bottom: 0,
                        child: SizedBox(
                          height: 20,
                          width: 40,
                          child: CustomText(
                              align: TextAlign.right,
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
