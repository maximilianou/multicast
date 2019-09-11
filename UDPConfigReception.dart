import 'dart:io';
import 'dart:math';

RawDatagramSocket socket;
InternetAddress multicastAddress = InternetAddress("224.1.1.1");
int multicastPort = 6811;
InternetAddress ipLocal;
NetworkInterface wlanNetworkInterface;

Future<void> getHotspotConfiguration() async {
  List<NetworkInterface> networkInterfacesList =
      await NetworkInterface.list(type: InternetAddressType.any);

  var networkInterfaces = networkInterfacesList.where(
      (i) => 'mlan0' == i.name || 'wlan0' == i.name || 'enp1s0' == i.name);

  for (final network in networkInterfaces) {
    ipLocal = network.addresses[0];
    wlanNetworkInterface = network;
  }
}

//RECEPCION
Future receiveUDPMulticastTest() async {
  await getHotspotConfiguration();
  print("rec:: ipLocal:${ipLocal}  multicastPort:${multicastPort}");
  // ESTO FUNCIONA CON EL HOTSPOT (SI NO, LOS ENVIOS NO FUNCIONAN)
  await RawDatagramSocket.bind(ipLocal, multicastPort)
      .then((RawDatagramSocket s) {
    // RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastPort).then((RawDatagramSocket s) { // ESTO FUNCIONA CON WIFI
    socket = s;
  });
  await RawDatagramSocket.bind(multicastAddress, multicastPort)
      .then((RawDatagramSocket socket) {
    print('R::${socket.address.address}:${socket.port}');

    socket.multicastLoopback = false;
    socket.joinMulticast(multicastAddress, wlanNetworkInterface);

    socket.listen((RawSocketEvent e) {
      Datagram datagram = socket.receive();
      if (datagram == null) return;
      String message = String.fromCharCodes(datagram.data).trim();
      print('R::from::${datagram.address.address}:${datagram.port}: $message');
    });
  });
}

//
//ENVIO.
//
Future sendUDPMulticastTest() async {
  Random rng = Random();
  print("S::Socket UDP listo para enviar al grupo "
      "${multicastAddress.address}:$multicastPort");
  String msg = 'RESP::MOBILE::${rng.nextInt(1000)}';
  stdout.write("S:: $msg \n");
  socket.send('$msg\n'.codeUnits, multicastAddress, multicastPort);
}

void main() async {
  await receiveUDPMulticastTest();
  await sendUDPMulticastTest();
}
