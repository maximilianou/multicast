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

  var networkInterfaces = networkInterfacesList.where((i) => i.name == 'wlan0');

  for (final network in networkInterfaces) {
    ipLocal = network.addresses[0];
    wlanNetworkInterface = network;
  }
}

//RECEPCION
Future receiveUDPMulticastTest() async {
  await getHotspotConfiguration();

  // ESTO FUNCIONA CON EL HOTSPOT (SI NO, LOS ENVIOS NO FUNCIONAN)
  RawDatagramSocket.bind(ipLocal, multicastPort).then((RawDatagramSocket s) {
    // RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastPort).then((RawDatagramSocket s) { // ESTO FUNCIONA CON WIFI
    socket = s;
  });
  RawDatagramSocket.bind(multicastAddress, multicastPort)
      .then((RawDatagramSocket socket) {
    print('Datagram socket listo para recibir');
    print('${socket.address.address}:${socket.port}');

    socket.multicastLoopback = false;
    socket.joinMulticast(multicastAddress, wlanNetworkInterface);
    print('Multicast group joined');

    socket.listen((RawSocketEvent e) {
      Datagram datagram = socket.receive();
      if (datagram == null) return;

      String message = String.fromCharCodes(datagram.data).trim();
      print(
          'Datagrama de ${datagram.address.address}:${datagram.port}: $message');
    });
  });
}

//
//ENVIO.
//
Future sendUDPMulticastTest() async {
  Random rng = Random();

  print("Socket UDP listo para enviar al grupo "
      "${multicastAddress.address}:$multicastPort");

  String msg = 'RESPUESTA MOBILE:${rng.nextInt(1000)}';
  stdout.write("Enviando $msg  \r");
  socket.send('$msg\n'.codeUnits, multicastAddress, multicastPort);
}
