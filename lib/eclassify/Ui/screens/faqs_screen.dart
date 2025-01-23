import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Ui/screens/widgets/AnimatedRoutes/blur_page_route.dart'
    show BlurredRouter;
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/Extensions/extensions.dart';
import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/responsiveSize.dart';

import '../../Utils/api.dart';
import '../../Utils/ui_utils.dart';
import '../../data/cubits/fetch_faqs_cubit.dart';
import 'Widgets/Errors/no_data_found.dart';
import 'Widgets/Errors/no_internet.dart';
import 'Widgets/Errors/something_went_wrong.dart';
import 'Widgets/intertitial_ads_screen.dart';
import 'Widgets/shimmerLoadingContainer.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  static Route route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const FaqsScreen();
      },
    );
  }

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  @override
  void initState() {
    AdHelper.loadInterstitialAd();
    context.read<FetchFaqsCubit>().fetchFaqs();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdHelper.showInterstitialAd();
    return RefreshIndicator(
      color: context.color.territoryColor,
      onRefresh: () async {
        context.read<FetchFaqsCubit>().fetchFaqs();
      },
      child: Scaffold(
        backgroundColor: context.color.primaryColor,
        appBar: UiUtils.buildAppBar(context,
            showBackButton: true, title: "faqsLbl".translate(context)),
        body: BlocBuilder<FetchFaqsCubit, FetchFaqsState>(
          builder: (context, state) {
            if (state is FetchFaqsInProgress) {
              return buildFaqsShimmer();
            }
            if (state is FetchFaqsFailure) {
              if (state.errorMessage is ApiException) {
                if (state.errorMessage.error == "no-internet") {
                  return NoInternet(
                    onRetry: () {
                      context.read<FetchFaqsCubit>().fetchFaqs();
                    },
                  );
                }
              }
              return const SomethingWentWrong();
            }
            if (state is FetchFaqsSuccess) {
              if (state.faqModel.isEmpty) {
                return const NoDataFound();
              }
              return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 7),
                  itemCount: state.faqModel.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ExpansionPanelList.radio(
                          expandedHeaderPadding: EdgeInsets.only(bottom: 0),
                          children: [
                            ExpansionPanelRadio(
                              backgroundColor: context.color.secondaryColor,
                              body: ListTile(
                                title: Text(state.faqModel[index].answer!)
                                    .size(context.font.normal),
                              ),
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(state.faqModel[index].question!)
                                      .bold()
                                      .size(context.font.normal),
                                );
                              },
                              value: index,
                              canTapOnHeader: true,
                            ),
                          ],
                          elevation: 0.0,
                          animationDuration: const Duration(milliseconds: 700),
                          expansionCallback: (int item, bool status) {
                            setState(
                              () {
                                state.faqModel[index].isExpanded = !status;
                              },
                            );
                          },
                        ));
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildFaqsShimmer() {
    return ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 7),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            child: CustomShimmer(
              borderRadius: 0,
              width: double.infinity,
              height: 60.rh(context),
            ),
          );
        });
  }
}
