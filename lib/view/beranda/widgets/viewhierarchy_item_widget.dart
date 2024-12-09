import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class ViewhierarchyItemWidget extends StatelessWidget {
  const ViewhierarchyItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.h,
      child: Column(
        children: [
          SizedBox(
            height: 180.h,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRectangle21,
                  height: 180.h,
                  width: 240.h,
                  radius: BorderRadius.circular(10.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgPekalonganManggrovePark114180x280,
                  height: 180.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(10.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(right: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mangrove Park",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "Merupakan kawasan mangrove yang berfungsi sebagai ekowisata. Lokasi wisata ini berada di Kelurahan Kandang Panjang, Pekalongan.",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
