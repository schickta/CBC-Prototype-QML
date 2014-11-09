/*******************************************************************************
 * Cirle, Copyright 2014
 *
 * @file configuration.h
 * @author  Chad Hershberger
 * @version 0.1
 *
 * @details This file contains methods that are used to persistently store
 * information needed for the SNS application to run on a given system.
 *
 * ****************************************************************************/

#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QObject>
#include <QSettings>

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <stdexcept>
#include <cstdio>
#include <qvariant.h>
#include <QMap>

#define DEFAULT_APPLICATION_NAME "Drucker CBC"
#define DEFAULT_CONFIG_FILE "druckercbc.ini"
#define DEFAULT_CONFIGURATION_NUMBER "1.0"
#define DEFAULT_KNOB_SENSITIVITY "1"
#define DEFAULT_VLAYOUT "analysispagev2.qml"
#define DEFAULT_SAMPLE_IMAGE "0"
#define DEFAULT_OVERSCAN_VERT "65"
#define DEFAULT_OVERSCAN_HORZ "65"

#define APPLICATION_NAME_KEY        "application"
#define CONFIG_FILE_KEY             "config_file"
#define CONFIG_NUMBER_KEY           "config_number"
#define KNOB_SENSITIVITY_KEY        "knob_sensitivity"
#define VERTICAL_LAYOUT_KEY         "vertical_layout"
#define SAMPLE_IMAGE_KEY            "sample_image"
#define OVERSCAN_VERT_KEY           "overscan_vert"
#define OVERSCAN_HORZ_KEY           "overscan_horz"

class Configuration : public QObject
{
    Q_OBJECT

        // Read-only properties
        Q_PROPERTY(QString ApplicationName READ ApplicationName)
        Q_PROPERTY(QString ConfigurationFile READ ConfigurationFile)
        Q_PROPERTY(QString ConfigurationNumber READ ConfigurationNumber)

        // Read-write properties
        Q_PROPERTY(QString KnobSensitivity READ KnobSensitivity
               WRITE setKnobSensitivity  NOTIFY KnobSensitivityChanged)

        Q_PROPERTY(QString VerticalLayoutUsed READ VerticalLayoutUsed
               WRITE setVerticalLayoutUsed  NOTIFY VerticalLayoutChanged)

        Q_PROPERTY(QString SampleImageUsed READ SampleImageUsed
                WRITE setSampleImageUsed  NOTIFY SampleImageChanged)

        Q_PROPERTY(QString VerticalOverscan READ VerticalOverscan)
        Q_PROPERTY(QString HorizontalOverscan READ HorizontalOverscan)

public:
    explicit Configuration(QObject *parent = 0);
    ~Configuration();

    QString getConfigValue(QString);
    bool setConfigValue(QString, QString);

    bool writeDefaultSettingsToINIFile();

    QString ApplicationName()                   { return (getConfigValue(APPLICATION_NAME_KEY));}
    QString ConfigurationFile()                 { return (getConfigValue(CONFIG_FILE_KEY)); }
    QString ConfigurationNumber()               { return (getConfigValue(CONFIG_NUMBER_KEY)); }
    QString KnobSensitivity()                   { return (getConfigValue(KNOB_SENSITIVITY_KEY)); }
    QString VerticalLayoutUsed ()               { return (getConfigValue(VERTICAL_LAYOUT_KEY)); }
    QString SampleImageUsed ()                  { return (getConfigValue(SAMPLE_IMAGE_KEY)); }
    QString VerticalOverscan ()                 { return (getConfigValue(OVERSCAN_VERT_KEY)); }
    QString HorizontalOverscan ()               { return (getConfigValue(OVERSCAN_HORZ_KEY)); }

    void setKnobSensitivity (QString ks)        {setConfigValue(KNOB_SENSITIVITY_KEY, ks);}
    void setVerticalLayoutUsed (QString vl)     {setConfigValue(VERTICAL_LAYOUT_KEY, vl);}
    void setSampleImageUsed (QString si)        {setConfigValue(SAMPLE_IMAGE_KEY, si);}

signals:
    void KnobSensitivityChanged ();
    void VerticalLayoutChanged ();
    void SampleImageChanged ();

public slots:

private:
    //_____________________________ Variables_____________________________
    QMap<QString, QString> m_configMap;
    QString iniFilePath;

    //_____________________________   Methods  _____________________________
    bool hasSetting(const QString &key);
    bool readConfigurationFromINIFile();
    QVariant readSetting(const QString &key);
    bool writeSetting(const QString &key, const QVariant &variant);

};

#endif // CONFIGURATION_H
