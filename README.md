# utl_sql_maximum_value_in_an_array
SQL does not support arrays. Here are two ways to get the maximum of an array using just sql.

    ```  Getting variable name of last non-zero observation                                                                                                           ```
    ```                                                                                                                                                               ```
    ```      WORKING CODE                                                                                                                                             ```
    ```                                                                                                                                                               ```
    ```          array m{*} MTH: ;                                                                                                                                    ```
    ```                                                                                                                                                               ```
    ```          do i = 1 to dim(m) ;                                                                                                                                 ```
    ```             /* Use vname function to get variable name from array element */                                                                                  ```
    ```            if m{i} > 0 then MONTH_LAST_BALANCE = vname(m{i}) ;                                                                                                ```
    ```          end ;                                                                                                                                                ```
    ```                                                                                                                                                               ```
    ```          note one more line to get the last non-zero value                                                                                                    ```
    ```                                                                                                                                                               ```
    ```            MONTH_LAST_VALUE = m{i};                                                                                                                           ```
    ```                                                                                                                                                               ```
    ```  see                                                                                                                                                          ```
    ```  https://goo.gl/v6z1G8                                                                                                                                        ```
    ```  https://stackoverflow.com/questions/46645094/sas-getting-variable-name-of-last-non-zero-observation                                                          ```
    ```                                                                                                                                                               ```
    ```  Chris J profile                                                                                                                                              ```
    ```  https://stackoverflow.com/users/108797/chris-j                                                                                                               ```
    ```                                                                                                                                                               ```
    ```                                                                                                                                                               ```
    ```  HAVE                                                                                                                                                         ```
    ```  ===                                                                                                                                                          ```
    ```                                                                                                                                                               ```
    ```                                                                                                                                                               ```
    ```  ID  MTH_1   MTH_2   MTH_3   MTH_4   MTH_5   |       MONTH_LAST_BALANCE                                                                                       ```
    ```  ------------------------------------------  |     --------------------                                                                                       ```
    ```  1   10      0       10      20      10      |       MTH_5  This is the last non 0 month                                                                      ```
    ```  2   5       10      15      5       0       |       MTH_4  This is the last non 0 month                                                                      ```
    ```  3   5       10      5       0       0       |       ..                                                                                                       ```
    ```  4   1       2       3       1       0       |                                                                                                                ```
    ```  5   1       0       0       0       0       |       MTH_1  This is the last non 0 month                                                                      ```
    ```                                              |                                                                                                                ```
    ```                                                                                                                                                               ```
    ```  WANT                                                                                                                                                         ```
    ```  ====                                                                                                                                                         ```
    ```                                                                                                                                                               ```
    ```  WORK.WANT total obs=5                                                                                                                                        ```
    ```                                                            MONTH_                                                                                             ```
    ```                                                             LAST_                                                                                             ```
    ```  Obs    ID    MTH_1    MTH_2    MTH_3    MTH_4    MTH_5    BALANCE                                                                                            ```
    ```                                                                                                                                                               ```
    ```   1      1      10        0       10       20       10      MTH_5                                                                                             ```
    ```   2      2       5       10       15        5        0      MTH_4                                                                                             ```
    ```   3      3       5       10        5        0        0      MTH_3                                                                                             ```
    ```   4      4       1        2        3        1        0      MTH_4                                                                                             ```
    ```   5      5       1        0        0        0        0      MTH_1                                                                                             ```
    ```                                                                                                                                                               ```
    ```  *                _               _       _                                                                                                                   ```
    ```   _ __ ___   __ _| | _____     __| | __ _| |_ __ _                                                                                                            ```
    ```  | '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |                                                                                                           ```
    ```  | | | | | | (_| |   <  __/  | (_| | (_| | || (_| |                                                                                                           ```
    ```  |_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|                                                                                                           ```
    ```                                                                                                                                                               ```
    ```  ;                                                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```  data have;                                                                                                                                                   ```
    ```  input ID MTH_1 MTH_2 MTH_3 MTH_4 MTH_5;                                                                                                                      ```
    ```  cards4;                                                                                                                                                      ```
    ```  1 10 0 10 20 10                                                                                                                                              ```
    ```  2 5 10 15 5 0                                                                                                                                                ```
    ```  3 5 10 5 0 0                                                                                                                                                 ```
    ```  4 1 2 3 1 0                                                                                                                                                  ```
    ```  5 1 0 0 0 0                                                                                                                                                  ```
    ```  ;;;;                                                                                                                                                         ```
    ```  run;quit;                                                                                                                                                    ```
    ```                                                                                                                                                               ```
    ```  *          _       _   _                                                                                                                                     ```
    ```   ___  ___ | |_   _| |_(_) ___  _ __                                                                                                                          ```
    ```  / __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                                                         ```
    ```  \__ \ (_) | | |_| | |_| | (_) | | | |                                                                                                                        ```
    ```  |___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                                                        ```
    ```                                                                                                                                                               ```
    ```  ;                                                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```                                                                                                                                                               ```
    ```  data want (drop=i) ;                                                                                                                                         ```
    ```    set have ;                                                                                                                                                 ```
    ```                                                                                                                                                               ```
    ```    /* Load MTH_1 to MTH_5 into array */                                                                                                                       ```
    ```    array m{*} MTH: ;                                                                                                                                          ```
    ```                                                                                                                                                               ```
    ```    length MONTH_LAST_BALANCE $5. ;                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```    /* Iterate over array */                                                                                                                                   ```
    ```    do i = 1 to dim(m) ;                                                                                                                                       ```
    ```      /* Use vname function to get variable name from array element */                                                                                         ```
    ```      if m{i} > 0 then MONTH_LAST_BALANCE = vname(m{i}) ;                                                                                                      ```
    ```    end ;                                                                                                                                                      ```
    ```  run ;                                                                                                                                                        ```
    ```                                                                                                                                                               ```
    ```                                                                                                                                                               ```
    ```  SAS-L: Proc sql find the maximum of an array                                                                                                                 ```
    ```                                                                                                                                                               ```
    ```   Unfortunately sql does not honor arrays.                                                                                                                    ```
    ```   However here is some alternatives                                                                                                                           ```
    ```                                                                                                                                                               ```
    ```    Need the do_over, array and numlist macros                                                                                                                 ```
    ```                                                                                                                                                               ```
    ```    see Jiangtang Hu                                                                                                                                           ```
    ```    https://github.com/Jiangtang/SAS_ListProcessing                                                                                                            ```
    ```                                                                                                                                                               ```
    ```  TWO SOLUTIONS                                                                                                                                                ```
    ```                                                                                                                                                               ```
    ```  WORKING CODE (we really need a macro do)                                                                                                                     ```
    ```                                                                                                                                                               ```
    ```     1.   ,max(%array(x,values=%numlist(m1-m10))%DO_OVER(x,between=%nrstr(,))) as max_marks                                                                    ```
    ```                                                                                                                                                               ```
    ```     2.   Academic solution - wonder what a view would look like                                                                                               ```
    ```                                                                                                                                                               ```
    ```          select                                                                                                                                               ```
    ```              rec                                                                                                                                              ```
    ```             ,max(&ms.) as max_marks                                                                                                                           ```
    ```                                                                                                                                                               ```
    ```          where                      /* where is executed before the select, select is last */                                                                 ```
    ```             dosubl('                /* this generates M1,M2,M3,M4,M5,M6,M7,M8,M9,M10 */                                                                       ```
    ```                     data _null_;                                                                                                                              ```
    ```                        length lst $100;                                                                                                                       ```
    ```                        set have end=dne;                                                                                                                      ```
    ```                        array ms $ m:;                                                                                                                         ```
    ```                        do i=1 to dim(ms);                                                                                                                     ```
    ```                          lst=catx(",",lst,vname(ms[i]));                                                                                                      ```
    ```                        end;                                                                                                                                   ```
    ```                        if dne then call symputx("ms",lst);                                                                                                    ```
    ```                    run;quit;                                                                                                                                  ```
    ```              ') = 0                                                                                                                                           ```
    ```                                                                                                                                                               ```
    ```                                                                                                                                                               ```
    ```  HAVE                                                                                                                                                         ```
    ```  ====                                                                                                                                                         ```
    ```                                                                                                                                                               ```
    ```  40 obs WORK.HAVE total obs=3                                                 RULES                                                                           ```
    ```                                                                     |  Max value using SQL                                                                    ```
    ```   REC    M1    M2    M3    M4    M5    M6    M7    M8    M9    M10  |                                                                                         ```
    ```                                                                     |                                                                                         ```
    ```    1      2    57    39    61    70    92    81    12    36     49  |     92  is nmax                                                                         ```
    ```    2     51    30    80     3    70    21    33    98    83     11  |     98  is max                                                                          ```
    ```    3     28    54     7     8    74    62    45    37    77     66  |     77  is max                                                                          ```
    ```                                                                                                                                                               ```
    ```   WANT                                                                                                                                                        ```
    ```   ====                                                                                                                                                        ```
    ```                                                                                                                                                               ```
    ```      REC  max_marks                                                                                                                                           ```
    ```      --------------                                                                                                                                           ```
    ```        1         92                                                                                                                                           ```
    ```        2         98                                                                                                                                           ```
    ```        3         77                                                                                                                                           ```
    ```                                                                                                                                                               ```
    ```  *                _               _       _                                                                                                                   ```
    ```   _ __ ___   __ _| | _____     __| | __ _| |_ __ _                                                                                                            ```
    ```  | '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |                                                                                                           ```
    ```  | | | | | | (_| |   <  __/  | (_| | (_| | || (_| |                                                                                                           ```
    ```  |_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|                                                                                                           ```
    ```                                                                                                                                                               ```
    ```  ;                                                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```  data have(drop=j);                                                                                                                                           ```
    ```   retain rec;                                                                                                                                                 ```
    ```   array ms[10] m1-m10;                                                                                                                                        ```
    ```   do rec=1 to 3;                                                                                                                                              ```
    ```    do j=1 to dim(ms);                                                                                                                                         ```
    ```      ms[j]=int(100*uniform(5731));                                                                                                                            ```
    ```    end;                                                                                                                                                       ```
    ```    output;                                                                                                                                                    ```
    ```   end;                                                                                                                                                        ```
    ```  run;quit;                                                                                                                                                    ```
    ```                                                                                                                                                               ```
    ```  *          _       _   _                _                                                                                                                    ```
    ```   ___  ___ | |_   _| |_(_) ___  _ __    / |                                                                                                                   ```
    ```  / __|/ _ \| | | | | __| |/ _ \| '_ \   | |                                                                                                                   ```
    ```  \__ \ (_) | | |_| | |_| | (_) | | | |  | |                                                                                                                   ```
    ```  |___/\___/|_|\__,_|\__|_|\___/|_| |_|  |_|                                                                                                                   ```
    ```                                                                                                                                                               ```
    ```  ;                                                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```  proc sql;                                                                                                                                                    ```
    ```     select rec                                                                                                                                                ```
    ```         ,max(%array(x,values=%numlist(m1-m10))%DO_OVER(x,between=%nrstr(,))) as max_marks                                                                     ```
    ```     from have                                                                                                                                                 ```
    ```  ;quit;                                                                                                                                                       ```
    ```                                                                                                                                                               ```
    ```  *          _       _   _               ____                                                                                                                  ```
    ```   ___  ___ | |_   _| |_(_) ___  _ __   |___ \                                                                                                                 ```
    ```  / __|/ _ \| | | | | __| |/ _ \| '_ \    __) |                                                                                                                ```
    ```  \__ \ (_) | | |_| | |_| | (_) | | | |  / __/                                                                                                                 ```
    ```  |___/\___/|_|\__,_|\__|_|\___/|_| |_| |_____|                                                                                                                ```
    ```                                                                                                                                                               ```
    ```  ;                                                                                                                                                            ```
    ```                                                                                                                                                               ```
    ```  proc sql;                                                                                                                                                    ```
    ```    create                                                                                                                                                     ```
    ```       table want as                                                                                                                                           ```
    ```    select                                                                                                                                                     ```
    ```        rec                                                                                                                                                    ```
    ```       ,max(&ms.) as max_marks                                                                                                                                 ```
    ```    from                                                                                                                                                       ```
    ```       have                                                                                                                                                    ```
    ```    where                                                                                                                                                      ```
    ```       dosubl('                                                                                                                                                ```
    ```               data _null_;                                                                                                                                    ```
    ```                  length lst $100;                                                                                                                             ```
    ```                  set have end=dne;                                                                                                                            ```
    ```                  array ms $ m:;                                                                                                                               ```
    ```                  do i=1 to dim(ms);                                                                                                                           ```
    ```                    lst=catx(",",lst,vname(ms[i]));                                                                                                            ```
    ```                  end;                                                                                                                                         ```
    ```                  if dne then call symputx("ms",lst);                                                                                                          ```
    ```              run;quit;                                                                                                                                        ```
    ```        ') = 0                                                                                                                                                 ```
    ```  ;quit;                                                                                                                                                       ```
    ```                                                                                                                                                               ```

