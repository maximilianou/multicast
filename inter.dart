import 'dart:io';

void main(List<String> args){
  print("Net::1");
  InternetAddress address; 
  NetworkInterface.list().then( ( inet){
    
    print(inet);
    if( inet.name == 'mlan0' ){
      address = inet.addresses[0];
    }
  });

  print("Net::8");

  RawDatagramSocket.bind(address, 0).then((RawDatagramSocket socket){
    print('Sending from ${socket.address.address}:${socket.port}');
    int port = 6811;
    socket.send('Hello from UDP land!\n'.codeUnits, 
      InternetAddress.LOOPBACK_IP_V4, port);
  });

}
