
select user, host FROM mysql.user  
WHERE (plugin IN('mysql_native_password', 'mysql_old_password')   
AND (LENGTH(Password) = 0   OR Password IS NULL)) 
OR (plugin='sha256_password' AND LENGTH(authentication_string) = 0);