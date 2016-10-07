#ifndef DIRECTORYINSPECTOR_H
#define DIRECTORYINSPECTOR_H

#include "FileDescriptor.h"

#include <QFileInfoList>
#include <QObject>
#include <QVariant>

class DirectoryInspector : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariant fileDescriptors READ fileDescriptors NOTIFY fileDescriptorsChanged)
    Q_PROPERTY(QString currentPath READ currentPath WRITE setCurrentPath NOTIFY currentPathChanged)

public:
    explicit DirectoryInspector(QString path, QObject *parent = 0);


signals:
    void fileDescriptorsChanged();
    void currentPathChanged();

public slots:

    QVariant fileDescriptors() const;
//    void setFileDescriptors(QObjectList fileDescriptors);

    QString currentPath() const;
    void setCurrentPath(QString currentPath);

    void getFilesInfo();
    void cdUp();

    QVariant getFilesByPath(const QString& path);
    QVariant getFileContent(const QString filePath);

private:
    struct QProperties
    {
        QProperties(QString currentPath);
        QObjectList fileDescriptors;
        QString currentPath;
    };

    QProperties properties;
};

#endif // DIRECTORYINSPECTOR_H
