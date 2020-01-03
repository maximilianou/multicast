/*
   Multicast UDP client
   multicast_receive.dart
*/
import 'dart:io';

void main(List args) {
  InternetAddress multicastAddress = new InternetAddress("239.10.10.100");
  int multicastPort = 4545;
  RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastPort)
      .then((RawDatagramSocket socket) {
    print('Datagram socket ready to receive');
    print('${socket.address.address}:${socket.port}');

    socket.joinMulticast(multicastAddress);
    print('Multicast group joined');

    socket.listen((RawSocketEvent e) {
      Datagram d = socket.receive();
      if (d == null) return;

      String message = new String.fromCharCodes(d.data).trim();
      print('Datagram from ${d.address.address}:${d.port}: ${message}');
    });
  });
}
