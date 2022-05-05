-- Problem with datediff with days and leap years.

-- Year should be 0 and not 1.
DECLARE @dob date = '2012/02/29';
DECLARE @today date = '2013/02/28';

-- This query incorrectly returns 1:
SELECT DATEDIFF(day, @dob, @today) / 365 AS DateDiff;

-- This query correctly returns 0:
SELECT DATEDIFF(year, @dob, @today) -
    (
        CASE WHEN MONTH(@dob) > MONTH(@today)
        OR MONTH(@dob) =
            MONTH(@today)
        AND DAY(@dob) >
            DAY(@today)
        THEN 1 ELSE 0 END
    )
