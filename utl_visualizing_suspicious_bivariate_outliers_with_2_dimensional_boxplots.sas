Visualizing suspicious bivariate outliers with 2 dimensional boxplots

for output see
https://tinyurl.com/y8oa3cyp
https://github.com/rogerjdeangelis/utl_visualizing_suspicious_bivariate_outliers_with_2_dimensional_boxplots/blob/master/bagplot.pdf

and
https://tinyurl.com/yck2q2c9
https://github.com/rogerjdeangelis/utl_visualizing_suspicious_bivariate_outliers_with_2_dimensional_boxplots/blob/master/bagplot.png


github
https://tinyurl.com/y9jlxkwe
https://github.com/rogerjdeangelis/utl_visualizing_suspicious_bivariate_outliers_with_2_dimensional_boxplots

see
https://tinyurl.com/y7r6yqhv
https://communities.sas.com/t5/SAS-Enterprise-Guide/Code-to-spot-anomalies-between-two-variables/m-p/481484

/* T1006770 CrossValidate: Visualizing suspicious bivariate observations(outliers) with 2 dimensional boxplots

 see output (or run code)
 https://www.dropbox.com/s/7n4nt5ak8np15ix/bagplot.pdf?dl=0

  WORKING R CODE

     have<-read_sas("d:/sd1/have.sas7bdat");
     pdf("d:/pdf/bagplot.pdf");
     bagplot(have,pch=16,cex=2);
     import r=want data=wrk.want;

(1) P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999): The bagplot: a bivariate boxplot,
The American Statistician, vol. 53, no. 4, 382–387


crossValidated
https://stats.stackexchange.com/questions/53227/test-for-bivariate-outliers

profile user603
https://stats.stackexchange.com/users/603/user603


HAVE
====

Up to 40 obs SD1.HAVE total obs=301

Obs       X       Y

  1     -12      73
  2     -35     110
  3      56     107
  4      95     108
  5    -215    -201
  6       6    -117

  7     -373     68   Outlier?

117      77      10
118     -79     212
119       0     115
120     -22     -41

222      350    350    Outlier?

297      24     123
298     127     149
299     152       0
300     104      10




WANT
====

The WPS System

Up to 40 obs WANT total obs=2

Obs      X      Y

 1     -373     68
 2      350    350

 This plot (dramatization)

 +400|                                 suspicious
     +             ************           @
     |          ****     O    ***
     +        ***    O O OO      **
     |      ***    O    O O       ***
     +     **       O O             **
     |     *       O   ***           **
     +    **        **     **     O   *
     |   **       ***    O   **       **
     +   *  O    O*       O   **  O    *
     |   *       ** O XX  O    *       *
     +   *       *    XX  O O  *   O   *
     |   *       * OO   O  O   *       *
     +   *        *  O        **  O    *
     |   **        **    O   **       **
     +    **        **     ** O       *
     |     *           ***           **
     +     **       O        O       **
     |      ***       O O         ***
     +        ***         O      **
     |          ****          ***
     +             ************
     |     @ suspicious
 -400+
     -+--------+-------+---------+---------+
    -400     -200      0       +200      +400


You can read this plot as you would read a boxplot: the xx central region is
the bivariate median, the inner circle 'the bag' is the bivariate IQR (interquartile range)
(it contains the 50% most central points) and the outer region 'the fence'
contains the points that are further away (but not enough that they would be considered outliers.)


(1) P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999): The bagplot: a bivariate boxplot,
The American Statistician, vol. 53, no. 4, 382–387

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|
;


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have /*(where=(abs(x)>300))*/;
  call streaminit(5632);
  do i=1 to 300;
     x=int(100*rand("normal"));
     y=int(100*rand("normal"));
     output;
  end;
  x=350;
  y=350;
  output;
 drop i;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(aplpack);
library(haven);
have<-read_sas("d:/sd1/have.sas7bdat");
head(have);
pdf("d:/pdf/bagplot.pdf");
bagplot(have,pch=16,cex=2);
want<-have[abs(have$X)>300,];
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
');

proc print data=want;
run;quit;


