import 'package:flutter/material.dart';
import 'package:save_as/components/text.dart';

void showSingleChoiceDialog(BuildContext context, {bool dismissible = true, @required String title,
  @required String description, @required String btnText, void Function() onDismiss}){

  double circleRadius = 40;
  double padding = 16;
  showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context){
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(padding),
          ),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: circleRadius + padding,
                  bottom: padding,
                  left: padding,
                  right: padding,
                ),
                margin: EdgeInsets.only(top: circleRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    UserText(
                      text: title,
                      style: UserText.SUBHEAD,
                    ),
                    SizedBox(height: 16.0),
                    UserText(
                      text: description,
                      style: UserText.BODY_2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onDismiss != null ) onDismiss();// To close the dialog
                        },
                        child: Text(btnText, style: TextStyle(color: Theme.of(context).primaryColor),),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: padding,
                right: padding,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: circleRadius,
                  child: Icon(Icons.priority_high, color: Colors.white,),
                ),
              ),
            ],
          ),
        );
      }
  );
}

/// return positive or negative;
Future<bool> showDoubleChoiceDialog(BuildContext context,
    {bool dismissible = true, @required String title,
      @required String description, @required String negativeBtnText,
      @required String positiveBtnText}) async{

  double circleRadius = 40;
  double padding = 16;

  bool result = false;

  await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (BuildContext context){
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(padding),
          ),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: circleRadius + padding,
                  bottom: padding,
                  left: padding,
                  right: padding,
                ),
                margin: EdgeInsets.only(top: circleRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    UserText(
                      text: title,
                      style: UserText.SUBHEAD,
                    ),
                    SizedBox(height: 16.0),
                    UserText(
                      text: description,
                      textAlign: TextAlign.center,
                      maxLine: 2,
                    ),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          FlatButton(
                            onPressed: () {
                              result = false;
                              Navigator.of(context).pop(); // To close the dialog
                            },
                            child: Text(negativeBtnText),
                          ),
                          FlatButton(
                            onPressed: () {
                              result = true;
                              Navigator.of(context).pop(); // To close the dialog
                            },
                            child: Text(positiveBtnText, style: TextStyle(color: Theme.of(context).primaryColor),),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: padding,
                right: padding,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: circleRadius,
                  child: Icon(Icons.priority_high, color: Colors.white,),
                ),
              ),
            ],
          ),
        );
      }
  );

  return result;
}

