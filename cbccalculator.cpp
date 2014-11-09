#include "cbccalculator.h"

#include <math.h>

#include <QDebug>

CBCCalculator::CBCCalculator(QObject *parent) :
    QObject(parent)
{
    invalidateCalculations ();

    m_hct = 0.0;
    m_hgb = 0.0;
    m_mchc = 0.0;
    m_wbc = 0.0;
    m_grans = 0.0;
    m_pgrans = 0.0;
    m_lm = 0.0;
    m_plm = 0.0;
    m_plt = 0.0;
    m_wbcCont = 0.0;
    m_lmCont = 0.0;
    m_pltCont = 0.0;
}

void CBCCalculator::invalidateCalculations ()
{
    m_calcsValid = false;
}

/*
 * i1 = Top of Closure
 * i2 = Bottom of Float
 * i3 = Top of RBCs
 * i4 = Granulocytes
 * i5 = Lymph & Mono
 * i6 = Top of Platelets
 * i7 = Top of Float
 * i8 = Meniscus
 *
 * */
bool CBCCalculator::calculate (int i1, int i2, int i3,
                               int i4, int i5, int i6,
                               int i7, int i8)
{
    printf ("Calculate called\n");
    printf ("i1 = %d\n", i1);
    printf ("i2 = %d\n", i2);
    printf ("i3 = %d\n", i3);
    printf ("i4 = %d\n", i4);
    printf ("i5 = %d\n", i5);
    printf ("i6 = %d\n", i6);
    printf ("i7 = %d\n", i7);
    printf ("i8 = %d\n", i8);


    double C1 = 2.2244E-10;
    double C2 = -7.6018E-07;
    double C3 = 1.6825E-02;

    double L1 = C1 / 3.0 * ( (i1^3) - (i2^3) ) + C2 / 2.0 * ( (i1^2) - (i2^2) ) + C3 * (i1 - i2);
    double L2 = C1 / 3.0 * ( (i2^3) - (i3^3) ) + C2 / 2.0 * ( (i2^2) - (i3^2) ) + C3 * (i2 - i3);
    double L3 = C1 / 3.0 * ( (i3^3) - (i4^3) ) + C2 / 2.0 * ( (i3^2) - (i4^2) ) + C3 * (i3 - i4);
    double L4 = C1 / 3.0 * ( (i4^3) - (i5^3) ) + C2 / 2.0 * ( (i4^2) - (i5^2) ) + C3 * (i4 - i5);
    double L5 = C1 / 3.0 * ( (i5^3) - (i6^3) ) + C2 / 2.0 * ( (i5^2) - (i6^2) ) + C3 * (i5 - i6);
    double L6 = C1 / 3.0 * ( (i6^3) - (i7^3) ) + C2 / 2.0 * ( (i6^2) - (i7^2) ) + C3 * (i6 - i7);
    double L7 = C1 / 3.0 * ( (i7^3) - (i8^3) ) + C2 / 2.0 * ( (i7^2) - (i8^2) ) + C3 * (i7 - i8);

    double LR1 = L1 / 25.4 / 0.0005;
    double LR2 = L2 / 25.4 / 0.0005;
    double LR3 = L3 / 25.4 / 0.0005;
    double LR4 = L4 / 25.4 / 0.0005;
    double LR5 = L5 / 25.4 / 0.0005;
    double LR6 = (L6+L7) / 25.4 / 0.0005;

    double LT = LR1 + LR2 + LR3 + LR4 + LR5 + LR6;
    double M = 2362 / LT;

    double LP = 1500 - (LR2 + LR3 + LR4 + LR5);
    double DM = LP + (LR5 * 0.54) + (LR4 * 0.35) + (LR3 * 0.20);
    double DF = 1 + (((DM / 425) - 1) * 0.35);

    m_hct = (M * LR1 * 0.05417) + (M * 4.666);

    m_hgb = (m_hct * 0.2665 * DF) - 1.0;

    m_mchc = ( m_hgb / m_hct ) * 100.0;

    if (LR3 > 125) {
        m_grans = (M * LR3 * 0.100) + 2.6;
    }

    else {
        m_grans = (M * LR3 * 0.127) - 0.71;
    }

    if (LR4 < 25) {
        m_lm = M * LR4 * 0.11 + 0.10;
    }

    else {
        m_lm = M * LR4 * 0.18 - 1.65;
    }

    m_wbc =  ( round ( m_grans * 10.0 ) / 10.0 ) + ( round ( m_lm * 10.0 ) / 10.0 );

    m_pgrans = 100.0 * m_grans / ( m_grans + m_lm );

    m_plm = 100.0 * m_lm / ( m_grans + m_lm );

    m_plt = (M * LR5 * 3.33) -  21.8;

    printf ("HCT = %f\n", m_hct);
    printf ("HGB = %f\n", m_hgb);
    printf ("MCHC = %f\n", m_mchc);

    return (m_calcsValid = true);
}

double CBCCalculator::round(double number)
{
    return number < 0.0 ? ceil(number - 0.5) : floor(number + 0.5);
}
