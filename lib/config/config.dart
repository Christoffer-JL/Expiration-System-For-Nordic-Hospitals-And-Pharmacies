// Please do not push changes made to this file

class AppConfig {
  static const String apiIp = IPAddresses.digitalOcean;
  static const String apiPort = '3000';
  static const String apiUrl = 'http://${apiIp}:${apiPort}';
}

class IPAddresses {
  static const String localHost = '127.0.0.1';
  static const String digitalOcean = '104.248.81.249';
  static const String externalPi = '188.150.228.31';
  static const String internalPi = '192.168.0.105';
  static const String computer = ''; // Run ipconfig and choose IPv4
}
