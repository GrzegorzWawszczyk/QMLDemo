#include "FileDescriptor.h"

FileDescriptor::FileDescriptor(QObject *parent) : QObject(parent), properties("", "", 0, QDate(), false)
{

}

FileDescriptor::FileDescriptor(QString fileName, QString directoryPath, qint64 size, QDate modificationDate, bool isDir, QObject *parent)
    : properties(fileName, directoryPath, size, modificationDate, isDir),
      QObject(parent)
{
}

QString FileDescriptor::fileName() const
{
    return properties.fileName;
}

void FileDescriptor::setFileName(QString fileName)
{
    if (fileName != properties.fileName)
    {
        properties.fileName = fileName;
        emit fileNameChanged();
    }
}

QString FileDescriptor::directoryPath() const
{
    return properties.directoryPath;
}

void FileDescriptor::setDirectoryPath(QString directoryPath)
{
    if (directoryPath != properties.directoryPath)
    {
        properties.directoryPath = directoryPath;
        emit directoryPathChanged();
    }
}

int FileDescriptor::size() const
{
    return properties.size;
}

void FileDescriptor::setSize(qint64 size)
{
    if (size != properties.size)
    {
        properties.size = size;
        emit sizeChanged();
    }
}

QDate FileDescriptor::modificationDate() const
{
    return properties.modificationDate;
}

void FileDescriptor::setModificationDate(QDate modificationDate)
{
    if (modificationDate != properties.modificationDate)
    {
        properties.modificationDate = modificationDate;
        emit modificationDateChanged();
    }
}

bool FileDescriptor::isDir() const
{
    return properties.isDir;
}

void FileDescriptor::setIsDir(bool isDir)
{
    if (isDir != properties.isDir)
    {
        properties.isDir = isDir;
        emit isDirChanged();
    }
}

    FileDescriptor::QProperties::QProperties(QString fileName, QString directoryPath, qint64 size, QDate modificationDate, bool isDir)
    :   fileName(std::move(fileName)),
      directoryPath(std::move(directoryPath)),
      size(std::move(size)),
      modificationDate(std::move(modificationDate)),
      isDir(std::move(isDir))
{
}
