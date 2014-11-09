/*******************************************************************************
 * Cirle, Copyright 2014
 *
 * @file configuration.cpp
 * @author  Chad Hershberger
 * @version 0.1
 *
 * @details This file contains methods that are used to persistently store
 * information needed for the SNS application to run on a given system.
 *
 * ****************************************************************************/


#include "configuration.h"

#include <QFile>
#include <QSettings>
#include <QString>
#include <QDateTime>
#include <QDebug>


QSettings *settings;


//_______________________________   Constructors    ____________________________________


Configuration::Configuration(QObject *parent) :
    QObject(parent)
{
    this->iniFilePath = DEFAULT_CONFIG_FILE;

    m_configMap = QMap<QString, QString>();
    m_configMap.insert(APPLICATION_NAME_KEY, DEFAULT_APPLICATION_NAME);
    m_configMap.insert(CONFIG_FILE_KEY, DEFAULT_CONFIG_FILE);
    m_configMap.insert(CONFIG_NUMBER_KEY, DEFAULT_CONFIGURATION_NUMBER);
    m_configMap.insert(KNOB_SENSITIVITY_KEY, DEFAULT_KNOB_SENSITIVITY);
    m_configMap.insert(VERTICAL_LAYOUT_KEY, DEFAULT_VLAYOUT);
    m_configMap.insert(SAMPLE_IMAGE_KEY, DEFAULT_SAMPLE_IMAGE);
    m_configMap.insert(OVERSCAN_VERT_KEY, DEFAULT_OVERSCAN_VERT);
    m_configMap.insert(OVERSCAN_HORZ_KEY, DEFAULT_OVERSCAN_HORZ);

    // Create config file if it doesn't exist
    QFile configFile(this->iniFilePath);
    if (!configFile.exists())
    {
        configFile.open(QIODevice::ReadWrite);
        writeDefaultSettingsToINIFile();
        configFile.close();
    }
    else
    {
        // This is for upgrading and setting to correct values.
        QMapIterator<QString, QString> configIter(m_configMap);
        while (configIter.hasNext())
        {
            configIter.next();
            if (hasSetting(configIter.key()))
            {
                m_configMap[configIter.key()] = readSetting(configIter.key()).toString();
            }
            else
            {
                writeSetting(configIter.key(), configIter.value());
            }
        }
    }

    // Read settings from config file
    readConfigurationFromINIFile();
}

Configuration::~Configuration()
{
}


//_______________________________    Public Methods  ____________________________________

QString Configuration::getConfigValue(QString key)
{
    if (m_configMap.contains(key))
    {
        return QString(m_configMap[key]);
    }
    else
    {
        return QString();
    }
}

bool Configuration::setConfigValue(QString key, QString value)
{
    if (m_configMap.contains(key))
    {
        m_configMap[key] = value;
        writeSetting(key, value);
        return true;
    }
    else
    {
        return false;
    }
}

bool Configuration::writeDefaultSettingsToINIFile()
{
    QMapIterator<QString, QString> configIter(m_configMap);
    while (configIter.hasNext())
    {
        configIter.next();
        writeSetting(configIter.key(), configIter.value());
    }

    qDebug () << "No Configuration file found.  Default file was created.";
    return true;
}

//______________________________   Private Methods  _____________________________________

bool Configuration::hasSetting(const QString &key)
{
    bool settingFound = false;
    QVariant settingValue;
    QFile configFile(this->iniFilePath);
    if (configFile.exists()) //if the config file exists
    {
        QSettings settings(this->iniFilePath, QSettings::IniFormat);
        settingValue = settings.value(key);
        if (settingValue.toString().length() > 0)
        {
            settingFound = true;
        }
    }
    return settingFound;
}

bool Configuration::readConfigurationFromINIFile()
{    
    bool success = false;
    QFile configFile(this->iniFilePath);
    if (configFile.exists())
    {
        QMapIterator<QString, QString> configIter(m_configMap);
        while (configIter.hasNext())
        {
            configIter.next();
            m_configMap[configIter.key()] = readSetting(configIter.key()).toString();
        }
    }
    return success;
}

QVariant Configuration::readSetting(const QString &key)
{
    QVariant settingValue("");
    if (hasSetting(key)) //if the setting is in the config file -> read setting
    {
        QSettings settings(this->iniFilePath, QSettings::IniFormat);
        settingValue = settings.value(key);
    }
    return settingValue;
}

bool Configuration::writeSetting(const QString &key, const QVariant &variant)
{
    bool success = false;
    QFile configFile(this->iniFilePath);
    if (configFile.exists())
    {
        QSettings settings(this->iniFilePath, QSettings::IniFormat);
        settings.setValue(key, variant);
        success = true;
    }
    return success;
}



