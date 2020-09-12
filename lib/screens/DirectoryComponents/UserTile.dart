import 'package:flutter/material.dart';
import 'package:melton_app/api/api.dart';
import 'package:melton_app/models/UserModel.dart';
import 'package:melton_app/constants/constants.dart' as Constants;
import 'package:melton_app/screens/components/user_details_dialog.dart';

class UserTile extends StatelessWidget {
  final AsyncSnapshot<List<UserModel>> snapshot;
  final BuildContext context;
  final int index;

  UserTile({@required this.context, @required this.snapshot, @required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: userTile(snapshot, index),
    );
  }

  GridTile userTile(AsyncSnapshot<List<UserModel>> snapshot, int index) {
    return GridTile(
      footer: userTileFooter(snapshot, index),
      child: GestureDetector(
        onTap: () {
          showUserDetails(snapshot.data[index].id);
        },
        child: snapshot.data[index].picture == null
            ? Image.asset(Constants.placeholder_avatar)
            : Image.network(snapshot.data[index].picture, fit: BoxFit.fill),
      ),
    );
  }

  GestureDetector userTileFooter(
      AsyncSnapshot<List<UserModel>> snapshot, int index) {
    return GestureDetector(
      onTap: () {
        showUserDetails(snapshot.data[index].id);
      },
      child: GridTileBar(
        title: Center(
          child: Text(snapshot.data[index].name, style: testStyleForUserName()),
        ),
        backgroundColor: Constants.userTileFooterColor,
      ),
    );
  }

  void showUserDetails(int id) {
    Future<UserModel> model = ApiService().getUserModelById(id);
    model
        .then((value) => {print(value.name)})
        .catchError((error) => {print(error.toString())});
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => UserDetails(model)));
  }

  testStyleForUserName() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }
}
