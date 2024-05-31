import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers extends StatelessWidget {
  final double height;
  final double width;
  final double height1;
  final double width1;
  final int length;
  const Shimmers(
      {super.key,
      required this.width,
      required this.height,
      required this.width1,
      required this.height1,
      required this.length,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 15, right: 10),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 15),
            child: SizedBox(
              width: width1,
              height: height1,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Shimmers2 extends StatelessWidget {
  final double height;
  final double width;
  const Shimmers2(
      {super.key,
        required this.width,
        required this.height,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
