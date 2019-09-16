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
 "timeStamp": (DateTime.now()).toString(),
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
      s.send('${jsonEncoder.convert(mensaje)}'.codeUnits, multicastAddress, multicastPort);
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
  send('224.1.1.1', 6811);
  receive('224.1.1.1', 6811);
}
