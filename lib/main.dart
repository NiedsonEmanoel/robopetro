import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appColors.dart';
import 'robopetro.dart';
import 'UIcolor.dart';


String drop = "Petrolina";
int _casos=0;
int _mortes=0;
int _recuperados=0;
String _lastUpdate = "Aguardando...";
String soup = 'https://petrolina.pe.gov.br/coronavirus/coronavirus-boletins-diarios';

List<Map<String, dynamic>> cidades = [{'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'},{'Casos':0, 'Mortes':0, 'Recuperados':0, 'lastUpdate':'Aguardando...'}]; //0PE, 1LG
final _webScraper = WebScraper('https://petrolina.pe.gov.br');
final _webScraperLG = WebScraper('https://covid19.lagoagrande.pe.gov.br');
final _webScraperSHEET = WebScraper('https://docs.google.com');
final _endPoint = '/coronavirus';
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
      title: 'Covid 19',
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
  Future<void> UpdatePetrolina() async {
    _casos??0;
    _mortes??0;
    _recuperados??0;
    _lastUpdate??"Aguardando...";
    setState(() {});
    if (await _webScraper.loadWebPage(_endPoint)){
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.cards > div.groupBoletim > div.boletim.boletimRed > div.info > p', []);
      _casos = int.parse(elements[0]['title']);
      cidades[0]['Casos'] = _casos;
      print('Casos: $_casos');
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.cards > div.groupBoletim > div.boletim.boletimBlack > div.info > p', []);
      _mortes = int.parse(elements[0]['title']);
      print('Mortes: $_mortes');
      cidades[0]['Mortes'] = _mortes;
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.cards > div.groupBoletim > div.boletim.boletimGreen', []);
      String recA = elements[1]["title"];
      recA = recA.replaceAll(' ', '');
      recA = recA.replaceAll('Recuperados', '');
      recA = recA.trim();
      _recuperados = int.parse(recA);
      cidades[0]['Recuperados'] = _recuperados;
      print("Recuperados: $_recuperados");
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.header > p', []);
      String recA = elements[0]['title'];
      recA = recA.trim();
      recA = recA.replaceAll(' / ', '/');
      _lastUpdate = recA;
      cidades[0]['lastUpdate'] = _lastUpdate;
      print(cidades[0]['lastUpdate']);
      setState(() {});
    }

    if (await _webScraperLG.loadWebPage("")) {
      List<Map<String, dynamic>> elements = _webScraperLG.getElement('.r-counter', []);
      List<Map<String, dynamic>> elementsH2 = _webScraperLG.getElement('h2', []);
      String al = (elementsH2[0]['title']); //0 - casos, 1 - recuperados, 2 - ativos, 3 - mortos.
      al = al.replaceAll('Boletim COVID19 - atualizado em ', '');
      print(al);
      cidades[1]['Casos'] = int.parse(elements[0]['title']);
      cidades[1]['Recuperados'] = int.parse(elements[1]['title']);
      cidades[1]['Mortes'] = int.parse(elements[3]['title']);
      cidades[1]['lastUpdate'] = al;
      setState(() {});
    }

    if (await _webScraperSHEET.loadWebPage('/spreadsheets/d/e/2PACX-1vRKn9lgluP-UkeuKKvK255WM1dAZq3lYFUJ8_NhSKAkjA_ePsv5dC_lVMAM4T9a49Cw-oif_-7b9eK_/pubhtml?gid=0&single=true')) {
      List<Map<String, dynamic>> elements = _webScraperSHEET.getElement('td', []);
      elements.forEach((element)=>{
        print(element['title']), // juazeiro
      });
      setState(() {});
    }
  }
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
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
    print("uuu");
    var brightness =  WidgetsBinding.instance.window.platformBrightness;
    if ( brightness == Brightness.dark) {
      global = Brightness.dark;
      print(global);
      colorsApp = appColors(modScreen.dark);
      setState(() {

      });
    }else {
      colorsApp = appColors(modScreen.dark);
      global = Brightness.light;
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
                        'Lagoa Grande'
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
                      Text("Verifique no seu bairro",
                          style: kTitleTextstyle,
                        ),
                      GestureDetector(
                        onTap: () {abrirUrl('https://www.instagram.com/niedsonemanoel/');},
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
                              text: "Clique no banner abaixo para acessar o Robô Petro",
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
