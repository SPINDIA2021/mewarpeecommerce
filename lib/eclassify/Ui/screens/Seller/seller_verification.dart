
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/Extensions/extensions.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/responsiveSize.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Utils/cloudState/cloud_state.dart';
import '../../../Utils/helper_utils.dart';
import '../../../Utils/hive_Utils.dart';
import '../../../app/routes.dart';
import '../../../data/cubits/seller/fetch_seller_verification_field.dart';
import '../../../data/cubits/seller/fetch_verification_request_cubit.dart';
import '../../../data/cubits/seller/send_verification_field_cubit.dart';
import '../../../data/helper/widgets.dart';
import '../../../data/model/verification_request_model.dart';
import '../Home/home_screen.dart';
import '../Item/add_item_screen/CustomFiledStructure/custom_field.dart';
import '../Widgets/AnimatedRoutes/blur_page_route.dart';
import '../Widgets/DynamicField/dynamic_field.dart';
import '../Widgets/custom_text_form_field.dart';

class SellerVerificationScreen extends StatefulWidget {
  final bool isResubmitted;

  SellerVerificationScreen({super.key, required this.isResubmitted});

  @override
  CloudState<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();

  static Route route(RouteSettings settings) {
    Map? arguments = settings.arguments as Map?;
    return BlurredRouter(
      builder: (context) {
        return SellerVerificationScreen(
          isResubmitted: arguments?["isResubmitted"],
        );
      },
    );
  }
}

class _SellerVerificationScreenState
    extends CloudState<SellerVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  double fillValue = 0.5;
  int page = 1;
  bool isBack = false;
  List<CustomFieldBuilder> moreDetailDynamicFields = [];

  @override
  void initState() {
    super.initState();
    AbstractField.fieldsData.clear();

    Future.delayed(Duration.zero, () {
      if (widget.isResubmitted == true) {
        context
            .read<FetchVerificationRequestsCubit>()
            .fetchVerificationRequests();
      }
    });

    nameController.text = (HiveUtils.getUserDetails().name) ?? "";
    emailController.text = HiveUtils.getUserDetails().email ?? "";
    addressController.text = HiveUtils.getUserDetails().address ?? "";
    phoneController.text = HiveUtils.getUserDetails().mobile ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isBack,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (page == 2) {
          setState(() {
            page = 1;
            fillValue = 0.5;
            isBack = false;
          });
        } else {
          setState(() {
            isBack = true;
          });
        }
      },
      child: Scaffold(
          backgroundColor: context.color.backgroundColor,
          appBar: UiUtils.buildAppBar(context, showBackButton: true,
              onBackPress: () {
            if (page == 2) {
              setState(() {
                page = 1;
                fillValue = 0.5;
              });
            } else {
              Navigator.pop(context);
            }
          }),
          bottomNavigationBar: bottomBar(),
          body: mainBody()),
    );
  }

/*  Map<String, dynamic> convertToCustomFields(Map<dynamic, dynamic> fieldsData) {
     return fieldsData.map((key, value) {
      return MapEntry('verification_field[$key]', value);
    });
  }*/

  Map<String, dynamic> convertToCustomFields(Map<dynamic, dynamic> fieldsData) {
    return fieldsData.map((key, value) {
      // Check if the value is not empty and join the list elements if necessary

      return MapEntry('verification_field[$key]', value.join(', '));
    })
      ..removeWhere((key, value) => value == null); // Remove null entries
  }

  Widget bottomBar() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: sidePadding, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UiUtils.buildButton(context, height: 46, radius: 8, onPressed: () {
            if (page == 1) {
              setState(() {
                page = 2;
                fillValue = 1.0;
                Future.delayed(Duration.zero, () {
                  context
                      .read<FetchSellerVerificationFieldsCubit>()
                      .fetchSellerVerificationFields();
                });
              });
            } else {
              if (_formKey.currentState?.validate() ?? false) {

                Map<String, dynamic> data =
                    convertToCustomFields(AbstractField.fieldsData);

                Map<String, dynamic> files = AbstractField.files;


                files.forEach((key, value) {
                  if (key.startsWith('custom_field_files[') &&
                      key.endsWith(']')) {
                    String index = key.substring(
                        'custom_field_files['.length, key.length - 1);
                    String newKey = 'verification_field_files[$index]';
                    data[newKey] = value;
                  } else {
                    // For other keys, add them unchanged
                    data[key] = value;
                  }
                });
                context.read<SendVerificationFieldCubit>().send(data: data);
              }
            }
          }, buttonTitle: "continue".translate(context)),
          SizedBox(
            height: 30,
          ),
          Center(
            child: InkWell(
              child: Text(
                "skipForLater".translate(context),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    color: context.color.textDefaultColor),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget mainBody() {
    return BlocListener<SendVerificationFieldCubit, SendVerificationFieldState>(
      listener: (context, state) {
        if (state is SendVerificationFieldInProgress) {
          Widgets.showLoader(context);
        }
        if (state is SendVerificationFieldSuccess) {
          Widgets.hideLoder(context);

          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushNamed(
                context,
                Routes.sellerVerificationComplteScreen,
              );
            }
          });
        }

        if (state is SendVerificationFieldFail) {
          HelperUtils.showSnackBarMessage(context, state.error.toString());
          Widgets.hideLoder(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            /* crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,*/
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'userVerification'.translate(context),
                  )
                      .color(context.color.textDefaultColor)
                      .size(context.font.extraLarge)
                      .bold(weight: FontWeight.w600),
                  Spacer(),
                  Text('${"stepLbl".translate(context)}\t$page\t${"of2Lbl".translate(context)}')
                      .color(context.color.textLightColor)
                ],
              ),
              linearIndicator(),
              page == 1 ? firstPageVerification() : secondPageVerification(),
            ],
          ),
        ),
      ),
    );
  }

  Widget linearIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Center(
        child: Stack(
          children: [
            // First part (bottom progress indicator)
            LinearProgressIndicator(
              value: 0.5,
              borderRadius: BorderRadius.circular(2),
              // 50% of the total progress
              backgroundColor: Colors.grey[300],
              // Background color for the first part
              valueColor:
                  AlwaysStoppedAnimation<Color>(context.color.backgroundColor),
              // Color for the first 50%
              minHeight: 4.0,
            ),
            // Second part (overlaying progress indicator for the remaining 50%)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: fillValue,
                  // This limits the width of the second indicator to 50%
                  child: LinearProgressIndicator(
                    value: 1.0,
                    borderRadius: BorderRadius.circular(2),
                    // Full for the second half
                    backgroundColor: Colors.transparent,
                    // No background for the overlay
                    valueColor: AlwaysStoppedAnimation<Color>(
                        context.color.textDefaultColor),
                    // Color for the second 50%
                    minHeight: 4.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget firstPageVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Text(
          'personalInformation'.translate(context),
        )
            .color(context.color.textDefaultColor)
            .size(context.font.larger)
            .bold(),
        SizedBox(height: 8),
        Text('pleaseProvideYourAccurateInformation'.translate(context))
            .color(context.color.textDefaultColor)
            .size(context.font.large),
        SizedBox(height: 10),
        buildTextField(
          context,
          title: "fullName",
          hintText: "provideFullNameHere".translate(context),
          controller: nameController,
          //validator: CustomTextFieldValidator.nullCheck,
          readOnly: true,
        ),
        buildTextField(
          context,
          title: "addressLbl",
          hintText: "homeAddressHere".translate(context),
          controller: addressController,
          //validator: CustomTextFieldValidator.nullCheck,
          readOnly: true,
        ),
        buildTextField(
          context,
          title: "phoneNumber",
          hintText: "phoneNumberHere".translate(context),
          controller: phoneController,
          readOnly: true,
          //validator: CustomTextFieldValidator.phoneNumber,
        ),
        buildTextField(
          context,
          title: "emailAddress",
          hintText: "emailAddressHere".translate(context),
          controller: emailController,
          readOnly: true,
          //validator: CustomTextFieldValidator.email,
        ),
      ],
    );
  }

  Widget buildTextField(BuildContext context,
      {required String title,
      required TextEditingController controller,
      //CustomTextFieldValidator? validator,
      bool? readOnly,
      required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.rh(context),
        ),
        Text(title.translate(context)).color(context.color.textDefaultColor),
        SizedBox(
          height: 10.rh(context),
        ),
        CustomTextFormField(
          controller: controller,
          isReadOnly: readOnly,
          //validator: validator,
          hintText: hintText,
          fillColor: context.color.secondaryColor,
        ),
      ],
    );
  }

  Widget secondPageVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        Text(
          'idVerification'.translate(context),
        )
            .color(context.color.textDefaultColor)
            .size(context.font.larger)
            .bold(),
        SizedBox(height: 8),
        Text('selectDocumentToConfirmIdentity'.translate(context))
            .color(context.color.textDefaultColor)
            .size(context.font.large),
        SizedBox(height: 10),
        BlocBuilder<FetchVerificationRequestsCubit,
            FetchVerificationRequestState>(
          builder: (context, verificationState) {
            return BlocConsumer<FetchSellerVerificationFieldsCubit,
                FetchSellerVerificationFieldState>(
              listener: (context, state) {
                if (state is FetchSellerVerificationFieldSuccess) {
                  moreDetailDynamicFields = state.fields.map((field) {
                    Map<String, dynamic> fieldData = field.toMap();
                    if (widget.isResubmitted == true) {
                      if (verificationState
                          is FetchVerificationRequestSuccess) {
                        List<VerificationFieldValues> verificationList =
                            verificationState.data.verificationFieldValues!;

                        VerificationFieldValues? matchingField =
                            verificationList.any(
                                    (e) => e.verificationFieldId == field.id)
                                ? verificationList.firstWhere(
                                    (e) => e.verificationFieldId == field.id)
                                : null;
                        if (matchingField != null) {
                          fieldData['value'] = matchingField.value!.split(',');
                          fieldData['isEdit'] = true;
                        } // Use null-aware operator '?.' for safety
                      }
                    }

                    CustomFieldBuilder customFieldBuilder =
                        CustomFieldBuilder(fieldData);
                    customFieldBuilder.stateUpdater(setState);
                    customFieldBuilder.init();
                    return customFieldBuilder;
                  }).toList();
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (moreDetailDynamicFields.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: moreDetailDynamicFields.length,
                    itemBuilder: (context, index) {
                      final field = moreDetailDynamicFields[index];
                      field.stateUpdater(setState);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0),
                        child: field.build(context),
                      );
                    },
                  ); /*return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: moreDetailDynamicFields.map((field) {
                  field.stateUpdater(setState);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: field.build(context),
                  );
                }).toList(),
              );*/
                } else {
                  return SizedBox();
                }
              },
            );
          },
        ),
      ],
    );
  }
}