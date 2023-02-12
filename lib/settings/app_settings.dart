
//? Titolo dell'app
String appTitle = 'Social App bloc';

//? Api endpoint
// String appApiEndpoint = 'http://192.168.1.101/api';
String appApiEndpoint = 'http://localhost/api';

//? Storage key for user
String userStorageKey = 'userStorageKey';

//? Storage key for chat list
String chatListStorageKey = 'chatListStorageKey';

//? Storage key for chat list
String chatMessageStorageKey = 'chatMessageStorageKey';

//? Rotte dell'app
Map<String, String> appRoutes = {
  "login": "/login",
  "signup": "/signup",
  "home": "/home",
  "chat": "/chat"
};

//? Lista delle rotte di autenticazione
List authenticationRoutes = [
  "/login",
  "/signup"
];

//? Path dello splash screen
String splashScreenPath = 'assets/splash_screen/chat_logo_loading.json';

//? Credenziali pusher
Map pusherSettings = {
  "apiKey": "e5b2c09eeb2fe2f7a670",
  "cluster": "eu"
};