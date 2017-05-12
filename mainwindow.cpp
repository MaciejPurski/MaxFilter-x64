#include "mainwindow.h"
#include <iostream>
#include<fstream>

MainWindow::MainWindow()
{
    inputBuf=nullptr;
    outputBuf=nullptr;
    label = new QLabel(QApplication::translate("windowlayout", "File path:"));
    lineEdit = new QLineEdit();
    layout1 = new QHBoxLayout();
    layout2 = new QHBoxLayout();
    layoutMain = new QVBoxLayout();
    button = new QPushButton("Open");
    slider = new QSlider(Qt::Horizontal);
    label2 = new QLabel("Frame size:");
    label3 = new QLabel();
    slider->setTickPosition(QSlider::TicksAbove);
    slider->setTickInterval(1);
    slider->setMaximum(10);
    lineEdit->setFixedWidth(300);
    slider->setFixedWidth(400);
    layout1->addWidget(label);
    layout1->addWidget(lineEdit);
    layout1->addWidget(button);
    layout2->addWidget(label2);
    layout2->addWidget(slider);

    layoutMain->addLayout(layout1);
    layoutMain->addLayout(layout2);
    connect(button, SIGNAL(clicked(bool)), this, SLOT(open()));
    this->setLayout(layoutMain);
    this->setWindowTitle(
        QApplication::translate("windowlayout", "Maximum Filter"));
    this->show();
}

MainWindow::~MainWindow()
{
    if(inputBuf!=nullptr)
        delete [] inputBuf;
    if(outputBuf!=nullptr)
        delete [] outputBuf;
}




void MainWindow::open()
{

    if(isOpened==true)
    {
        delete [] inputBuf;
        delete [] outputBuf;
    }
    std::string fname=lineEdit->text().toStdString();
    std::ifstream file (fname, std::ifstream::binary);
    length=0;
    if (!file.good())
    {
        std::cout<<"FAIL\n";
        return;
    }

        // get length of file:

    file.ignore( std::numeric_limits<std::streamsize>::max() );
    std::streamsize length2 = file.gcount();
    file.clear();   //  Since ignore will have set eof.
    file.seekg( 0, std::ios_base::beg );
    length=(int)length2;

    inputBuf = new uchar [length];
    outputBuf = new uchar[length];
    char* temp = reinterpret_cast<char*> (inputBuf);

    file.read(temp, length);
    file.close();
    for(int i=0; i<54; i++)
        outputBuf[i]=inputBuf[i];

    isOpened=true;


    slider->setValue(0);

    pixbuffer.loadFromData(inputBuf, length, "bmp");


    label3->setPixmap(pixbuffer);
    layoutMain->addWidget(label3);


    connect(slider, SIGNAL(valueChanged(int)), this, SLOT(filter(int)));

}


void MainWindow::filter(int frame)
{

    if(frame==0)
    {
         label3->setPixmap(pixbuffer);
        return;
        }

    int result = func(inputBuf, outputBuf, frame);


        pixOut.loadFromData(outputBuf, length, "bmp");
        label3->setPixmap(pixOut);


}



