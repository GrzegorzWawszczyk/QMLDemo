#include "DirectoryInspector.h"
#include "FileDescriptor.h"

#include <QDebug>
#include <QDir>

DirectoryInspector::DirectoryInspector(QString path, QObject *parent) : QObject(parent), properties(std::move(path))//, //currentPath(path)
{

}

QVariant DirectoryInspector::fileDescriptors() const
{
    return QVariant::fromValue(properties.fileDescriptors);
}

//void DirectoryInspector::setFileDescriptors(QObjectList fileDescriptors)
//{
//    if (fileDescriptors != properties.fileDescriptors)
//    {
//        properties.fileDescriptors = fileDescriptors;
//        emit fileDescriptorsChanged();
//    }
//}

QString DirectoryInspector::currentPath() const
{
    return properties.currentPath;
}

void DirectoryInspector::setCurrentPath(QString currentPath)
{
    if (currentPath != properties.currentPath)
    {
        properties.currentPath = currentPath;
        emit currentPathChanged();
    }
}

void DirectoryInspector::getFilesInfo()
{
    QDir dir(properties.currentPath);

    if (!dir.exists())
        return;

    properties.fileDescriptors.clear();

    for (QFileInfo file : dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot, QDir::DirsFirst | QDir::IgnoreCase))
        properties.fileDescriptors.append(new FileDescriptor(file.fileName(), file.filePath(), file.size(), file.lastModified().date(), file.isDir(), this));

//    qDebug() << properties.fileDescriptors.size();

//    for(QObject* file : properties.fileDescriptors)
//        qDebug() << dynamic_cast<FileDescriptor*>(file)->fileName();

    emit fileDescriptorsChanged();
}

void DirectoryInspector::cdUp()
{
    QDir dir(properties.currentPath);

    if (!dir.exists())
        return;

    dir.cdUp();

    properties.fileDescriptors.clear();

    for (QFileInfo file : dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot, QDir::DirsFirst | QDir::IgnoreCase))
        properties.fileDescriptors.append(new FileDescriptor(file.fileName(), file.filePath(), file.size(), file.lastModified().date(), file.isDir(), this));

    emit fileDescriptorsChanged();
}


QVariant DirectoryInspector::getFilesByPath(const QString& path)
{
    QDir dir(path);

    if (!dir.exists())
        return QVariant();

    QFileInfoList files = dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot, QDir::DirsFirst | QDir::IgnoreCase);
    QObjectList objects;

    for (QFileInfo file : files)
        objects.append(new FileDescriptor(file.fileName(), file.filePath(), file.size(), file.lastModified().date(), file.isDir(), this));

    return QVariant::fromValue(objects);
}

QVariant DirectoryInspector::getFileContent(const QString filePath)
{
    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly))
        return QVariant();

    QTextStream in(&file);

    return in.read(5000);
}



DirectoryInspector::QProperties::QProperties(QString currentPath)
    : currentPath(std::move(currentPath))
{

}
