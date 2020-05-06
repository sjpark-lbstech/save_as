import 'package:flutter/material.dart';
import 'package:save_as/route.dart';

FloatingActionButton cameraFab(BuildContext context,
    {IconData icon = Icons.camera_alt, Color iconColor = Colors.black87}) {
  return FloatingActionButton(
    backgroundColor: Colors.white,
    child: Icon(
      icon,
      color: Colors.black87,
    ),
    onPressed: (){
      Navigator.of(context).pushNamed(Router.CAMERA);
    },
  );
}