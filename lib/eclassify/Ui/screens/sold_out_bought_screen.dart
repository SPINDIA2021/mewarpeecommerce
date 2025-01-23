﻿import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/AppIcon.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/data/cubits/fetch_item_buyer_cubit.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/data/model/user_model.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/exports/main_export.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/ui_utils.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/customHeroAnimation.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/helper_utils.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/data/cubits/item/change_my_items_status_cubit.dart';
import 'Widgets/AnimatedRoutes/blur_page_route.dart';
import 'Widgets/AnimatedRoutes/transparant_route.dart';
import 'Widgets/Errors/something_went_wrong.dart';

class SoldOutBoughtScreen extends StatefulWidget {
  final int itemId;
  final int price;
  final String itemName;
  final String itemImage;

  const SoldOutBoughtScreen(
      {super.key,
      required this.itemId,
      required this.price,
      required this.itemName,
      required this.itemImage});

  static Route route(RouteSettings settings) {
    Map? arguments = settings.arguments as Map?;
    return BlurredRouter(
      builder: (context) {
        return BlocProvider(
          create: (context) {
            return GetItemBuyerListCubit();
          },
          child: SoldOutBoughtScreen(
            itemId: arguments?['itemId'],
            price: arguments?['price'],
            itemName: arguments?['itemName'],
            itemImage: arguments?['itemImage'],
          ),
        );
      },
    );
  }

  @override
  State<SoldOutBoughtScreen> createState() => _SoldOutBoughtScreenState();
}

class _SoldOutBoughtScreenState extends State<SoldOutBoughtScreen> {
  int? _selectedBuyerIndex;
  int? userId;

  @override
  void initState() {
    context.read<GetItemBuyerListCubit>().fetchItemBuyer(widget.itemId);
    super.initState();
  }

  Widget itemBuyerList() {
    return BlocBuilder<GetItemBuyerListCubit, GetItemBuyerListState>(
      builder: (context, state) {
        if (state is GetItemBuyerListInProgress) {
          return Center(
            child: UiUtils.progress(),
          );
        }
        if (state is GetItemBuyerListFailed) {
          return const SomethingWentWrong();
        }
        if (state is GetItemBuyerListSuccess) {
          if (state.itemBuyerList.isEmpty) {
            return Column(
              children: [
                Expanded(child: Container()),
                BlocProvider(
                  create: (context) => ChangeMyItemStatusCubit(),
                  child: Builder(builder: (context) {
                    return BlocListener<ChangeMyItemStatusCubit,
                        ChangeMyItemStatusState>(
                      listener: (context, changeState) {
                        if (changeState is ChangeMyItemStatusSuccess) {
                          HelperUtils.showSnackBarMessage(
                              context, changeState.message);
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context);
                            Navigator.pop(context, "refresh");
                          });
                        } else if (changeState is ChangeMyItemStatusFailure) {
                          Navigator.pop(context);
                          HelperUtils.showSnackBarMessage(
                              context, changeState.errorMessage);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20),
                        child: UiUtils.buildButton(context,
                            height: 46,
                            radius: 8,
                            showElevation: false,
                            buttonColor: context.color.backgroundColor,
                            border: BorderSide(
                                color: context.color.textDefaultColor
                                    .withOpacity(0.5)),
                            textColor: context.color.textDefaultColor,
                            onPressed: () async {
                          // var soldOut = await UiUtils.showBlurredDialoge(
                          //   context,
                          //   dialoge: BlurredDialogBox(
                          //     //divider: true,
                          //     title: "confirmSoldOut".translate(context),
                          //     acceptButtonName:
                          //         "comfirmBtnLbl".translate(context),
                          //     content: Text(
                          //       "soldOutWarning".translate(context),
                          //     ),
                          //   ),
                          // );
                              bool soldOut=true;
                          if (soldOut == true) {
                            Future.delayed(Duration.zero, () {
                              context
                                  .read<ChangeMyItemStatusCubit>()
                                  .changeMyItemStatus(
                                      id: widget.itemId, status: 'sold out');
                            });
                          }
                        }, buttonTitle: 'noneOfAbove'.translate(context)),
                      ),
                    );
                  }),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                    itemCount: state.itemBuyerList.length,
                    itemBuilder: (context, index) {
                      BuyerModel model = state.itemBuyerList[index];

                      return Container(
                        color: context.color.secondaryColor,
                        margin: const EdgeInsets.only(bottom: 2.5),
                        child: ListTile(
                          leading: model.profile == "" || model.profile == null
                              ? CircleAvatar(
                                  backgroundColor: context.color.territoryColor,
                                  child: SvgPicture.asset(
                                    AppIcons.profile,
                                    colorFilter: ColorFilter.mode(
                                        context.color.buttonColor,
                                        BlendMode.srcIn),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      TransparantRoute(
                                        barrierDismiss: true,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  69, 0, 0, 0),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: CustomImageHeroAnimation(
                                    type: CImageType.Network,
                                    image: model.profile,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        model.profile!,
                                      ),
                                    ),
                                  ),
                                ),
                          title: Text(model.name!),
                          trailing: Radio(
                            activeColor: context.color.territoryColor,
                            value: index,
                            groupValue: _selectedBuyerIndex,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedBuyerIndex = value;
                                userId = model.id;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_selectedBuyerIndex == null)
                BlocProvider(
                  create: (context) => ChangeMyItemStatusCubit(),
                  child: Builder(builder: (context) {
                    return BlocListener<ChangeMyItemStatusCubit,
                        ChangeMyItemStatusState>(
                      listener: (context, changeState) {
                        if (changeState is ChangeMyItemStatusSuccess) {
                          HelperUtils.showSnackBarMessage(
                              context, changeState.message);
                          Future.delayed(Duration.zero, () {
                            Navigator.pop(context);
                            Navigator.pop(context, "refresh");
                          });
                        } else if (changeState is ChangeMyItemStatusFailure) {
                          Navigator.pop(context);
                          HelperUtils.showSnackBarMessage(
                              context, changeState.errorMessage);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: UiUtils.buildButton(context,
                            height: 46,
                            radius: 8,
                            showElevation: false,
                            buttonColor: context.color.backgroundColor,
                            border: BorderSide(
                                color: context.color.textDefaultColor
                                    .withOpacity(0.5)),
                            textColor: context.color.textDefaultColor,
                            onPressed: () async {

                          // var soldOut = await UiUtils.showBlurredDialoge(
                          //   context,
                          //   dialoge: BlurredDialogBox(
                          //     //divider: true,
                          //     title: "confirmSoldOut".translate(context),
                          //     acceptButtonName:
                          //         "comfirmBtnLbl".translate(context),
                          //     content: Text(
                          //       "soldOutWarning".translate(context),
                          //     ),
                          //   ),
                          // );
                              bool soldOut=true;
                          if (soldOut == true) {
                            Future.delayed(Duration.zero, () {
                              context
                                  .read<ChangeMyItemStatusCubit>()
                                  .changeMyItemStatus(
                                      id: widget.itemId, status: 'sold out');
                            });
                          }
                        }, buttonTitle: 'noneOfAbove'.translate(context)),
                      ),
                    );
                  }),
                ),
              BlocProvider(
                create: (context) => ChangeMyItemStatusCubit(),
                child: Builder(builder: (context) {
                  return BlocListener<ChangeMyItemStatusCubit,
                      ChangeMyItemStatusState>(
                    listener: (context, changeState) {
                      if (changeState is ChangeMyItemStatusSuccess) {
                        HelperUtils.showSnackBarMessage(
                            context, changeState.message);
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                          Navigator.pop(context, "refresh");
                        });
                      } else if (changeState is ChangeMyItemStatusFailure) {
                        Navigator.pop(context);
                        HelperUtils.showSnackBarMessage(
                            context, changeState.errorMessage);
                      }
                    },
                    child: Container(
                      color: context.color.secondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: UiUtils.buildButton(context,
                            height: 46,
                            radius: 8,
                            showElevation: false,
                            buttonColor: context.color.territoryColor,
                            textColor: context.color.secondaryColor,
                            onPressed: () async {
                          // var soldOut = await UiUtils.showBlurredDialoge(
                          //   context,
                          //   dialoge: BlurredDialogBox(
                          //     //divider: true,
                          //     title: "confirmSoldOut".translate(context),
                          //     acceptButtonName:
                          //         "comfirmBtnLbl".translate(context),
                          //     content: Text(
                          //       "soldOutWarning".translate(context),
                          //     ),
                          //   ),
                          // );
                              bool soldOut=true;
                          if (soldOut == true) {
                            Future.delayed(Duration.zero, () {
                              context
                                  .read<ChangeMyItemStatusCubit>()
                                  .changeMyItemStatus(
                                      id: widget.itemId,
                                      status: 'sold out',
                                      userId: userId);
                            });
                          }
                        },
                            buttonTitle: 'markAsSoldOut'.translate(context),
                            disabled: _selectedBuyerIndex == null,
                            disabledColor:
                                context.color.textLightColor.withOpacity(0.3)),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.color.backgroundColor,
        appBar: UiUtils.buildAppBar(context,
            showBackButton: true,
            title: "whoBought?".translate(context),
            bottomHeight: 65,
            bottom: [
              Container(
                height: 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                      color: context.color.secondaryColor,
                      height: 63,
                      child: Row(
                        children: [
                          CustomImageHeroAnimation(
                            type: CImageType.Network,
                            image: widget.itemImage,
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                widget.itemImage,
                              ),
                            ),
                          ),

                          SizedBox(width: 10),
                          // Adding horizontal space between items
                          Expanded(
                            child: Container(
                              color: context.color.secondaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.itemName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    )
                                        .color(context.color.textDefaultColor)
                                        .size(context.font.large),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(start: 15.0),
                                    child: Text(
                                      Constant.currencySymbol.toString() +
                                          widget.price
                                              .toString(), // Replace with your item price
                                    )
                                        .color(context.color.textDefaultColor)
                                        .size(context.font.large)
                                        .bold(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
        body: itemBuyerList());
  }
}