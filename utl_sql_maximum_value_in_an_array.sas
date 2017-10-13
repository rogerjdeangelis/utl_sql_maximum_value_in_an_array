
Proc sql find the maximum of an array

 Unfortunately sql does not honor arrays.
 However here is some alternatives

  Need the do_over, array and numlist macros

  see Jiangtang Hu
  https://github.com/Jiangtang/SAS_ListProcessing

TWO SOLUTIONS

WORKING CODE (we really need a macro do)

   1.   ,max(%array(x,values=%numlist(m1-m10))%DO_OVER(x,between=%nrstr(,))) as max_marks

   2.   Academic solution - wonder what a view would look like

        select
            rec
           ,max(&ms.) as max_marks

        where                      /* where is executed before the select, select is last */
           dosubl('                /* this generates M1,M2,M3,M4,M5,M6,M7,M8,M9,M10 */
                   data _null_;
                      length lst $100;
                      set have end=dne;
                      array ms $ m:;
                      do i=1 to dim(ms);
                        lst=catx(",",lst,vname(ms[i]));
                      end;
                      if dne then call symputx("ms",lst);
                  run;quit;
            ') = 0


HAVE
====

40 obs WORK.HAVE total obs=3                                                 RULES
                                                                   |  Max value using SQL
 REC    M1    M2    M3    M4    M5    M6    M7    M8    M9    M10  |
                                                                   |
  1      2    57    39    61    70    92    81    12    36     49  |     92  is nmax
  2     51    30    80     3    70    21    33    98    83     11  |     98  is max
  3     28    54     7     8    74    62    45    37    77     66  |     77  is max

 WANT
 ====

    REC  max_marks
    --------------
      1         92
      2         98
      3         77

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have(drop=j);
 retain rec;
 array ms[10] m1-m10;
 do rec=1 to 3;
  do j=1 to dim(ms);
    ms[j]=int(100*uniform(5731));
  end;
  output;
 end;
run;quit;

*          _       _   _                _
 ___  ___ | |_   _| |_(_) ___  _ __    / |
/ __|/ _ \| | | | | __| |/ _ \| '_ \   | |
\__ \ (_) | | |_| | |_| | (_) | | | |  | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|  |_|

;

proc sql;
   select rec
       ,max(%array(x,values=%numlist(m1-m10))%DO_OVER(x,between=%nrstr(,))) as max_marks
   from have
;quit;

*          _       _   _               ____
 ___  ___ | |_   _| |_(_) ___  _ __   |___ \
/ __|/ _ \| | | | | __| |/ _ \| '_ \    __) |
\__ \ (_) | | |_| | |_| | (_) | | | |  / __/
|___/\___/|_|\__,_|\__|_|\___/|_| |_| |_____|

;

proc sql;
  create
     table want as
  select
      rec
     ,max(&ms.) as max_marks
  from
     have
  where
     dosubl('
             data _null_;
                length lst $100;
                set have end=dne;
                array ms $ m:;
                do i=1 to dim(ms);
                  lst=catx(",",lst,vname(ms[i]));
                end;
                if dne then call symputx("ms",lst);
            run;quit;
      ') = 0
;quit;


Arthur Tabachneck <art@analystfinder.com>
10:54 AM (4 hours ago)

 to SAS-L, me 
Roger,

Another alternative is to have SQL create a macro variable that mimics the desired array. e.g.:

data have;
  input miss match more much that;
  cards;
1 2 3 4 5
5 4 3 2 1
1 1 2 1 3
;

proc sql noprint;
  select name
    into :vars separated by ','
      from dictionary.columns
        where libname='WORK' and
              memname='HAVE' and
              upcase(name) like 'M%'
  ;

  create table want as
    select *, max(&vars.) as max_of_m_vars
      from have
  ;
quit;
