#ifndef FILEDESCRIPTOR_H
#define FILEDESCRIPTOR_H

#include <QDate>
#include <QObject>

class FileDescriptor : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(QString directoryPath READ directoryPath WRITE setDirectoryPath NOTIFY directoryPathChanged)
    Q_PROPERTY(qint64 size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(QDate modificationDate READ modificationDate WRITE setModificationDate NOTIFY modificationDateChanged)
    Q_PROPERTY(bool isDir READ isDir NOTIFY isDirChanged)

public:
    explicit FileDescriptor(QObject *parent = 0);
    FileDescriptor(QString fileName, QString directoryPath, qint64 size, QDate modificationDate, bool isDir, QObject* parent = 0);

signals:

    void fileNameChanged();
    void directoryPathChanged();
    void sizeChanged();
    void modificationDateChanged();
    void isDirChanged();

public slots:
    QString fileName() const;
    void setFileName(QString fileName);

    QString directoryPath() const;
    void setDirectoryPath(QString directoryPath);

    int size() const;
    void setSize(qint64 size);

    QDate modificationDate() const;
    void setModificationDate(QDate modificationDate);

    bool isDir() const;
    void setIsDir(bool isDir);

private:
    struct QProperties
    {
        QProperties(QString fileName, QString directoryPath, qint64 size, QDate modificationDate, bool isDir);
        QString fileName;
        QString directoryPath;
        qint64 size;
        QDate modificationDate;
        bool isDir;
    };

    QProperties properties;

};


#endif // FILEDESCRIPTOR_H
