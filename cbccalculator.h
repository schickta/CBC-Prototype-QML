#ifndef CBCCALCULATOR_H
#define CBCCALCULATOR_H

#include <QObject>

class CBCCalculator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double Hct      READ Hct        NOTIFY HctChanged)
    Q_PROPERTY(double Hgb      READ Hgb        NOTIFY HgbChanged)
    Q_PROPERTY(double Mchc     READ Mchc       NOTIFY MchcChanged)
    Q_PROPERTY(double Wbc      READ Wbc        NOTIFY WbcChanged)
    Q_PROPERTY(double Grans    READ Grans      NOTIFY GransChanged)
    Q_PROPERTY(double Pgrans   READ Pgrans     NOTIFY PgransChanged)
    Q_PROPERTY(double Lm       READ Lm         NOTIFY LmChanged)
    Q_PROPERTY(double Plm      READ Plm        NOTIFY PlmChanged)
    Q_PROPERTY(double Plt      READ Plt        NOTIFY PltChanged)
    Q_PROPERTY(double WbcCont  READ WbcCont    NOTIFY WbcContChanged)
    Q_PROPERTY(double LmCont   READ LmCont     NOTIFY LmContChanged)
    Q_PROPERTY(double PltCont  READ PltCont    NOTIFY PltContChanged)

    Q_PROPERTY(bool CalcsValid READ CalcsValid NOTIFY CalcsValidChanged)

public:
    explicit CBCCalculator(QObject *parent = 0);

    Q_INVOKABLE bool calculate (int i1, int i2, int i3,
                                int i4, int i5, int i6,
                                int i7, int i8);

    Q_INVOKABLE void invalidateCalculations ();

    double Hct()        const {return m_hct;}
    double Hgb ()       const {return m_hgb;}
    double Mchc ()      const {return m_mchc;}
    double Wbc ()       const {return m_wbc;}
    double Grans ()     const {return m_grans;}
    double Pgrans ()    const {return m_pgrans;}
    double Lm ()        const {return m_lm;}
    double Plm ()       const {return m_plm;}
    double Plt ()       const {return m_plt;}
    double WbcCont ()   const {return m_wbcCont;}
    double LmCont ()    const {return m_lmCont;}
    double PltCont ()   const {return m_pltCont;}

    bool CalcsValid ()  const {return m_calcsValid;}

signals:
    void HctChanged ();
    void HgbChanged ();
    void MchcChanged ();
    void WbcChanged ();
    void GransChanged ();
    void PgransChanged ();
    void LmChanged ();
    void PlmChanged ();
    void PltChanged ();
    void WbcContChanged ();
    void LmContChanged ();
    void PltContChanged ();
    void CalcsValidChanged ();

private:
    double m_hct;
    double m_hgb;
    double m_mchc;
    double m_wbc;
    double m_grans;
    double m_pgrans;
    double m_lm;
    double m_plm;
    double m_plt;
    double m_wbcCont;
    double m_lmCont;
    double m_pltCont;

    bool m_calcsValid;

    double round(double number);
};

#endif // CBCCALCULATOR_H
