# MaxFilter-x64

## Description
A simple project done using x86-64 assembler and C++/Qt for academic purpose.
Maximum filter is implemented in x64 assembler. It allows to filter bmp images with various filter frame size <0,10>. It was my first contact w x86 assembly for Warsaw University of Technology.
GUI is very basic. It was made in Qt/C++.


## Build and run
### Requierments 
* Linux OS
* Qt5 libs 
* nasm compiler

### Building procedure
1. Create Makefile by executing `qmake`
2. execute `make`
3. Run app `./filtr`

## Using app
App is used simply by typing in file path. And clicking "open". Filtering takes place by moving the slider. File must have .bmp format with RGB colors.





