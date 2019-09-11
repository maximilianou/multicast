import 'dart:io';

void main(List<String> args){
  print("Net::1");
  var inet_address; 
  NetworkInterface.list().then( ( inet ){
    
    print(inet);
    inet_address = inet.where((i)=> i.name  == 'mlan0' );
  });

  print("Net::8");

  RawDatagramSocket.bind(inet_address.addresses[0], 0).then((RawDatagramSocket socket){
    print('Sending from ${socket.address.address}:${socket.port}');
    int port = 6811;
    socket.send('Hello from UDP land!\n'.codeUnits, 
      InternetAddress.LOOPBACK_IP_V4, port);
  });

}
