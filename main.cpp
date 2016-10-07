#include "DirectoryInspector.h"
#include "FileDescriptor.h"

#include <QGuiApplication>
#include <QObjectList>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickImageProvider>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QQmlContext* context = engine.rootContext();

    DirectoryInspector inspector("C:/");
    inspector.getFilesInfo();

    context->setContextProperty("inspector", &inspector);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));



    return app.exec();
}
