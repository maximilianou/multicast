import 'dart:io';

void main(List<String> args) {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
      .then((RawDatagramSocket socket) {
    print('Sending from ${socket.address.address}:${socket.port}');
    int port = 4444;
    socket.send(
        'Hello from UDP land!\n'.codeUnits, InternetAddress.loopbackIPv4, port);
  });
}
