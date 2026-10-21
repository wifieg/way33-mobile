import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  final double size;

  const BrandMark({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.navy,
            borderRadius: BorderRadius.circular(size * .3),
          ),
          child: Stack(
            children: [
              Center(
                  child: Text('W',
                      style: TextStyle(
                        fontFamily: 'Way33Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: size * .6,
                        height: 1,
                      ))),
              PositionedDirectional(
                end: size * .13,
                bottom: size * .15,
                child: Container(
                  width: size * .15,
                  height: size * .15,
                  decoration: const BoxDecoration(
                      color: Color(0xFF55D5B0), shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      );
}
