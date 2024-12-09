import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

// ignore_for_file: must_be_immutable

class DestinationgridItemWidget extends StatelessWidget {
  DestinationgridItemWidget({Key? key, this.onTapColumnwisataalam, required String imagePaths}) : super(key: key);

  VoidCallback? onTapColumnwisataalam;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapColumnwisataalam?.call();
      },
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgWisataAlam,
            height: 62.h,
            width: double.maxFinite,
          ),
          SizedBox(height: 6.h),
          Text(
            "Wisata\nAlam",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleSmallWhiteA700,
          ),
        ],
      ),
    );
  }
}
