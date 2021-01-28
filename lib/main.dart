import 'dart:async';
import 'dart:io';

import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appColors.dart';
import 'no_connection.dart';
import 'robopetro.dart';
import 'UIcolor.dart';


String drop = "Petrolina";
int _casos=0;
int _mortes=0;
int _recuperados=0;
String _lastUpdate = "Aguardando...";
String soup = 'https://petrolina.pe.gov.br/coronavirus/coronavirus-boletins-diarios';

List<Map<String, dynamic>> cidades = [
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  {'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}, //
  ];

final _webScraperSHEET = WebScraper('https://docs.google.com');
UIcolor ui = UIcolor(0);
Brightness global;
ThemeData sui = sui = ThemeData(
    scaffoldBackgroundColor: ui.kBackgroundColor,
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    textTheme: TextTheme(
      body1: TextStyle(color: ui.kBodyTextColor),
    ));

Color kBackgroundColor = Color(0xFFFEFEFE); //black87
Color kTitleTextColor = Color(0xFF303030); // branco
Color kBodyTextColor = Color(0xFF4B4B4B); // branco
Color cBOX = Colors.white; //preto 12
Color kTextLightColor = Color(0xFF959595);
Color kInfectedColor = Color(0xFFFF8748);
Color kDeathColor = Color(0xFFFF4848);
Color kassandra = Colors.white;
Color kRecovercolor = Color(0xFF36C12C);
Color kPrimaryColor = Colors.pink;
final kShadowColor = Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);

// Text Style
TextStyle kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

TextStyle kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

TextStyle kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: ui.kTitleTextColor,
  fontWeight: FontWeight.bold,
);

TextStyle kTitleTextstyleK = TextStyle(
  fontSize: 18,
  color: ui.kTitleTextColor,
  fontWeight: FontWeight.bold,
);

TextStyle kTitleTextstyleo = TextStyle(
  color: Color(0xFF303030),
  fontWeight: FontWeight.bold,
);


void main() => runApp(MyApp());

void enclarecer() {
   ui.kBackgroundColor = Color(0xFFFEFEFE); //black87
   ui.kTitleTextColor = Color(0xFF303030); // branco
   ui.kassandra = Colors.white;
   ui.kBodyTextColor = Color(0xFF4B4B4B); // branco
   ui.cBOX = Colors.white; //preto 12
  global = Brightness.light;
   sui = ThemeData(
       scaffoldBackgroundColor: ui.kBackgroundColor,
       brightness: Brightness.light,
       fontFamily: "Poppins",
       textTheme: TextTheme(
         body1: TextStyle(color: ui.kBodyTextColor),
       ));
}

void apagarAsLuzes() {
  ui.kBackgroundColor = Colors.black87; //black87
  ui.kTitleTextColor = Colors.white; // branco
  ui.kassandra = Colors.pinkAccent;
  ui.kBodyTextColor = Colors.white; // branco
  ui.cBOX = Colors.black12; //preto 12
  global = Brightness.dark;
  sui = ThemeData(
      scaffoldBackgroundColor: ui.kBackgroundColor,
      brightness: Brightness.dark,
      fontFamily: "Poppins",
      textTheme: TextTheme(
        body1: TextStyle(color: ui.kBodyTextColor),
      ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robô Petro',
      theme: sui,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

abrirUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  void Conected() async{
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 2));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on TimeoutException catch (_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {

            return NoConnectionScreen();
          },
        ),
      );
    }
  }

   Future<void> UpdatePetrolina() async {
    _casos??0;
    _mortes??0;
    _recuperados??0;
    _lastUpdate??"Aguardando...";
    setState(() {});

    if (await _webScraperSHEET.loadWebPage('/spreadsheets/d/e/2PACX-1vTW2eWiBkBGHg2uRhpV9lmiD-dsCmvD6Q1YEZeoaVi2v2HevzE9kAs3HvVAh-VUz9VoAc451o8AlEuK/pubhtml?gid=1803427030&single=true')) {
      List<Map<String, dynamic>> elements = _webScraperSHEET.getElement('td', []);
     // JUAZEIRO
      cidades[2]['Casos'] = int.parse(elements[0]['title']);
      cidades[2]['Recuperados'] = 0;
      cidades[2]['Mortes'] = int.parse(elements[1]['title']);
      cidades[2]['lastUpdate'] = "${elements[2]['title']} pela equipe\ndo Brasil.io";
      //JUAZEIRO

      //SOBRADINHO
      cidades[3]['Casos'] = int.parse(elements[21]['title']);
      cidades[3]['Recuperados'] = 0;
      cidades[3]['Mortes'] = int.parse(elements[22]['title']);
      cidades[3]['lastUpdate'] = "${elements[23]['title']} pela equipe\ndo Brasil.io";
      //SOBRADINHO

      //CASA NOVA
      cidades[4]['Casos'] = int.parse(elements[42]['title']);
      cidades[4]['Recuperados'] = 0;
      cidades[4]['Mortes'] = int.parse(elements[43]['title']);
      cidades[4]['lastUpdate'] = "${elements[44]['title']} pela equipe\ndo Brasil.io";
      //CASA NOVA

      //S TALHADA
      cidades[5]['Casos'] = int.parse(elements[63]['title']);
      cidades[5]['Recuperados'] = 0;
      cidades[5]['Mortes'] = int.parse(elements[64]['title']);
      cidades[5]['lastUpdate'] = "${elements[65]['title']} pela equipe\ndo Brasil.io";
      // CURAÇÁ

      //S TALHADA
      cidades[6]['Casos'] = int.parse(elements[84]['title']);
      cidades[6]['Recuperados'] = 0;
      cidades[6]['Mortes'] = int.parse(elements[85]['title']);
      cidades[6]['lastUpdate'] = "${elements[86]['title']} pela equipe\ndo Brasil.io";
      //S TALHADA

      //CARUARU
      String a = elements[105]['title'];
      a = a.replaceAll(".", "");
      cidades[7]['Casos'] = int.parse(a);
      cidades[7]['Recuperados'] = 0;
      cidades[7]['Mortes'] = int.parse(elements[106]['title']);
      cidades[7]['lastUpdate'] = "${elements[107]['title']}.\nFonte: Prefeitura Municipal.";
      //CARUARU

      //PETROLINA
      cidades[0]['Casos'] = int.parse(elements[126]['title']);
      cidades[0]['Recuperados'] = int.parse(elements[128]['title']);
      cidades[0]['Mortes'] = int.parse(elements[127]['title']);
      cidades[0]['lastUpdate'] = "${elements[129]['title']} \nFonte: Prefeitura Municipal";
      //PETROINA

      //LAGOA GRANDE
      cidades[1]['Casos'] = int.parse(elements[147]['title']);
      cidades[1]['Recuperados'] = int.parse(elements[149]['title']);
      cidades[1]['Mortes'] = int.parse(elements[148]['title']);
      cidades[1]['lastUpdate'] = '${elements[150]['title']}\nFonte: Prefeitura Municipal';
      //LAGOA GRANDE

      for(int i = 150; i <elements.length; i++) {
        print("$i : ${elements[i]['title']}");
      }
      _casos = cidades[0]['Casos'];
      _mortes = cidades[0]['Mortes'];
      _recuperados = cidades[0]['Recuperados'];
      _lastUpdate = cidades[0]['lastUpdate'];
    }

    setState(() {
      print("Atualização completa");
    });
  }
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    Conected();
    UpdatePetrolina();
    WidgetsBinding.instance.addObserver(this);
    changeTheme();
    RoboPetro().createState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    changeTheme();
  }

  changeTheme() {
    var brightness =  WidgetsBinding.instance.window.platformBrightness;
    if ( brightness == Brightness.dark) {
      global = Brightness.dark;
      print(global);
     // apagarAsLuzes();
      colorsApp = appColors(modScreen.dark);
      setState(() {
      });
    }else {
      colorsApp = appColors(modScreen.dark);
      global = Brightness.light;
    //  enclarecer();
      print(global);
      setState(() {});
    }
    setState(() {});
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Tudo que você\nprecisa fazer",
              textBottom: "é ficar em casa.",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ui.cBOX,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.pinkAccent,
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      style: kTitleTextstyleK,
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: drop,
                      items: [
                        'Petrolina',
                        'Lagoa Grande',
                        'Juazeiro',
                        'Araripina',
                        'Afrânio',
                        'Dormentes',
                        'Serra Talhada',
                        'Caruaru'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: <Widget>[
                              Text(value, style: kTitleTextstyleK),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          drop = value;
                          if(value == 'Lagoa Grande') {
                            _casos = cidades[1]['Casos'];
                            _recuperados = cidades[1]['Recuperados'];
                            _mortes = cidades[1]['Mortes'];
                            _lastUpdate = cidades[1]['lastUpdate'];
                            soup = 'https://covid19.lagoagrande.pe.gov.br/';
                          }

                          if(value == 'Petrolina') {
                            _casos = cidades[0]['Casos'];
                            _recuperados = cidades[0]['Recuperados'];
                            _mortes = cidades[0]['Mortes'];
                            _lastUpdate = cidades[0]['lastUpdate'];
                            soup = 'https://petrolina.pe.gov.br/coronavirus/coronavirus-boletins-diarios';
                          }

                          if(value == 'Juazeiro') {
                            _casos = cidades[2]['Casos'];
                            _recuperados = cidades[2]['Recuperados'];
                            _mortes = cidades[2]['Mortes'];
                            _lastUpdate = cidades[2]['lastUpdate'];
                            soup = 'https://brasil.io/home/';
                          }

                          if(value == 'Araripina') {
                            _casos = cidades[3]['Casos'];
                            _recuperados = cidades[3]['Recuperados'];
                            _mortes = cidades[3]['Mortes'];
                            _lastUpdate = cidades[3]['lastUpdate'];
                            soup = 'https://brasil.io/home/';
                          }

                          if(value == 'Afrânio') {
                            _casos = cidades[4]['Casos'];
                            _recuperados = cidades[4]['Recuperados'];
                            _mortes = cidades[4]['Mortes'];
                            _lastUpdate = cidades[4]['lastUpdate'];
                            soup = 'https://brasil.io/home/';
                          }

                          if(value == 'Dormentes') {
                            _casos = cidades[5]['Casos'];
                            _recuperados = cidades[5]['Recuperados'];
                            _mortes = cidades[5]['Mortes'];
                            _lastUpdate = cidades[5]['lastUpdate'];
                            soup = 'https://brasil.io/home/';
                          }

                          if(value == 'Serra Talhada') {
                            _casos = cidades[6]['Casos'];
                            _recuperados = cidades[6]['Recuperados'];
                            _mortes = cidades[6]['Mortes'];
                            _lastUpdate = cidades[6]['lastUpdate'];
                            soup = 'https://brasil.io/home/';
                          }

                          if(value == 'Caruaru') {
                            _casos = cidades[7]['Casos'];
                            _recuperados = cidades[7]['Recuperados'];
                            _mortes = cidades[7]['Mortes'];
                            _lastUpdate = cidades[7]['lastUpdate'];
                            soup = 'https://caruaru.pe.gov.br/coronavirus';
                          }

                          if(value == 'Pernambuco') {
                            _casos = cidades[8]['Casos'];
                            _recuperados = cidades[8]['Recuperados'];
                            _mortes = cidades[8]['Mortes'];
                            _lastUpdate = cidades[8]['lastUpdate'];
                            soup = 'https://www.pecontracoronavirus.pe.gov.br/';
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Boletim de Casos\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Atualizado em ${_lastUpdate}",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {abrirUrl(soup);},
                        child: Text(
                          "Veja mais",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.pinkAccent,
                        width: 1
                      ),
                      color: Color(0x36272f),

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: _casos,
                          title: "Confirmados",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: _mortes,
                          title: "Mortes",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: _recuperados,
                          title: "Recuperados",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Denuncie!",
                          style: kTitleTextstyle,
                        ),
                      GestureDetector(
                        onTap: () {abrirUrl('https://linktr.ee/robopetro');},
                        child: Text(
                        "Saiba mais",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Use o Robô Petro no banner abaixo\npara exercer sua cidadania e denunciar\npessoas que estão furando a fila\nda vacinação.",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(0),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ui.kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {

                                  return RoboPetro();
                                },
                              ),
                            );
                          },
                          child: Image.asset(
                            "assets/images/map.png",
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
