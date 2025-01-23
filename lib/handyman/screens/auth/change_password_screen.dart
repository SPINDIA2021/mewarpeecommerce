import 'package:flutter_sixvalley_ecommerce/handyman/component/base_scaffold_widget.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/main.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/network/rest_apis.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/colors.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/common.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/constant.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/images.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/model_keys.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode reenterPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      if (oldPasswordCont.text.trim() != getStringAsync(USER_PASSWORD)) {
        return toast(language.provideValidCurrentPasswordMessage);
      }

      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.oldPassword: oldPasswordCont.text,
        UserKeys.newPassword: newPasswordCont.text,
      };
      appStore.setLoading(true);

      await changeUserPassword(request).then((res) async {
        toast(res.message.validate());
        await setValue(USER_PASSWORD, newPasswordCont.text);
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.changePassword,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.lblChangePwdTitle, style: secondaryTextStyle()),
              24.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: oldPasswordCont,
                focus: oldPasswordFocus,
                nextFocus: newPasswordFocus,
                obscureText: true,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                decoration: inputDecoration(
                  context,
                  labelText: language.hintOldPasswordTxt,
                ),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: newPasswordCont,
                focus: newPasswordFocus,
                obscureText: true,
                nextFocus: reenterPasswordFocus,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                decoration: inputDecoration(context, labelText: language.hintNewPasswordTxt),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.PASSWORD,
                controller: reenterPasswordCont,
                obscureText: true,
                focus: reenterPasswordFocus,
                suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                validator: (v) {
                  if (newPasswordCont.text != v) {
                    return language.passwordNotMatch;
                  } else if (reenterPasswordCont.text.isEmpty) {
                    return errorThisFieldRequired;
                  }
                  return null;
                },
                onFieldSubmitted: (s) {
                  ifNotTester(() {
                    changePassword();
                  });
                },
                decoration: inputDecoration(context, labelText: language.hintReenterPasswordTxt),
              ),
              24.height,
              AppButton(
                text: language.confirm,
                color: primaryColor,
                textColor: Colors.white,
                width: context.width() - context.navigationBarHeight,
                onTap: () {
                  ifNotTester(() {
                    changePassword();
                  });
                },
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}
