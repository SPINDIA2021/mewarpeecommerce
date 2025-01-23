import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/Extensions/extensions.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/category_model.dart';
import '../../../../exports/main_export.dart';
import '../../Widgets/AnimatedRoutes/blur_page_route.dart';

class CategoryFilterScreen extends StatefulWidget {
  final List<CategoryModel> categoryList;

  const CategoryFilterScreen({super.key, required this.categoryList});

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();

  static Route route(RouteSettings routeSettings) {
    Map? args = routeSettings.arguments as Map?;
    return BlurredRouter(
      builder: (_) => CategoryFilterScreen(
        categoryList: args!["categoryList"],
      ),
    );
  }
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        onBackPress: () {
          Navigator.of(context).pop();
        },
        title: "classifieds".translate(context),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: context.screenWidth,
          child: BlocBuilder<FetchCategoryCubit, FetchCategoryState>(
            builder: (context, state) {
              if (state is FetchCategorySuccess) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    color: context.color.secondaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          child: Text(
                            "allInClassified".translate(context),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                              .color(context.color.textDefaultColor)
                              .size(context.font.normal)
                              .bold(weight: FontWeight.w600),
                        ),
                        const Divider(
                          thickness: 1.2,
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.categories.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 1.2,
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              CategoryModel category = state.categories[index];

                              return ListTile(
                                onTap: () {
                                  widget.categoryList
                                      .add(state.categories[index]);

                                  if (state.categories[index].children
                                          ?.isNotEmpty ??
                                      false) {
                                    Navigator.pushNamed(
                                        context, Routes.subCategoryFilterScreen,
                                        arguments: {
                                          "model":
                                              state.categories[index].children,
                                          "selection": widget.categoryList,
                                        });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                leading: Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: context.color.territoryColor
                                            .withOpacity(0.1)),
                                    child: UiUtils.imageType(
                                      category.url!,
                                      color: context.color.territoryColor,
                                      fit: BoxFit.cover,
                                    )),
                                title: Text(
                                  category.name!,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    .color(context.color.textDefaultColor)
                                    .size(context.font.normal),
                                trailing: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: context.color.borderColor
                                            .darken(10)),
                                    child: Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.color.textDefaultColor,
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
