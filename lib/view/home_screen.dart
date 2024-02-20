import 'package:flutter/material.dart';
import 'package:now_in_flutter/utils/utils.dart';
import 'package:now_in_flutter/view_model/home_view_model.dart';
import 'package:now_in_flutter/view_model/user_view_model.dart';

import 'package:provider/provider.dart';
import '../data/response/status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewViewModel homeViewViewModel = HomeViewViewModel();

  @override
  void initState() {
    super.initState();
    homeViewViewModel.fetchResourcesListApi();
  }

  @override
  Widget build(BuildContext context) {
    final userSharedPreferences = Provider.of<UserViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Home Screen'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                userSharedPreferences.removeUser(context);
              },
              child: const Icon(Icons.login_outlined),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        backgroundColor: Colors.pink,
        body: ChangeNotifierProvider<HomeViewViewModel>(
          create: (BuildContext context) => homeViewViewModel,
          child: Consumer<HomeViewViewModel>(
            builder: (context, value, _) {
              switch (value.listResponse.status) {
                case Status.loading:
                  return const Center(child: CircularProgressIndicator());
                case Status.error:
                  return Center(
                      child: Text(value.listResponse.message.toString()));
                case Status.completed:
                  return ListView.builder(
                      itemCount: value.listResponse.data!.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                          leading: Text(
                            value.listResponse.data!.data![index].id.toString(),
                          ),
                          // errorBuilder: (context, error, stack)
                          //       {
                          //         return Icon(Icons.error);
                          //       }

                          title: Text(value.listResponse.data!.data![index].name
                              .toString()),
                          subtitle: Text(value
                              .listResponse.data!.data![index].year
                              .toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(Utils.averageRating(value.ratings)
                                  .toStringAsFixed(1)),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ));
                      });
                case null:
              }
              return Container();
            },
          ),
        ));
  }
}
