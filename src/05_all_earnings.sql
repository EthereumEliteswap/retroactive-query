BEGIN -- returns each address and how much ELT it should receive
  CREATE TABLE all_earnings AS (
    WITH
    all_users AS (
      SELECT DISTINCT address FROM user_query
    )
    SELECT address,
      @user_reward as earnings,
      "user" as reason
    FROM all_users
  );
END;
