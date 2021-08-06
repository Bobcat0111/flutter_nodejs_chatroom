class AppConfig{
  bool isBigScreen=false;
  Enviroment enviroment=Enviroment.PROD;
  String get apiHost{
    switch(enviroment){
      case Enviroment.Local:
        return "http://127.0.0.1:8080";
      case Enviroment.DEV:
      case Enviroment.PROD:
        return "https://bobcat-chatserver.herokuapp.com";
    }
  }
}

enum Enviroment{
  Local,
  DEV,
  PROD,
}