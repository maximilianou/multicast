/*
   Multicast UDP broadcaster
   multicast_send.dart
*/
import 'dart:io';
import 'dart:async';
import 'dart:math';

void main(List<String> args){
  InternetAddress multicastAddress = new InternetAddress('239.10.10.100');
  int multicastPort = 4545;
  Random rng = new Random();
  RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, 0).then((RawDatagramSocket s) {
    print("UDP Socket ready to send to group "
      "${multicastAddress.address}:${multicastPort}");

    new Timer.periodic(new Duration(seconds: 1), (Timer t) {
      //Send a random number out every second
      String msg = '${rng.nextInt(1000)}';
      stdout.write("Sending $msg  \r");
      s.send('$msg\n'.codeUnits, multicastAddress, multicastPort);
    });
  });
}
