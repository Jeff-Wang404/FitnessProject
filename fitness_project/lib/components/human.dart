import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';

class HumanWidget extends StatefulWidget {
  const HumanWidget({super.key});

  @override
  State<HumanWidget> createState() => _HumanWidgetState();
}

class _HumanWidgetState extends State<HumanWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orange,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.red,
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 30,
                ),
                InkWell(
                  onTap: () {
                    print('Human');
                  },
                  child: Container(
                    color: Colors.blue,
                    width: SizeConfig.blockSizeHorizontal! * 30,
                    height: SizeConfig.blockSizeVertical! * 30,
                  ),
                ),
                Container(
                  color: Colors.green,
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 30,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.green,
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 30,
                ),
                Container(
                  color: Colors.red,
                  width: SizeConfig.blockSizeHorizontal! * 10,
                  height: SizeConfig.blockSizeVertical! * 30,
                )
              ],
            )
          ],
        ));
  }
}
