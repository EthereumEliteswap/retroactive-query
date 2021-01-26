BEGIN
    CREATE TABLE sanity_checks AS
    (
    SELECT "all earnings addresses are valid addresses" AS test_case,
    CAST((SELECT COUNT(1)
                      FROM all_earnings
                      WHERE NOT REGEXP_CONTAINS(address, "^0x[a-f0-9]{40}$")) AS STRING) AS test_value,
           (CASE
                WHEN (SELECT COUNT(1)
                      FROM all_earnings
                      WHERE NOT REGEXP_CONTAINS(address, "^0x[a-f0-9]{40}$")) > 0 THEN FALSE
                ELSE TRUE
               END)                                     AS passes
    UNION ALL
    SELECT "there are exactly 445824 users" AS test_case,
        CAST((SELECT COUNT(distinct address) from user_query) AS STRING) as test_value,
           (CASE
                WHEN ((SELECT COUNT(distinct address) from user_query)) = 445824 THEN TRUE
                ELSE FALSE
               END)                                 AS passes
    UNION ALL
    SELECT "no one gets less than the user_reward in ELT" AS test_case,
            CAST((SELECT MIN(earnings) FROM all_earnings) AS STRING) as test_value,
            (SELECT (MIN(earnings) = @user_reward) FROM all_earnings)
                                                    AS passes
    UNION ALL
    SELECT "there are no uniswap contracts" AS test_case,
        CAST((SELECT COUNT(*) from all_earnings
              WHERE address NOT IN (SELECT DISTINCT address FROM uniswap_contracts)) AS STRING) as test_value,
           (CASE
                WHEN (SELECT COUNT(*) from all_earnings
              WHERE address NOT IN (SELECT DISTINCT address FROM uniswap_contracts)) = 0 THEN TRUE
                ELSE FALSE
               END)                                 AS passes
                                                    );
END;
