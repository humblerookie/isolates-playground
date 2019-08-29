

import 'dart:isolate';

main(args, SendPort port){
  port.send(args[0]);
  print("Other isolate just arrived");
}