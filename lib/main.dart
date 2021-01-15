import 'dart:convert';

import 'package:Barbearia_Modelo/appColors.dart';
import 'package:bubble/bubble.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';

Alignment childAlignment = Alignment.center;
final messageInsert = TextEditingController();
List<Map> messsages = List();
appColors colorsApp = appColors(modScreen.light);
var postUrl = "https://fcm.googleapis.com/fcm/send";
bool debugInAPP = false;
bool isTitle = false;
dynamic title;
bool isBody = false;
dynamic body;
int pass =0;
dynamic senha;
bool awl = false;
bool isMD5 = false;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

String textToMd5 (String text) {
  return md5.convert(utf8.encode(text)).toString();
}

void invertDebugAPP() {
  debugInAPP = !debugInAPP;
}

void invertColor() {
  if (colorsApp.isDarkSetted == true) {
    colorsApp = appColors(modScreen.light);
  }else {
    colorsApp = appColors(modScreen.dark);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final InAppReview inAppReview = InAppReview.instance;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String data = "Nenhuma notificação";

  @override
  void initState() {

    messsages.insert(0, {
      "data": 0,
      "message": "Para iniciar a conversa envie um 'Oi' abaixo"
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        messsages.insert(0, {
          "data": 0,
          "message": "${message["notification"]['title']}\n\n${message["notification"]['body']}"
        });


        setState(() {
          data = message.toString();
        });
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        messsages.insert(0, {
          "data": 0,
          "message": "Vi que consegui chamar sua atenção. \n\nIrei ser breve... Se quiser saber a quantidade de casos em seu bairro digite aqui o nome do mesmo, ou digite 'sintomas' que eu lhe digo os sintomas da COVID-19. \n\nPode contar comigo para o que você quiser."
        });

        setState(() {
          data = message.toString();
        });
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        messsages.insert(0, {
          "data": 0,
          "message": "Vi que consegui chamar sua atenção. \n\nIrei ser breve... Se quiser saber a quantidade de casos em seu bairro digite aqui o nome do mesmo, ou digite 'sintomas' que eu lhe digo os sintomas da COVID-19. \n\nPode contar comigo para o que você quiser."
        });

        setState(() {
          data = message.toString();
        });
      },
    );
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true
        ));
    _firebaseMessaging.getToken().then((token) {
      print(token);
      _firebaseMessaging.subscribeToTopic("android");
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    changeTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    changeTheme();
  }

  changeTheme() {
    var brightness = WidgetsBinding.instance.window.platformBrightness;
    if (brightness == Brightness.dark) {
      colorsApp = appColors(modScreen.dark);
    }else {
      colorsApp = appColors(modScreen.light);
    }

    setState(() {});
  }

  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/cupcakesbot-qlrcih-9c82160e9e70.json")
        .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    if (await inAppReview.isAvailable() != null) {
      inAppReview.requestReview();
    }
  }


  static Future<void> sendNotification(msg, title)async{
    final data = {
      "notification": {"body": "$msg", "title": "$title"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "/topics/android"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAypLB3-k:APA91bGaYjBvTu2xRNgiK4DtdWbgRZ_o3tFW1CERLjXnYxMO1RSHGiW6QJC77BxnDwwdkocENcPPoMATm6cMUC27uc6ndhbeWRSDTw_3TmIaeTqhJjwATdwbZwr1JBfMm0WIe_2oJS0k'
    };


    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );


    try {
      final response = await Dio(options).post(postUrl,
          data: data);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Notificação Enviada!');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    }
    catch(e){
      print('exception $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Robô Petro",
        ),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        color: colorsApp.backgroundColor,
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 5.0,
              color: Colors.pink,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                        controller: messageInsert,
                        style: TextStyle(
                          color: colorsApp.textColor
                        ),
                        decoration: InputDecoration.collapsed(
                            hintText: "Mensagem...",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: colorsApp.hintTextColor
                            )),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(

                        icon: Icon(

                          Icons.send,
                          size: 30.0,
                          color: Colors.pink,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                            messageInsert.text = "Oi";
                            pass++;
                            pass = pass==4? 0:pass;
                            print (pass);
                            if(pass == 3) {
                              Fluttertoast.showToast(msg: "Supimpa!");
                            }
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                              if(((messageInsert.text == "DEBUG_MODE")||(messageInsert.text == "DEV_MODE"))&&(pass == 3)) {
                                awl = true;
                                if (debugInAPP == false) {
                                  messsages.insert(0, {
                                    "data": 0,
                                    "message": "Digite a senha:"
                                  });
                                  isMD5 = true;
                                } else {
                                    messsages.insert(0, {
                                      "data": 0,
                                      "message": "MODO DESENVOLVEDOR DESATIVADO"
                                    });
                                  invertDebugAPP();
                                  isMD5 = false;
                                  }
                              }

                              else if ((isMD5 == true) && (awl == true)) {
                                senha = textToMd5(messageInsert.text);
                                if (senha == '4e5a95862de7218e4a78651e955688f1') {
                                  if (debugInAPP == false) {
                                    messsages.insert(0, {
                                      "data": 0,
                                      "message": "MODO DESENVOLVEDOR ATIVADO \n\n"
                                          "-> DEBUG_MODE ou DEV_MODE:\n-Desativa o modo desenvolvedor.\n\n"
                                          "-> I_C:\n-Inverter o modo de visualização do app.\n\n"
                                          "Notificações:\n-> ENVIAR_NOTIFICAÇÃO\n-Enviar notificação personalizada.\n\n"
                                          "-> CASOS_ATUALIZADOS:\n-Enviar notificação informando a atualização dos dados.\n\n"
                                          "-> CUIDE_SE:\n-Notificação para lembrar do uso de máscaras e álcool."
                                    });
                                    invertDebugAPP();
                                    awl = false;
                                  }
                                } else {
                                  isMD5 = false;
                                  messsages.insert(0, {
                                    "data": 0,
                                    "message": "Senha incorreta :("
                                  });
                                  awl = true;
                                }
                              }

                              else if((messageInsert.text == "CUIDE_SE")&&(debugInAPP == true)) {
                                sendNotification("Você e seus familiares são importantes para nós, cuidem-se e assim vamos vencer a covid.", "Cuide-se, vai passar.");
                              }

                              else if((messageInsert.text == "CASOS_ATUALIZADOS")&&(debugInAPP == true)) {
                                sendNotification("Nossa base de dados já foi sincronizada com a da Prefeitura, confira a quantidade de casos em seu bairro.", "Verifique a quantidade de casos no seu bairro.");
                              }

                              else if((messageInsert.text == "ENVIAR_NOTIFICAÇÃO")&&(debugInAPP == true)) {
                                messsages.insert(0, {
                                  "data": 0,
                                  "message": "Digite o título:"
                                });
                                isTitle = true;
                              }

                              else if((isTitle == true)&&(debugInAPP == true)) {
                                title = messageInsert.text;
                                messsages.insert(0, {
                                  "data": 0,
                                  "message": "Digite o corpo:"
                                });
                                isTitle = false;
                                isBody = true;
                              }

                              else if((isBody == true)&&(debugInAPP == true)) {
                                body = messageInsert.text;
                                sendNotification(body, title);
                                isTitle = false;
                                isBody = false;
                              }

                              else if((messageInsert.text == "I_C")&&(debugInAPP == true)) {
                                messsages.insert(0, {
                                  "data": 0,
                                  "message": "Cores invertidas."
                                });
                                invertColor();
                              }else {
                                response(messageInsert.text);
                              }
                              messageInsert.clear();
                            });
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }


  Widget chat(String message, int data) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? Colors.pink : Colors.pinkAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      data == 0 ? "assets/bot.png" : "assets/user.png"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }
}
