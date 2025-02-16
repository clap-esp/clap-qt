#pragma once

#include <QObject>

class NotificationTypeClass
{
    Q_GADGET
public:
    explicit NotificationTypeClass();

    enum Value {
        Success,
        Error,
        Loading,
        Warning
    };
    Q_ENUM(Value)
};
