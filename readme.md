# Curves

## Description
A simple project done using x86-64 assembler and C++/Qt for academic purpose.
Maximum filter is implemented in x64 assembler. It allows to filter bmp images with various filter frame size <0,10>. It was my first contact w x86 assembly for Warsaw University of Technology.
GUI is very basic. It was made in Qt/C++.


## Build and run
### Requierments 
* Linux OS
* Qt libs
* nasm compiler

### Building procedure
1. Build the project using 'gradle build' command
2. Go to gradle build directory 'cd build/libs'
3. Run either server or client: 
* Server by typing `java -jar Curves-1.0.jar server port_number`.
* Client by typing `java -jar Curves-1.0.jar client port_number`.
* Port_number can be any free udp port apart from 9877

## Using program





