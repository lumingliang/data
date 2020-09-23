 
DROP PROCEDURE IF EXISTS testEndHandle;
DELIMITER $$
 
 CREATE PROCEDURE testEndHandle()
BEGIN
  DECLARE s_tablename VARCHAR(100);
 
 /*显示表的数据库中的所有表
 SELECT table_name FROM information_schema.tables WHERE table_schema='app_release' Order by table_name ;
 */
 
#显示所有
 DECLARE cur_table_structure CURSOR
 FOR 
 SELECT table_name 
 FROM INFORMATION_SCHEMA.TABLES 
 WHERE table_schema = 'app_release' AND table_name NOT IN (
"T_admin_role", "T_allocation_rule", "t_group_list", "T_menu", "T_rule","T_admin"
 );
 
 DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET s_tablename = NULL;
 
 OPEN cur_table_structure;
 
 FETCH cur_table_structure INTO s_tablename;
 
 WHILE ( s_tablename IS NOT NULL) DO
  SET @MyQuery=CONCAT("alter table `",s_tablename,"` add COLUMN `tenant_id` varchar(64) COMMENT '租户ID'");
  PREPARE msql FROM @MyQuery;
  
  EXECUTE msql ;#USING @c; 
   
  FETCH cur_table_structure INTO s_tablename;
  END WHILE;
 CLOSE cur_table_structure;
 
 
END;
 $$
 
 #执行存储过程
 CALL testEndHandle();