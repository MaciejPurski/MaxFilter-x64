#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtWidgets>


extern "C" int func(uchar* input, uchar* output, int fsize);


namespace Ui {
class MainWindow;
}

class MainWindow : public QDialog
{
    Q_OBJECT
public slots:
    void open();
    void filter(int frame);

public:
    explicit MainWindow();
    ~MainWindow();

private:
    QLabel *label, *label2;
    QSlider* slider;
    QLineEdit * lineEdit;
    QPushButton *button;
    QHBoxLayout *layout1, *layout2;
    QVBoxLayout *layoutMain;
    bool isOpened=false;
    uchar* inputBuf, *outputBuf;
    int length;
    QPixmap pixbuffer, pixOut;
    QLabel *label3;

};

#endif // MAINWINDOW_H
