import 'package:flutter/cupertino.dart';
import 'package:polynomial/utils/size_config.dart';

class VSpacer extends StatelessWidget {
  const VSpacer({Key? key, this.space = 1}) : super(key: key);
  final double space;

  @override
  Widget build(BuildContext context) {
    SizeConfig.instance.init(context);
    return SizedBox(
      height: SizeConfig.blockSizeVertical * space,
    );
  }
}

class HSpacer extends StatelessWidget {
  const HSpacer({Key? key, this.space = 1}) : super(key: key);
  final double space;

  @override
  Widget build(BuildContext context) {
    SizeConfig.instance.init(context);
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * space,
    );
  }
}
