
%Aziz
YearFraction1 = yearfrac('05 jan 1991', '24 mar 2017', 0)

%Yagmur
YearFraction2 = yearfrac('22 jun 1990', '24 mar 2017', 0)

%Fernando
YearFraction3 = yearfrac('22 nov 1989', '24 mar 2017', 0)

%Ozan
YearFraction4 = yearfrac('09 sep 1992', '24 mar 2017', 0)

%Tarik
YearFraction5 = yearfrac('07 jul 1993', '24 mar 2017', 0)

%Veysi
YearFraction6 = yearfrac('08 aug 1992', '24 mar 2017', 0)

%Peng
YearFraction7 = yearfrac('15 nov 1992', '24 mar 2017', 0)

frac = [YearFraction1; YearFraction2; YearFraction3; YearFraction4; YearFraction5; YearFraction6; YearFraction7]

mean(frac)
var(frac)