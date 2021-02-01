/// @author Saur-Bek saur-bek.asev-ajiyev@hardenberg-gymnasium.schule
/// @version 0.7 (stable)

import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:html/parser.dart';

bool reset = false;

bool isLoggedIn = false;

List<dynamic> json = List<dynamic>.empty(growable: true);

List<dynamic> page_json = List<dynamic>.empty(growable: true);

final storage = new FlutterSecureStorage();

List<String> wBlackList = List.empty(growable: true);

String wTitleBar = "";

String iservuser = "";

String iservpassword = "";

String dsbpassword = "";

String dsbuser = "";

PageController _controller = new PageController(initialPage: 0);

bool fetchPageAllowed = true;

int wAppBar = 0;

IconData wIcon = Icons.pages;

String wUrl = "";

String wCopynote = "";

int id = 0;

bool internet = false;

int page = 1;

String bartext = "HGF - App";

var hgf;

void main() async{

  if(kIsWeb){
    internet = true;
  } else {
    try {
      final result = await InternetAddress.lookup('raupi.net');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Verbindung zu raupi.net erfolgreich -> Internetzugriff möglich');
        internet = true;
      }
    } on SocketException catch (_) {
      print('Verbindung zu raupi.net gescheitert -> Internetzugriff nicht möglich');
      internet = false;
    }
  }

  if(internet){
    String url = 'https://hardenberg-gymnasium.de/wp-json/wp/v2/posts/?_embed&per_page=10&page=1';
    Response response = await get(url);
    json = jsonDecode(response.body);
    String url_ = 'https://hardenberg-gymnasium.de/wp-json/wp/v2/pages/?_embed&per_page=100&page=1';
    Response r_response = await get(url_);
    page_json = jsonDecode(r_response.body);
  }

  if(kIsWeb){
    runApp(HGFApp());
  } else {
    runApp(Passwords());
  }

}

class HGFApp extends StatelessWidget {

  @override
  Widget build(BuildContext c){
    return MaterialApp(
      home: HGFHome(),
    );
  }

}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Fehler beim öffnen der Website $url';
  }
}

showContactDialog(BuildContext context) {

  OutlinedButton mailButton = OutlinedButton(
    child: Text("  E-Mail an den Entwickler  ", style: GoogleFonts.montserrat(color: Colors.red)),
    onPressed: () {
      _launchURL("mailto:saur-bek.asev-ajiyev@hardenberg-gymnasium.schule?subject=R%C3%BCckmeldung%20%C3%BCber%20die%20APP%20des%20HGF&body=Hallo%2C%0D%0A%0D%0Aich%20finde%2C%20dass%20die%20App%20...%0D%0A%0D%0AGr%C3%BC%C3%9Fe%2C ");
    },
  );

  Widget okButton = FlatButton(
    child: Text("  dies schließen  ", style: GoogleFonts.montserrat(color: Colors.red)),
    onPressed: () { Navigator.of(context).pop(); },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black,
    title: Text("Über mich", style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),),
    content: Text("Stolz entwickelt & präsentiert von Saur-Bek!", style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white)),
    actions: [
      mailButton, okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  /*showAboutDialog(
    applicationIcon: Image.network(""),
    applicationName: "HGF - App",
    applicationVersion: "0.7",
    applicationLegalese: "(C) 2021 Saur-Bek",
    children: [
      OutlinedButton(
          child: Text("  E-Mail an den Entwickler  ",
              style: GoogleFonts.montserrat(color: Colors.red)),
          onPressed: () {
            _launchURL(
                "mailto:saur-bek.asev-ajiyev@hardenberg-gymnasium.schule?subject=R%C3%BCckmeldung%20%C3%BCber%20die%20APP%20des%20HGF&body=Hallo%2C%0D%0A%0D%0Aich%20finde%2C%20dass%20die%20App%20...%0D%0A%0D%0AGr%C3%BC%C3%9Fe%2C ");
          },
        ),
      ],
    context: context
  );*/

}

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Widget webv(String url, String replaceText, String replaceimg) {

  if (kIsWeb) {

    List<String> ls = url.toString().split("https://hardenberg-gymnasium.de/wp-content/uploads/");

    List<String> ms = List<String>.empty(growable: true);

    //return Html(data: json[id]['content']['rendered'].toString().replaceAll(replaceText, "").replaceAll(replaceimg, "")/*.split("<p>")[1].split("</p>")[1].split("\\n")[0].split("\\n")[0],*/);

    return OutlinedButton(

        child: Row(children: [ Icon(Icons.arrow_forward), Text(" Mehr auf der HGF - Website ..."),]),

        onPressed: () {
          _launchURL(url);
        }

    );

  } else {

    /*List<String> ls = json[id]['content']['rendered'].toString().split("https://hardenberg-gymnasium.de/wp-content/uploads/");

    List<String> ms = List<String>.empty(growable: true);

    List<Image> imgs = List<Image>.empty(growable: true);

    for(int l = 0; l <= ls.length-1; l++){

      String str = ls[l].split(".")[0] + "." + ls[l].split(".")[1].substring(0, 4);

      str.replaceAll("-165x300", "").replaceAll("-200x387", "");

      ms.add(str);

    }

    var ms_ = ms.toSet().toList();

    for(int u = 0; u <= ms_.length-1; u++){

      imgs.add(Image.network("https://hardenberg-gymnasium.de/wp-content/uploads/" + ms_[u]));
      print("Images: https://hardenberg-gymnasium.de/wp-content/uploads/" + ms_[u]);

    }

    Column cl = Column(children: imgs);*/

    /*List<String> ls1 = json[id]['content']['rendered'].toString().split("<a");

    List<String> ms1 = List<String>.empty(growable: true);

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    for(int l = 0; l <= ls1.length-1; l++){

      ms1.add(ls1[l].split("href=\"")[1].split("\"")[0] + "LLinK34SepparatorTXT!?" + ls1[l].split("href=\"")[1].split("\"")[1].split(">")[1].split("</a>")[0]);

      print("Links: " + ms1[l]);

    }*/

    /*return WebView(
        initialUrl: json[id]['link'].toString(),
        javascriptMode: JavascriptMode.unrestricted,
        /*onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl(Uri.dataFromString(
              json[id]['content']['rendered'].toString().replaceAll(parseText(json[id]['content']['rendered']), "").replaceAll(replaceimg, "").replaceAll("<strong>", "").replaceAll("</strong>", "").replaceAll("<em>", "").replaceAll("</em>", "").replaceAll(json[id]['_embedded']['wp:featuredmedia'][0]['source_url'].toString().split(".")[0], "").replaceAll("<italic>", "").replaceAll("</italic>", ""),
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8')
          ).toString()json[id]['link'].toString());
        }*/);*/

    //printWrapped(url.replaceAll(replaceimg, "").replaceAll(replaceText, ""));

    if(url.contains("</div></div></div></div></div>")){
      url = url.split("</div></div></div></div></div>")[1];
    }

    return Column(children:[Html(data: url.replaceAll(replaceimg, "").replaceAll(replaceText, "")/*.replaceAll(replaceText, "").replaceAll(replaceimg, "").split("<p>")[1].split("</p>")[1].split("\\n")[0].split("\\n")[0]*/),/*cl*/]);

  }

}

Widget webvAK(String url, String copynote, List<String> blacklist) {

  if (kIsWeb) {

    return FloatingActionButton.extended(

        label: Text(" Mehr im Internet ...", style: TextStyle(color: Colors.black)),

        icon: Icon(Icons.arrow_forward, color: Colors.black),

        splashColor: Colors.black,

        backgroundColor: Colors.white,

        onPressed: () {
          _launchURL(url);
        }

    );

  } else {

    /*String html = "";

    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse(url))
        .then((HttpClientRequest response) => response.close())
        .then(HttpBodyHandler.processResponse)
        .then((HttpClientResponseBody body) => html);*/

    if(/*copynote.isNotEmpty*/true){

      WebViewController controller;

      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: "HGF",
        onWebViewCreated: (WebViewController webViewController) { controller = webViewController; },
        onPageFinished: (url) {
          if(url.startsWith("https://www.dsbmobile.de/Login.aspx")){
            controller.evaluateJavascript("document.getElementById(\"txtUser\").value = \"" + dsbuser + "\"");
            controller.evaluateJavascript("document.getElementById(\"txtPass\").value = \"" + dsbpassword + "\"");
            controller.evaluateJavascript("document.getElementsByClassName(\"login\").ctl03.click()");
          }
          if(url.startsWith("https://hardenberg-gymnasium.de/termine/")){
            controller.evaluateJavascript("document.getElementsByClassName(\"fusion-header-wrapper\").item(0).innerHTML = \"\";");
            controller.evaluateJavascript("document.getElementsByClassName(\"fusion-footer\").item(0).innerHTML = \"\";");
          }
        },
        navigationDelegate: (NavigationRequest request) {
          for(int i = 0; i <= blacklist.length-1; i++){
            if (request.url.startsWith(blacklist[i])) {
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        gestureNavigationEnabled: true,
      );

    }

    //return Html(data: html,);

  }

}

class WebView_ extends StatelessWidget{

  String parseStrangeHTML(String s){
    String s_ = s;
    try {
      if(s.contains("0.4);}") && s.startsWith(".fusion-image-frame")){
        s_ = s_.split("0.4);}")[2];
      }
      s = s_;
    } catch (Error) {
      print("Parsing error! Stupid WP REST Api .....");
    }
    try {
      if(s_.contains(".fusion-gallery")/* && s.endsWith("0px solid #f6f6f6")*/){
        s_ = s_.split(".fusion-gallery")[0];
      }
      s = s_;
    } catch (Error) {
      print("Parsing error! Stupid WP REST Api .....");
    }
    try {
      if(s_.contains(".fusion-image-frame-")){
        s_ = s_.split("0.4);}")[1];
      }
      s = s_;
    } catch (Error) {
      print("Parsing error! Stupid WP REST Api .....");
    }
    /*if(s.contains(".fusion-body")){
      List<String> st = s.split("1.92%;}}");
      if(st.length == 0){
        s = s.split(".fusion-body")[0];
      } else {
        s = s.split("1.92%;}}")[1];
      }
    }*/
    return s;
  }

  @override
  Widget build(BuildContext context){

    /*return Scaffold(

      appBar: AppBar(

        title: Text(bartext),

      ),

      floatingActionButton: FloatingActionButton(

        tooltip: "Schließen",

        //icon: Icon(Icons.close),

        child: Icon(Icons.close),

        backgroundColor: Colors.pink,

        mini:true,

        splashColor: Colors.deepPurple,

        //label: Text("Schließen"),

        onPressed: () {

          Navigator.pop(context);

        },

      ),

      body: Center(

        child: Column(

          children: [

            Image.network(json[id]['_embedded']['wp:featuredmedia'][0]['source_url'].toString()),

            Expanded(flex: 1, child: SingleChildScrollView(child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(children: [ Text(parseStrangeHTML(parse(parse(json[id]['content']['rendered'].toString()).body.text).documentElement.text), style: GoogleFonts.montserrat(fontSize: 18), textAlign: TextAlign.left,),
                  /*webv(json[id]['link'], "", "")*/],),),),),

          ],

        ),

      )

    );*/

    try {return Scaffold(
        floatingActionButton: FloatingActionButton(

          tooltip: "Schließen",

          //icon: Icon(Icons.close),

          child: Icon(Icons.close),

          backgroundColor: Colors.pink,

          mini:true,

          splashColor: Colors.deepPurple,

          //label: Text("Schließen"),

          onPressed: () {

            Navigator.pop(context);

          },

        ),
      body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 490,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(bartext, softWrap: true,),
            background: Hero(tag: json[id]['_embedded']['wp:featuredmedia'][0]
            ['source_url']
                .toString(), child:Image.network(json[id]['_embedded']['wp:featuredmedia'][0]['source_url'].toString(), height: 490,),),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: /*webcontent()*/Column(children: [Text(parseStrangeHTML(parse(parse(json[id]['content']['rendered'].toString()).body.text).documentElement.text), style: GoogleFonts.montserrat(fontSize: 18), textAlign: TextAlign.left,),
                  webv(json[id]['content']['rendered'], parse(parse(json[id]['content']['rendered'].toString()).body.text).documentElement.text, json[id]['_embedded']['wp:featuredmedia'][0]['source_url'])],),)
            ]
          ),
        ),
      ],
    ));

  } catch(error){
      return Scaffold(body:Center(child: Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text("Post ist beschädigt!\nDrücke die zurück taste auf\ndeinem Gerät oder klicke die Zurück-Taste."), ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Row(children:[Icon(Icons.arrow_back),SizedBox(width:15),Text("Zurück")]),)])));
  }
  
  Widget webcontent(){
    WebViewController controller;
    WebView wbv = WebView(
      javascriptMode: JavascriptMode.unrestricted, 
      initialUrl: json[id]['link'],
      onPageFinished: (url){
        if(url.startsWith("https://hardenberg-gymnasium.de/")){
          controller.evaluateJavascript("document.getElementsByClassName(\"fusion-header-wrapper\").item(0).innerHTML = \"\";");
          controller.evaluateJavascript("document.getElementsByClassName(\"fusion-footer\").item(0).innerHTML = \"\";");
        }
      },
      onWebViewCreated: (WebViewController webViewController) { controller = webViewController; }
    );
    return Expanded(flex:1,child:wbv);
  }

}

String parseText(String split) {
  print("split0: " + split);

  split = split.split("\"><p>")[1].split("</p>\\n</div></div></div>")[0];

  print("split1: " + split);

  split.replaceAll("<strong>", "").replaceAll("<br>", "").replaceAll("\\n", "")
      .replaceAll("<p>", "").replaceAll("</strong>", "").replaceAll("</p>", "")
      .replaceAll("&#8230;", "...").replaceAll("&#8220;", "„").replaceAll(
      "&#8221;", "“").replaceAll("<br />", "").replaceAll("<a href=\"", "")
      .replaceAll("\">", "")
      .replaceAll("</a>", "");


  String split_ = split;

  List<String> lst = (parse(parse(split_).body.text).documentElement.text)
      .split(";}");

  //print(lst);

  split_ = lst[lst.length - 1];

  if (!(split_.toLowerCase().contains("a") ||
      split_.toLowerCase().contains("e") ||
      split_.toLowerCase().contains("i") ||
      split_.toLowerCase().contains("o") ||
      split_.toLowerCase().contains("u"))) {
    try {
      split = split.split("\"><p>")[1].split("</p>")[0];

      //print("split1: " + split);

      split.replaceAll("<strong>", "").replaceAll("<br>", "").replaceAll(
          "\\n", "").replaceAll("<p>", "").replaceAll("</strong>", "")
          .replaceAll("</p>", "").replaceAll("<em>", "").replaceAll("</em>", "")
          .replaceAll("&#8230;", "...").replaceAll("&#8220;", "„").replaceAll(
          "&#8221;", "“").replaceAll("&#8211;", "-").replaceAll("<br />", "")
          .replaceAll("<a href=\"", "").replaceAll("\">", "")
          .replaceAll("</a>", "");

      String split__ = split;

      parse(parse(split__).body.text).documentElement.text;

      return split;
    } catch (Error) {
      return "Hinweis: Diese Seite enthält keinen Text ...";
    }
  } else {
    return split_;
  }

  if (split.contains("div")) {
    return split.split("<div")[0]; //TODO: Get rid of the f****** html
  } else {
    return split;
  }

  return split.split("text fusion-text")[1].split("</p>\n</div></div></div>")[0]
      .split(
      "<p>")[1]; /*replaceAll("<strong>", "").replaceAll("<br>", "").replaceAll("\\n", "").replaceAll("<p>", "").replaceAll("</strong>", "").replaceAll("</p>", "").replaceAll("&#8230;", "...").replaceAll("&#8220;", "„").replaceAll("&#8221;", "“").replaceAll("<br />", "")*/ //.replaceAllMapped(RegExp("r'<(.*?)>'"), (match) {return '"${match.group(0)}"';});

}

}

Widget wBarC(){
  if(wCopynote.isNotEmpty){
    return Row(children:[Icon(wIcon),SizedBox(width:15),Column(children:[Text(wTitleBar),Text(wCopynote, style:TextStyle(fontSize:7))])]);
  } else {
    return Row(children:[Icon(wIcon),SizedBox(width:15),Text(wTitleBar),]);
  }
}

class Passwords extends StatefulWidget {

  @override
  _PasswordsState createState() => _PasswordsState();

}

loadCredidentials() async {

  iservuser = await storage.read(key: "iserv-username");

  iservpassword = await storage.read(key: "iserv-password");

  dsbuser = await storage.read(key: "dsb-username");

  dsbpassword = await storage.read(key: "dsb-password");

}

class _PasswordsState extends State<Passwords>{

  final _formKey = GlobalKey<FormState>();

  TextEditingController iservusr = new TextEditingController();

  TextEditingController iservpass = new TextEditingController();

  TextEditingController dsbusr = new TextEditingController();

  TextEditingController dsbpass = new TextEditingController();

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  void getTruth() async{

  }

  @override
  Widget build(BuildContext context){

    getTruth();

    if(reset){
      iservusr.text = iservuser;
      iservpass.text = iservpassword;
      dsbusr.text = dsbuser;
      dsbpass.text = dsbpassword;
    }

    return MaterialApp(

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        /* dark theme settings */
      ),

      themeMode: ThemeMode.system,

      title: 'HGF',

      home: homeWidget(context),

    );

  }

  Widget homeWidget(BuildContext context){
    /*if(prefs.containsKey("is-logged-in")){
      return HGFHome();
    } else {*/
      return FutureBuilder(
        future: prefs,
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {if(snapshot.hasData & !snapshot.data.containsKey("is-logged-in")){return Scaffold(body:Form(

          key: _formKey,

          child: Padding(padding: EdgeInsets.all(30), child: ListView(children:[Column(mainAxisAlignment: MainAxisAlignment.center,

            children: [

              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 100,
                ),
                child: Image.network("https://hardenberg-gymnasium.de/wp-content/uploads/2020/12/HGF-Logo.jpg"),
              ),

              Padding(padding: EdgeInsets.all(20), child: Text("IServ Login", style: GoogleFonts.montserrat(fontSize: 40))),

              Padding(padding:EdgeInsets.all(10), child:
              TextFormField(

                controller: iservusr,

                decoration: InputDecoration(

                  filled: true,

                  icon: Icon(Icons.person),

                  labelText: "IServ - Benutzername",

                  hintText: "Klaus Ghünter Bernd Schmit Peter Harald Müller",

                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Bitte Vor- und Nachnamen kleingeschrieben und durch Punkt getrennt eingeben.';
                  }
                  if (!value.contains(".")){
                    return "Vor- und Nachname müssen durch einen Punkt getrennt sein";
                  }
                  return null;
                },

              )),

              Padding(padding:EdgeInsets.all(10), child:
              TextFormField(

                controller: iservpass,

                obscureText: true,

                decoration: InputDecoration(

                  filled: true,

                  icon: Icon(Icons.vpn_key),

                  labelText: "IServ - Passwort",

                  hintText: "Dein Schlüssel zur digitalen Schule",

                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Passwort darf nicht leer sein!';
                  }
                  return null;
                },

              )),

              Divider(),

              Padding(padding: EdgeInsets.all(20), child: Text("DSB Login", style: GoogleFonts.montserrat(fontSize: 40))),

              Padding(padding:EdgeInsets.all(10), child:
              TextFormField(

                controller: dsbusr,

                decoration: InputDecoration(

                  filled: true,

                  border: OutlineInputBorder(),

                  icon: Icon(Icons.login),

                  labelText: "DSB - Kennung",

                  hintText: "Ausweis, bitte!",

                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Dies ist ein Pflichtfeld!';
                  }
                  return null;
                },

              )),

              Padding(padding:EdgeInsets.all(10), child:
              TextFormField(

                controller: dsbpass,

                obscureText: true,

                decoration: InputDecoration(

                    filled: true,

                    icon: Icon(Icons.vpn_key_outlined),

                    border: OutlineInputBorder(),

                    labelText: "DSB - Passwort",

                    hintText: "Streng geheim !!!11!"

                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Streng geheime Felder sind ungemein wichtig! Bitte ausfüllen!';
                  }
                  return null;
                },

              )),

              Padding(padding:EdgeInsets.all(10), child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    child: Padding(child:Text("Abbrechen"),padding:EdgeInsets.all(15)),
                    onPressed: (){
                      Navigator.of(context).pop(context);
                      if(!reset){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HGFHome()));
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () async {
                    if(_formKey.currentState.validate()){
                      if(reset){
                        storage.deleteAll();
                        reset = false;
                      }
                      snapshot.data.setString("is-logged-in", "yes");
                      storage.write(key: "iserv-username", value: iservusr.text);
                      storage.write(key: "iserv-password", value: iservpass.text);
                      storage.write(key: "dsb-username", value: dsbusr.text);
                      storage.write(key: "dsb-password", value: dsbpass.text);
                      loadCredidentials();
                      Navigator.of(context).pop(context);
                      if(!reset){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HGFHome()));
                      }
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Bitte gib die Daten an!"), action: SnackBarAction(label: "Nein Danke!😡", onPressed: (){Navigator.of(context).pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => HGFHome()));},),));
                    }
                  }, child: Padding(child:Text("Speichern"),padding:EdgeInsets.all(15))),
                ],
              ))

            ],

          )

          ],),),),);
        } else if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Konnte Daten nicht laden!\nBitte App neustarten."),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Column(children:[SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),Text("Konnte Daten nicht laden!\nBitte App neustarten.")
              ]),
            ),
          );
        }
      });
    }
  }


class WInfo extends StatelessWidget {

  void fetchPage(int _page, BuildContext context) async {

    page = _page;

    try {

      if(page < 1){

        page = 1;

        final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Die angeforderte Seite existiert nicht!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

        Scaffold.of(context).showSnackBar(snackBar);

      }

      if(page >= 7){

        page = 6;

        final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Die angeforderte Seite existiert nicht!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

        Scaffold.of(context).showSnackBar(snackBar);

      }

      String url = 'https://hardenberg-gymnasium.de/wp-json/wp/v2/posts/?_embed&per_page=10&page=' + _page.toString();

      Response response = await get(url);

      json = jsonDecode(response.body);

    } catch (Error){

      final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Fehler! Bitte eine andere Seite auswählen!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

      Scaffold.of(context).showSnackBar(snackBar);

    }

    fetchPageAllowed = true;

  }

  BottomAppBar bAppBar(BuildContext context){
    if(wAppBar != 1){
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

          Tooltip(message: "Nachrichten aus der Schule", child:FlatButton(child: ConstrainedBox(constraints:BoxConstraints(maxHeight: 55),child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[Icon(Icons.message, size: 30, color: Colors.blue), Text("Neuigkeiten", style:GoogleFonts.montserrat(fontSize: 9, color: Colors.blue))])), onPressed: (){fetchPage(page, context);},),),

          Tooltip(message: "Zur Schulcloud (Digitales Schülerportal)", child:FlatButton(child: ConstrainedBox(constraints:BoxConstraints(maxHeight: 55),child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[Icon(Icons.cloud, size: 30, color: Colors.orangeAccent), Text("Schulcloud", style:GoogleFonts.montserrat(fontSize: 9, color: Colors.orangeAccent))])), onPressed: (){wUrl = "https://hardenberg-gymnasium.schule/iserv/";
          wTitleBar = "Schulserver";
          _controller.jumpToPage(1);}),),

          Tooltip(message: "Informationen zu Änderungen am Unterrichtsablauf", child:FlatButton(child: ConstrainedBox(constraints:BoxConstraints(maxHeight: 55),child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children:[Icon(Icons.list_alt, size: 30, color: Colors.green), Text("Vertretungsplan", style:GoogleFonts.montserrat(fontSize: 9, color: Colors.green))])), onPressed: (){wUrl = "https://www.dsbmobile.de/Login.aspx";
          wTitleBar = "Vertretungsplan";
          wIcon = Icons.list_alt;
          wCopynote = "© heinekingmedia GmbH";
          wBlackList.add("https://play.google.com/");
          wBlackList.add("https://apps.apple.com/");
          wBlackList.add("https://www.apple.com/app-store/");
          wBlackList.add("https://itunes.apple.com/");
          Navigator.push(context, MaterialPageRoute(builder: (context) => WInfo()));}),),


        ],),);
    } else {
      wAppBar = 0;
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      extendBody: true,

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      bottomNavigationBar: bAppBar(context),

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: wBarC(),

        backgroundColor: Colors.green,

      ),

      body: Center(

        child: webvAK(wUrl, "", wBlackList),

      ),

    );

  }

}

class IServState extends State<IServ> {
  String webViewUrl = "https://hardenberg-gymnasium.schule/iserv/";
  WebViewController controller;
  @override
  Widget build(BuildContext context) {
    String wvu = webViewUrl;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Neue E-Mail",
        child: Icon(Icons.add),
        onPressed: () {
          newMail();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          IconButton(
            tooltip: "News",
            splashColor: randomcolor(),
            icon: Row(children:[Icon(Icons.arrow_back),Icon(Icons.message)]),
            onPressed: () {
              _controller.jumpToPage(0);
            },
          ),
          Row(children:[Icon(Icons.cloud), SizedBox(width: 15),Column(children:[Text("Schulserver"),
          Text("© IServ GmbH", style: TextStyle(fontSize: 7)),]),]),
            IconButton(
              tooltip: "Vertretungsplan",
              splashColor: randomcolor(),
              icon: Row(children:[Icon(Icons.list),Icon(Icons.arrow_forward)]),
              onPressed: () {
                _controller.jumpToPage(2);
              },
            ), ],),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              tooltip: "Aufgaben",
              icon: Icon(Icons.paste, color:randomcolor()),
              onPressed: () {
                openExercise();
              },
            ),
            IconButton(
              tooltip: "E-Mails schreiben und empfangen",
              icon: Icon(Icons.mail, color:randomcolor()),
              onPressed: () {
                openMail();
              },
            ),
            IconButton(
              tooltip: "Chatnachrichten",
              icon: Icon(Icons.messenger_outlined, color:randomcolor()),
              onPressed: () {
                openMessenger();
              },
            ),
            IconButton(
              tooltip: "Systemnachrichten",
              icon: Icon(Icons.notifications, color:randomcolor()),
              onPressed: () {
                openNotifications();
              },
            ),
            IconButton(
              tooltip: "Einstellungen",
              icon: Icon(Icons.settings, color:randomcolor()),
              onPressed: () {
                openSettings();
              },
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
      body: checkWeb(wvu)
    );
  }

  void rememberMeIServ() async {

    String url = await controller.currentUrl();

    if(url.startsWith("https://hardenberg-gymnasium.schule/iserv/app/login")){
      
      controller.evaluateJavascript("document.getElementById(\"remember_me\").checked = true");

      controller.evaluateJavascript("document.getElementById(\"remember_me\").disabled = true");

      controller.evaluateJavascript("document.getElementsByClassName(\"form-control\")._username.value = \"" + iservuser + "\";");

      controller.evaluateJavascript("document.getElementsByClassName(\"form-control\")._password.value = \"" + iservpassword + "\";");

      controller.evaluateJavascript("document.getElementsByClassName(\"btn btn-primary\").item(0).click();");

    }

  }

  Widget checkWeb(String wvu){
    if(kIsWeb){
      return OutlineButton(color: Colors.green, splashColor: Colors.greenAccent, child: Row(children: [Icon(Icons.cloud), Text("Zur Schulcloud ...", style: GoogleFonts.montserrat(fontSize: 25),)]),);
    } else {
      return WebView(
        userAgent: "HGF-IServ",
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: wvu,
        onPageFinished: (url){
          if(url.startsWith("https://hardenberg-gymnasium.schule/iserv/app/login")){
            controller.evaluateJavascript("document.getElementById(\"remember_me\").checked = true");
            controller.evaluateJavascript("document.getElementById(\"remember_me\").disabled = true");
            controller.evaluateJavascript("document.getElementById(\"remember_me\").checked = true");
            controller.evaluateJavascript("document.getElementById(\"remember_me\").disabled = true");
            controller.evaluateJavascript("document.getElementsByClassName(\"form-control\")._username.value = \"" + iservuser + "\";");
            controller.evaluateJavascript("document.getElementsByClassName(\"form-control\")._password.value = \"" + iservpassword + "\";");
            controller.evaluateJavascript("document.getElementsByClassName(\"btn btn-primary\").item(0).click();");
          }
        },
        onWebViewCreated: (WebViewController webViewController) { controller = webViewController; }
      );
    }
  }

  void newMail() {
    this.setState(() {
      webViewUrl = "https://hardenberg-gymnasium.schule/iserv/mail/compose/";
      controller.loadUrl(webViewUrl);
    });
  }

  void openMail() {
    this.setState(() {
      webViewUrl = "https://hardenberg-gymnasium.schule/iserv/mail/";
      controller.loadUrl(webViewUrl);
    });
  }

  void openMessenger() {
    this.setState(() {
      webViewUrl = "https://hardenberg-gymnasium.schule/iserv/messenger/";
      controller.loadUrl(webViewUrl);
    });
  }

  void openNotifications() {
    this.setState(() {
      webViewUrl = "https://hardenberg-gymnasium.schule/iserv/profile/notifications/";
      controller.loadUrl(webViewUrl);
    });
  }

  void openSettings() {
    this.setState(() {
      webViewUrl = "https://hardenberg-gymnasium.schule/iserv/profile/";
      controller.loadUrl(webViewUrl);
    });
  }

  void openExercise() {
    webViewUrl = "https://hardenberg-gymnasium.schule/iserv/exercise/";
    this.setState(() {
      controller.loadUrl(webViewUrl);
    });
  }
}

Color randomcolor(){
  List colors = Colors.accents;
  Random random = new Random();
  return colors[random.nextInt(colors.length-1)];
}

class IServ extends StatefulWidget {
  @override
  IServState createState() => IServState();
}

class Posts extends StatefulWidget{

  _Posts createState() => _Posts();

}

class _Posts extends State<Posts>{

  void fetchPage(int _page, BuildContext context) async {

    page = _page;

    try {

      if(page < 1){

        page = 1;

        final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Die angeforderte Seite existiert nicht!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

        Scaffold.of(context).showSnackBar(snackBar);

      }

      if(page >= 7){

        page = 6;

        final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Die angeforderte Seite existiert nicht!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

        Scaffold.of(context).showSnackBar(snackBar);

      }

      String url = 'https://hardenberg-gymnasium.de/wp-json/wp/v2/posts/?_embed&per_page=10&page=' + _page.toString();

      Response response = await get(url);

      json = jsonDecode(response.body);

      refresh();

    } catch (Error){

      final snackBar = SnackBar(backgroundColor: Colors.black, content: Row( children: [ Icon(Icons.error), Text('  Fehler! Bitte eine andere Seite auswählen!', style: GoogleFonts.montserrat(color: Colors.white),) ],),);

      Scaffold.of(context).showSnackBar(snackBar);

    }

    fetchPageAllowed = true;

  }

  BuildContext mainContext;

  BoxConstraints adaptiveCardWidth(){
    double width = MediaQuery.of(mainContext).size.width;
    if(width < 900 && width >= 600){
      return BoxConstraints(maxWidth: width/2);
    } else if(width >= 900 && (width / 450) <= 2){
      return BoxConstraints(maxWidth: 450);
    } else if(width >= 900 && (width / 450) > 2){
      return BoxConstraints(maxWidth: width / (width / 450));
    } else{
      return BoxConstraints();
    }
  }

  void open(String string, BuildContext context, int idi, String txt) {

    try {
      bartext = txt.replaceAll("&#8230;", "...").replaceAll("&#8220;", "„").replaceAll("&#8221;", "“").replaceAll("&#8211;", "-");

      id = idi;
      try {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WebView_()));
      }catch(error){
          print("Post opening error!");
      }
    } catch (Error){
      SnackBar snackbar = new SnackBar(
        content: Row(children:[Icon(Icons.error),Text(" Leider kann dieser Post nicht angezeigt werden! :/\nWir arbeiten an einer baldigen Lösung.")]),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      print("Post konnte nich geöffnet werden!");
    }

  }

  String parseDate(String str) {

    String year = str.substring(0, 4);

    String month = str.substring(5, 7);

    String day = str.substring(8, 10);

    String hour = str.substring(11, 13);

    String minute = str.substring(14, 16);

    return day + "." + month + "." + year + " " + hour + ":" + minute;

  }

  void refresh(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    mainContext = context;
    List<int> l = List<int>.empty(growable: true);
    List<Color> colors = List<Color>.empty(growable: true);

    for (int j = 0; j <= 9; j++) {
      l.add(j);
      colors.add(randomcolor());
      //print(json[j]['_embedded'].toString().split("source_url:")[1].split("}")[0].substring(1).substring(0, json[j]['_embedded'].toString().split("source_url:")[1].split("}")[0].substring(1).lastIndexOf("-")) + ".jpg");
      //print(json[j]['_embedded']['wp:featuredmedia'][0]['source_url'].toString());
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (int i in l)
          ConstrainedBox(
            constraints: adaptiveCardWidth(),
            child: Card(
              child: InkWell(
                splashColor: colors[i].withAlpha(90),
                onTap: () {
                  open(
                      json[i]['link'].toString(),
                      context,
                      i,
                      json[i]['title']
                          .toString()
                          .replaceAll("{rendered: ", "")
                          .replaceAll("}", "")
                          .replaceAll("&#8230;", "...")
                          .replaceAll("&#8220;", "„")
                          .replaceAll("&#8221;", "“"));
                },
                child: Column(
                  children: [
                    Hero(tag: json[i]['_embedded']['wp:featuredmedia'][0]
                    ['source_url']
                        .toString(), child: Image.network(json[i]['_embedded']['wp:featuredmedia'][0]
                            ['source_url']
                        .toString()),),
                    ListTile(
                      title: Text(json[i]['title']
                          .toString()
                          .replaceAll("{rendered: ", "")
                          .replaceAll("}", "")
                          .replaceAll("&#8230;", "...")
                          .replaceAll("&#8220;", "„")
                          .replaceAll("&#8221;", "“")
                          .replaceAll("<strong>", "")
                          .replaceAll("<br>", "")
                          .replaceAll("\\n", "")
                          .replaceAll("<p>", "")
                          .replaceAll("</strong>", "")
                          .replaceAll("</p>", "")
                          .replaceAll("&#8230;", "...")
                          .replaceAll("&#8220;", "„")
                          .replaceAll("&#8221;", "“")
                          .replaceAll("&#8211;", "-")
                          .replaceAll("<br />", "")
                          .replaceAll("<a href=\"", "")
                          .replaceAll("\">", "")
                          .replaceAll("</a>", "")),
                      subtitle: Text(parseDate(json[i]['date']
                          .toString()
                          .replaceAll("<strong>", "")
                          .replaceAll("<br>", "")
                          .replaceAll("\\n", "")
                          .replaceAll("<p>", "")
                          .replaceAll("</strong>", "")
                          .replaceAll("</p>", "")
                          .replaceAll("&#8230;", "...")
                          .replaceAll("&#8220;", "„")
                          .replaceAll("&#8221;", "“")
                          .replaceAll("&#8211;", "-")
                          .replaceAll("<br />", "")
                          .replaceAll("<a href=\"", "")
                          .replaceAll("\">", "")
                          .replaceAll("</a>", "")
                          .replaceAll("T", " ")
                          .replaceAll("-", "."))),
                      leading: Icon(Icons.add, color: colors[i]),
                    )
                  ],
                ),
              ),
            ),
          ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (fetchPageAllowed) {
                fetchPageAllowed = false;
                fetchPage(--page, context);
                refresh();
              }
            },
          ),
          SizedBox(width: 20),
          Text(
            page.toString(),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              if (fetchPageAllowed) {
                fetchPageAllowed = false;
                fetchPage(++page, context);
                refresh();
              }
            },
          )
        ])
      ],
    );
  }

}

void showSettings(BuildContext context){

  /*Scaffold.of(context).showBottomSheet((context){
    return BottomSheet(
        onClosing: (){},
        builder: (context) {
          /*final theme = Theme.of(context);
          // Using Wrap makes the bottom sheet height the height of the content.
          // Otherwise, the height will be half the height of the screen.
          return Wrap(
            children: [
              ListTile(
                title: Text(
                  'Header',
                  style: theme.textTheme.subtitle1
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
                tileColor: theme.colorScheme.primary,
              ),
              ListTile(
                title: Text('Title 1'),
              ),
              ListTile(
                title: Text('Title 2'),
              ),
              ListTile(
                title: Text('Title 3'),
              ),
              ListTile(
                title: Text('Title 4'),
              ),
              ListTile(
                title: Text('Title 5'),
              ),
            ],
          );*/return Text("test");
        },
    );
  });*/

}

class HGFHome extends StatelessWidget{

  BuildContext mainContext;

  Widget home(BuildContext context){

    if(internet){
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          Scaffold(
            extendBody: true,

            //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

            bottomNavigationBar: BottomAppBar(
              //shape: CircularNotchedRectangle(),
              //clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: "Nachrichten aus der Schule",
                    child: FlatButton(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 55),
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.message_outlined,
                                    size: 30, color: Colors.blue),
                                Text("Neuigkeiten",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 9, color: Colors.blue))
                              ])),
                      onPressed: () {
                        /*fetchPage(page, context);*/
                      },
                    ),
                  ),
                  Tooltip(
                    message: "Zur Schulcloud (Digitales Schülerportal)",
                    child: FlatButton(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 55),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.cloud,
                                      size: 30, color: Colors.orangeAccent),
                                  Text("Schulcloud",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 9,
                                          color: Colors.orangeAccent))
                                ])),
                        onPressed: () {
                          wUrl = "https://hardenberg-gymnasium.schule/iserv/";
                          wTitleBar = "Schulserver";
                          _controller.jumpToPage(
                              1); //Navigator.push(context, MaterialPageRoute(builder: (context) => IServ()));
                        }),
                  ),
                  Tooltip(
                    message:
                    "Informationen zu Änderungen am Unterrichtsablauf",
                    child: FlatButton(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 55),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.list,
                                      size: 30, color: Colors.green),
                                  Text("Vertretungsplan",
                                      style:
                                      GoogleFonts.montserrat(fontSize: 9, color: Colors.green))
                                ])),
                        onPressed: () {
                          wUrl = "https://www.dsbmobile.de/Login.aspx";
                          wTitleBar = "Vertretungsplan";
                          wIcon = Icons.list_alt;
                          wCopynote = "© heinekingmedia GmbH";
                          wBlackList.add("https://play.google.com/");
                          wBlackList.add("https://apps.apple.com/");
                          wBlackList.add("https://www.apple.com/app-store/");
                          wBlackList.add("https://itunes.apple.com/");
                          _controller.jumpToPage(
                              2); //Navigator.push(context, MaterialPageRoute(builder: (context) => WInfo()));
                        }),
                  ),
                ],
              ),
            ),

            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: pages(context),
              ),
            ),

            /*floatingActionButton: FloatingActionButton(

              child: Icon(Icons.info_outline),

              backgroundColor: Colors.deepPurple,

              splashColor: Colors.pink,

              tooltip: "Info",

              onPressed: () {

                showContactDialog(context);

              },

            ),*/

            appBar: AppBar(
              title: Text('HGF'),
            ),

            body: Builder(
              builder: (context) => Center(
                child: ListView(children: [Posts()]),
              ),
            ),
          ),
          IServ(),
          Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
            FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: "Nachrichten aus der Schule",
                    child: FlatButton(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 55),
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.message,
                                    size: 30, color: Colors.blue),
                                Text("Neuigkeiten",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 9, color: Colors.blue))
                              ])),
                      onPressed: () {
                        _controller.jumpToPage(0);
                      },
                    ),
                  ),
                  Tooltip(
                    message: "Zur Schulcloud (Digitales Schülerportal)",
                    child: FlatButton(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 55),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.cloud,
                                      size: 30, color: Colors.orangeAccent),
                                  Text("Schulcloud",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 9,
                                          color: Colors.orangeAccent))
                                ])),
                        onPressed: () {
                          wUrl = "https://hardenberg-gymnasium.schule/iserv/";
                          wTitleBar = "Schulserver";
                          _controller.jumpToPage(1);
                        }),
                  ),
                  Tooltip(
                    message:
                    "Informationen zu Änderungen am Unterrichtsablauf",
                    child: FlatButton(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 55),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.list_alt,
                                      size: 30, color: Colors.green),
                                  Text("Vertretungsplan",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 9, color: Colors.green))
                                ])),
                        onPressed: () {}),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Row(children:[Icon(Icons.list),SizedBox(width: 15),Column(children:[Text("Vertretungsplan"),Text("© heinekingmedia GmbH", style: TextStyle(fontSize: 7))])]),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: webvAK(
                  "https://www.dsbmobile.de/Login.aspx", "", wBlackList),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [Icon(Icons.signal_cellular_connected_no_internet_4_bar, size: 50), Text("Kein Internet", style: GoogleFonts.germaniaOne(fontSize: 40)), Text("Bitte starte die App neu, wenn du eine Internetverbindung hast ...", style: GoogleFonts.montserrat(color: Colors.red))],
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    mainContext = context;

    double cwidth = 0;

    MaterialApp app = MaterialApp(

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        /* dark theme settings */
      ),

      themeMode: ThemeMode.system,

      title: 'HGF',

      home: home(context),

    );

    return app;

  }

  void open(String string, BuildContext context, int idi, String txt) {

    bartext = txt.replaceAll("&#8230;", "...").replaceAll("&#8220;", "„").replaceAll("&#8221;", "“").replaceAll("&#8211;", "-");

    id = idi;

    Navigator.push(context, MaterialPageRoute(builder: (context) => WebView_()));

  }

  String parseDate(String str) {

    String year = str.substring(0, 4);

    String month = str.substring(5, 7);

    String day = str.substring(8, 10);

    String hour = str.substring(11, 13);

    String minute = str.substring(14, 16);

    return day + "." + month + "." + year + " " + hour + ":" + minute;

  }

  List<Widget> pages(BuildContext context) {

    ThemeData td = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.blue.withAlpha(60),
    );
    ThemeData td1 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.red.withAlpha(60),
    );
    ThemeData td2 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.yellow.withAlpha(60),
    );
    ThemeData td3 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.green.withAlpha(60),
    );
    ThemeData td4 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.deepPurple.withAlpha(60),
    );
    ThemeData td5 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
    );
    ThemeData td6 = ThemeData(
      brightness: MediaQuery.of(context).platformBrightness,
      primaryColor: Colors.green,
      splashColor: Colors.grey.withAlpha(60),
    );

    ListTile(
      leading: Icon(Icons.message),
      title: Text('Neuigkeiten'),
      onTap: () {

      },
    );

    List<Widget> widgets = new List<Widget>.empty(growable: true);

    widgets.add(DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Image.network("https://hardenberg-gymnasium.de/wp-content/uploads/2020/12/HGF-Logo.jpg"),
    ));
    widgets.add(Theme(data:td,child:ListTile(
        leading: Icon(Icons.message, color: Colors.blue),
        title: Text('Neuigkeiten',style: GoogleFonts.montserrat(color: Colors.blue),),
        onTap: () {
          _controller.jumpToPage(0);
        },
      )));
    widgets.add(Theme(data:td1,child:ListTile(
        leading: Icon(Icons.workspaces_outline, color: Colors.red),
        title: Text('AK IT',style: GoogleFonts.montserrat(color: Colors.red),),
        onTap: () {
          wTitleBar = /*"bester AK @ HGF"*/"AK IT";
          wUrl = "https://blog.raupi.net";
          wCopynote = "";
          wAppBar = 1;
          wIcon = Icons.workspaces_outline;
          Navigator.push(context, MaterialPageRoute(builder: (context) => WInfo()));
        },
      )));
    widgets.add(Theme(data:td2,child:ListTile(
      leading: Icon(Icons.cloud, color: Colors.yellow),
      title: Text('Schulserver',style: GoogleFonts.montserrat(color: Colors.yellow),),
      onTap: () {
        wUrl = "https://hardenberg-gymnasium.schule/iserv/";
        wTitleBar = "Schulserver";
        _controller.jumpToPage(1);
      },
    )));
    widgets.add(Theme(data:td3,child:ListTile(
      leading: Icon(Icons.list_alt, color: Colors.green),
      title: Text('Vertretungsplan',style: GoogleFonts.montserrat(color: Colors.green),),
      onTap: () {
        wUrl = "https://www.dsbmobile.de/Login.aspx";
        wTitleBar = "Vertretungsplan";
        wIcon = Icons.list_alt;
        wCopynote = "© heinekingmedia GmbH";
        wBlackList.add("https://play.google.com/");
        wBlackList.add("https://apps.apple.com/");
        wBlackList.add("https://www.apple.com/app-store/");
        wBlackList.add("https://itunes.apple.com/");
        _controller.jumpToPage(2);//Navigator.push(context, MaterialPageRoute(builder: (context) => WInfo()));
      },
    )));
    widgets.add(Theme(data:td4,child:ListTile(
      leading: Icon(Icons.calendar_today, color: Colors.deepPurple),
      title: Text('Termine', style:GoogleFonts.montserrat(color: Colors.deepPurple)),
      onTap: (){
        wUrl = "https://hardenberg-gymnasium.de/termine/";
        wTitleBar = "Termine";
        wIcon = Icons.calendar_today;
        wCopynote = "";
        wBlackList.add("https://play.google.com/");
        wBlackList.add("https://apps.apple.com/");
        wBlackList.add("https://www.apple.com/app-store/");
        wBlackList.add("https://itunes.apple.com/");
        wAppBar = 1;
        Navigator.push(context, MaterialPageRoute(builder: (context) => WInfo()));
      },
    ),));
    widgets.add(Theme(data:td5,child:ListTile(
      leading: Icon(Icons.info_outline),
      title: Text('Info'),
      onTap: (){
        showContactDialog(context);
      },
    ),));
    widgets.add(Theme(data:td6,child:ListTile(
      leading: Icon(Icons.settings, color: Colors.grey),
      title: Text('Zugangsdaten ändern', style:GoogleFonts.montserrat(color: Colors.grey)),
      onTap: (){
        //showSettings(context);
        reset = true;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Passwords()));
      },
    ),));

    /*for (int i = 0; i <= 99; i++) {
      widgets.add(Theme(data:td,child:ListTile(
        leading: Icon(Icons.pages),
        title: Text(page_json[i]['title']['rendered']),
        onTap: () {
          _launchURL(page_json[i]['link']);
        },
      ));
    }*/ //Alle Seiten der HGF Webseite idexieren & sichten. Derzeit wegen Fehlkonfiguration der HGF-Seite deaktiviert ...
    return widgets;
  }

}
