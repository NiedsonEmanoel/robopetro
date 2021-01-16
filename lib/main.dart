import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'robopetro.dart';


String drop = "Petrolina";
int _casos=0;
int _mortes=0;
int _recuperados=0;
String _lastUpdate = "Aguardando...";
final _webScraper = WebScraper('https://petrolina.pe.gov.br');
final _endPoint = '/coronavirus';

bool _isBlack = false;
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
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

TextStyle kTitleTextstyleK = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

TextStyle kTitleTextstyleo = TextStyle(
  color: Color(0xFF303030),
  fontWeight: FontWeight.bold,
);


void main() => runApp(MyApp());

void enclarecer() {
   kBackgroundColor = Color(0xFFFEFEFE); //black87
   kTitleTextColor = Color(0xFF303030); // branco
   kassandra = Colors.white;
   kBodyTextColor = Color(0xFF4B4B4B); // branco
   cBOX = Colors.white; //preto 12
}

void apagarAsLuzes() {
  kBackgroundColor = Colors.black87; //black87
  kTitleTextColor = Colors.white; // branco
  kassandra = Colors.pinkAccent;
  kBodyTextColor = Colors.white; // branco
  cBOX = Colors.black12; //preto 12
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
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
      print('Casos: $_casos');
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.cards > div.groupBoletim > div.boletim.boletimBlack > div.info > p', []);
      _mortes = int.parse(elements[0]['title']);
      print('Mortes: $_mortes');
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.cards > div.groupBoletim > div.boletim.boletimGreen', []);
      String recA = elements[1]["title"];
      recA = recA.replaceAll(' ', '');
      recA = recA.replaceAll('Recuperados', '');
      recA = recA.trim();
      _recuperados = int.parse(recA);
      print("Recuperados: $_recuperados");
      setState(() {});
    }

    if (await _webScraper.loadWebPage(_endPoint)) {
      List<Map<String, dynamic>> elements = _webScraper.getElement('main.coronavirus-container > section.coronaHome-boletim > div.boletimContainer > div.header > p', []);
      String recA = elements[0]['title'];
      recA = recA.trim();
      recA = recA.replaceAll(' / ', '/');
      _lastUpdate = recA;
      print(_lastUpdate);
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
  }


  @override
  void didChangePlatformBrightness() {
    changeTheme();
  }

  changeTheme() {
    var brightness = WidgetsBinding.instance.window.platformBrightness;
    print(brightness);
    if (brightness == Brightness.light) {
    enclarecer();
    setState(() {});
    }else {
    apagarAsLuzes(); //implementar com classe
    setState(() {});
    }


  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
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
                color: cBOX,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
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
                        'Petrolina'
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
                        onTap: () {abrirUrl('https://petrolina.pe.gov.br/coronavirus/coronavirus-boletins-diarios');},
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
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: cBOX,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
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
                      color: kBackgroundColor,
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
