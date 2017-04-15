/*
  删除表中原有数据
*/
DELETE FROM zhsjb3;

/*SELECT * FROM xxjxj; #362行*/
INSERT INTO zhsjb3(xh,xm) SELECT xh,xm FROM xxjxj;
UPDATE zhsjb3 SET nic.zhsjb3.jxj=1;
/*
 *  重要！！！
    将select中的结果在select一遍，是为了避免mysql报错
    错误信息：You can't specify target table 'zhsjb3' for update in FROM clause
    该问题在oracle和mssql中不会有
*/
# 将同时获得 奖学金 和 素质拓展奖 的人做标注
UPDATE zhsjb3 SET nic.zhsjb3.sztzj=1 WHERE nic.zhsjb3.xm IN  (
    SELECT xm FROM sztzj
);
/*select count(xm) FROM sztzj where xm IN (
  SELECT xm FROM zhsjb3
);#135行
SELECT count(xm) FROM sztzj where xm NOT IN (
  SELECT xm FROM zhsjb3
);#90行
SELECT count(xm) FROM sztzj;#225行*/
/*
    同时获得三种奖的人
*/
/*SELECT count(*) FROM zhsjb3 WHERE jbjxj=1 AND sztzj=1 AND jxj=1;*/

/*
    插入获得素质拓展奖的人
    将没有获得奖学金且获得素质拓展奖的 人插入到综合数据表中
*/
INSERT INTO zhsjb3(xh,xm)
    SELECT xh,xm FROM sztzj
    WHERE xm NOT IN (
        SELECT xm FROM zhsjb3
    );
/*SELECT count(xm) FROM zhsjb3 where sztzj=1;
SELECT count(*) FROM sztzj;*/

# 此部分人只获得了素质拓展奖，没有获得过其他两项奖项
update zhsjb3 SET zhsjb3.sztzj=1 WHERE jxj=0 AND sztzj=0 AND jbjxj=0;
# 将同时获得 奖学金 和 进步奖学金 的人，或者同时获得素质拓展奖 和进步奖学金的人，或者同时获得三者的人做标注
UPDATE zhsjb3 SET nic.zhsjb3.jbjxj=1 WHERE nic.zhsjb3.xm IN  (
   SELECT xm FROM jbjxj);
/*
    插入 获得进步奖学金的人
    将没有获得奖学金和素质拓展奖的人 即只获得了 进步奖学金的人插入到综合数据表中
*/
INSERT INTO zhsjb3(xh,xm)
    SELECT xh,xm FROM jbjxj WHERE xm NOT IN (
    SELECT xm FROM zhsjb3
);
#  此部分人只获得了进步奖学金，没有获得过其他两项奖项
UPDATE zhsjb3 SET nic.zhsjb3.jbjxj=1 WHERE jxj=0 AND jbjxj=0 AND sztzj=0;

SELECT count(*) FROM qgzx where qgzx.xm NOT IN (
  SELECT xm FROM zhsjb3
) ;#93人
SELECT count(*) FROM qgzx where qgzx.xm  IN (
  SELECT xm FROM zhsjb3
) ;#203人
SELECT count(*) from qgzx ;

SELECT xm FROM qgzx where qgzx.xm IN (
  SELECT xm FROM zhsjb3
) GROUP BY xm;# 去重之后为50人，已验证

/*
  查出综合数据表中拥有勤工助学岗位的学生
*/
UPDATE zhsjb3 SET qgzx=1 WHERE xm IN (
  SELECT xm FROM qgzx
);

