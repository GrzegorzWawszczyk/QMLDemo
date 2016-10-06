#ifndef FILEDESCRIPTOR_H
#define FILEDESCRIPTOR_H

#include <QObject>

class FileDescriptor : public QObject
{
    Q_OBJECT
public:
    explicit FileDescriptor(QObject *parent = 0);

signals:

public slots:
};

#endif // FILEDESCRIPTOR_H