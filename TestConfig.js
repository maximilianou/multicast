/*
   Multicast UDP broadcaster
   multicast_send.dart
*/
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:convert';

final jsonEncoder = JsonEncoder(); 

Future send(addr_ip, multicastPort) async {
  InternetAddress multicastAddress = new InternetAddress(addr_ip);
  Random rng = new Random();
  Map<String, Object> mensaje = {
 "__type": "GetCMIConfigRequest",
 "timeStamp": DateTime.now().toUtc().toIso8601String(),
 "sender": {
   "__type": "BaseStamp",
   "name": "vloud.sala.mobile",
   "id": "",
   "version": ""
 },
 "addressee": {
   "__type": "BaseStamp",
   "name": "vloud.sala.cmi",
   "id": "",
   "version": ""
 },
 "correlationId": 1
};

  Map<String, Object> mensaje2 = {"__type":"GetCMIConfigResponse",
  "timeStamp":"2019-09-25T14:36:14.331Z",
  "sender":{"__type":"BaseStamp","name":"vloud.sala.mobile","id":"","version":""},
  "addressee":{"__type":"BaseStamp","name":"vloud.sala.cmi","id":"","version":""},
  "body":{"__type":"CMIConfigDTO","version":"",
  "behavior":{"__type":"CMIBehaviorConfigDTO",
  "allowRepeatedLibEvents":false,
  "repeatedLibEventsEnableThreshold":1800000,
  "storageMetersTimeInterval":null,"reportDataInterval":900000,
  "purgeDataInterval":86400000,
  "aliveReceptionTimeoutInterval":5000,
  "aliveReceptionTimeoutMaxRetryCount":5,
  "aliveNotificationPeriod":5000,"metersHandling":[],
  "eventsHandling":[]},
  "core":{"__type":"CMICoreConfigDTO","Id":0,"salaId":0,
  "newsRetrievalPollingThreshold":5000,"updatePending":false,
  "staticConfig":{"__type":"StaticConfigContainerDTO","data":{"type":"object","required":true}},
  "localNetwork":{"__type":"WiFiNetworkDTO","SSID":"cebra-wifi","password":"vloud-rules","interface":"mlan0"},
  "backupNetwork":{"__type":"WiFiNetworkDTO","SSID":"","password":"","interface":""}},
  "egm":{"__type":"EGMLibConfigDTO","version":"",
  "core":{"__type":"EGMCoreLibConfigDTO","EGMId":"",
  "SASId":"","autoResetHandPayEnabled":false,
  "autoResetHandPayTopAmount":0,"forcedDenoValue":0,
  "forcedPaymentAmount":0,"dynamicFlags":[],
  "operationMode":"","currencyISOCode":"","billMeters":[]},
  "tito":{"__type":"EGMTitoLibConfigDTO"},
  "sala":{"__type":"EGMSalaLibConfigDTO","areaId":0},
  "taxes":{"__type":"EGMTaxLibConfigDTO"}},
  "hardwareDevices":[]},
  "correlationId":1};


  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
      .then((RawDatagramSocket s) {
    print("SEND:: "
        "${multicastAddress.address}:${multicastPort}");
    new Timer.periodic(new Duration(seconds: 2), (Timer t) {
      //Send a random number out every second
      String msg = ':: ${rng.nextInt(1000)}';
      stdout.write("Sending $msg  \r");
      print("SEND:: "
          " ${multicastAddress.address} : ${multicastPort} :: [${msg}]");
      s.send('${jsonEncoder.convert(mensaje2)}'.codeUnits, multicastAddress, multicastPort);
    });
  });
}

void receive(addr_ip, multicastPort) async {
  InternetAddress multicastAddress = new InternetAddress(addr_ip);
  RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastPort)
      .then((RawDatagramSocket socket) {
    print('RECIEVE:: ${socket.address.address} : ${socket.port} ');

    socket.joinMulticast(multicastAddress);
    print('RECIEVE::Multicast group joined');

    socket.listen((RawSocketEvent e) {
      Datagram d = socket.receive();
      if (d == null) return;

      String message = new String.fromCharCodes(d.data).trim();
      print(
          'RECIEVE::from ${d.address.address}:${d.port}: ${message}');
    });
  });
}

void main(List<String> args) {
//  send('239.10.10.100', 4545);
//  receive('239.10.10.100', 4545);
//  send('239.10.10.100', 7777);
//  receive('239.10.10.100', 7777);
//  send('232.2.2.2', 4545);
//  receive('232.2.2.2', 4545);
//  send('224.0.20.10', 6811);
//  receive('224.0.20.10', 6811);
  send('233.1.1.1', 6811);
  receive('233.1.1.1', 6811);
}
