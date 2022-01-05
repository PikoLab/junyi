CREATE DATABASE IF NOT EXISTS junyi DEFAULT CHARSET = utf8mb4 DEFAULT COLLATE = utf8mb4_unicode_ci;
use junyi;


CREATE TABLE IF NOT EXISTS info_userdata (
  `user_primary_key` varchar(50) NOT NULL,
  `user_nickname` varchar(50) NOT NULL,
  `user_email` varchar(150) UNIQUE NOT NULL,
  `is_registered` varchar(10) NOT  NULL,
  `joined_time` timestamp NOT NULL,
  `user_role` varchar(15),
  `user_city` varchar(15)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS info_ip_cityschool (
  `ip_address` varchar(30) NOT NULL,
  `city` varchar(10) NOT NULL,
  `school` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS log_videoproblem (
  `user_primary_key` varchar(50) NOT NULL,
  `content_id` varchar(20) NOT NULL,
  `content_kind` varchar(20) NOT NULL,
  `ip` varchar(30) NOT NULL,
  `timestamp_tw` timestamp NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS log_videoplay (
  `user_primary_key` varchar(50) NOT NULL,
  `content_id` varchar(20) NOT NULL,
  `timestamp_tw` timestamp NOT NULL,
  `date` date NOT NULL,
  `play` int NOT NULL,
  `pause` int NOT NULL,
  `forward` int NOT NULL,
  `reverse` int NOT NULL,
  `start_frame` int NOT NULL,
  `end_frame` int NOT NULL,
  `total_frame` int NOT NULL,
  `is_session_end` int NOT NULL,
  `play_times` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;


-- Create Mock Data

INSERT INTO info_ip_cityschool (ip_address, city, school)
VALUES('1.2.3.4', '台北', '均一國小'), ('150.77.124.66', '台南', '均二國中'), ('141.157.46.32', '新竹', '均三高中'),('114.68.59.63', '桃園', '桃園國小');

INSERT INTO info_userdata (user_primary_key,user_nickname, user_email, is_registered, joined_time,user_role,user_city)
VALUES('x0001', 'Paul', 'paul@gmail.com', 'TRUE', '2021-11-21 08:18:41', 'Teacher','台北'), 
('x0002', 'John', 'john@gmail.com', 'FALSE','2021-11-20 08:18:41', NULL, '新竹' ), 
('x0009', 'May', 'may@gmail.com', 'TRUE', '2021-11-20 08:18:41','Student',NULL ),
('x0011', 'Kelly', 'kelly@gmail.com', 'TRUE', '2021-11-20 08:18:41','Student',NULL ),
('x0012', 'Tony', 'tony@gmail.com', 'TRUE', '2021-11-20 08:18:41','Student', NULL );


INSERT INTO log_videoproblem (user_primary_key, content_id, content_kind, ip, timestamp_tw, date)
VALUES('x0001', 'cid_3001', 'Video', '112.111.22.33', '2021-12-03 08:18:41','2021-12-03' ), 
('x0002', 'cid_3637', 'Exercise', '112.130.66.55','2019-11-20 08:18:41', '2019-11-20' ), 
('x0009', 'cid_9627', 'Video', '114.68.59.63', '2020-11-20 08:18:41','2020-11-20' ),
('x0011', 'cid_9627', 'Video', '114.68.59.63', '2020-11-20 08:18:41','2020-11-20' ),
('x0009', 'cid_9627', 'Video', '114.68.59.63', '2019-11-20 08:18:41','2019-11-20' ),
('x0011', 'cid_9627', 'Video', '114.68.59.63', '2019-11-20 08:18:41','2019-11-20' ),
('x0012', 'cid_9627', 'Video', '111.22.33.55', '2019-11-20 08:18:41','2019-11-20' );


INSERT INTO log_videoplay (user_primary_key, content_id, timestamp_tw, date, play, pause, forward, reverse, start_frame, end_frame, total_frame, is_session_end, play_times)
VALUES('x0001', 'cid_3001', '2021-12-03 08:18:41','2021-12-03', 1, 0, 0, 0, 0, 12, 338, 0 ,1 ), 
('x0002', 'cid_3637', '2019-11-20 08:18:41', '2019-11-20', 1, 0, 0, 101, 101, 101, 110, 1,2 ), 
('x0009', 'cid_9627', '2020-11-20 08:18:41','2020-11-20', 0, 0, 1, 0, 82, 85, 126, 0, 6 ),
('x0011', 'cid_9627', '2020-11-20 08:18:41','2020-11-20', 0, 0, 1, 0, 82, 85, 126, 0, 6 ),
('x0009', 'cid_9627', '2019-11-20 08:18:41','2019-11-20', 0, 0, 1, 0, 82, 85, 126, 0, 6 ),
('x0011', 'cid_9627', '2019-11-20 08:18:41','2019-11-20', 0, 0, 1, 0, 82, 85, 126, 0, 6 ),
('x0012', 'cid_9627', '2019-11-20 08:18:41','2019-11-20', 0, 0, 1, 0, 82, 85, 126, 0, 6 );


SELECT * FROM info_ip_cityschool;
SELECT * FROM info_userdata;
SELECT * FROM log_videoproblem;
SELECT * FROM log_videoplay;


-- Question1: 找出當週不重複訪客(Weekly Active User)
-- 可設計圖表(bar chart/ line chart)：week時間為X軸; 當週不重複訪客數量為Y軸。

SELECT YEARWEEk(date) AS week , COUNT(DISTINCT(user_primary_key)) AS weekly_active_user
FROM log_videoproblem
GROUP BY 1
ORDER BY 1 ASC;


-- Question2: 當週不重複訪客中來自各縣市的成員(Weekly Active User by City)
-- 可設計圖表（stack bar chart)：week時間為X軸; 當週不重複訪客數量為Y軸，並依據各縣市數量堆疊訪客數量。
-- 需要填補「Info_UserData」table中的user_city缺失值

WITH user_school_city AS (
	SELECT t1.user_primary_key as user_primary_key, t2.city as city
	FROM log_videoproblem t1 
	LEFT JOIN info_ip_cityschool t2 ON t1.ip=t2.ip_address
), user_city as (
	SELECT t1.user_primary_key as user_primary_key, COALESCE(t1.user_city, t2.city, 'others') as city
	FROM info_userdata t1
	LEFT JOIN user_school_city t2 ON t1.user_primary_key=t2.user_primary_key
)

SELECT YEARWEEK(t1.date) AS week , t2.city city,  COUNT(DISTINCT(t1.user_primary_key)) AS weekly_active_user 
FROM log_videoproblem t1 
LEFT JOIN user_city t2 ON t1.user_primary_key=t2.user_primary_key
GROUP BY 1,2
ORDER BY 1 ASC, 3 DESC;


-- Question3: 
-- 從圖表中可以看到均一持續累積的社會影響力，包含註冊人數，每週活躍人數，使用時間等等。
-- 另外我會思考一個問題，這份報表想提供給哪些人看，在上次談話中有提到，均一平台的主要服務對象有ToC, ToB, ToG，
-- 目前的趨勢數據我認為比較適合給ToG/ToB，讓他們可以了解到均一學習平台的影響力

-- 針對ToC，可以「user使用產品的engagement」為思考方向，設計圖表呈現。例如均一目前服務的學生很廣，從國小, 國中, 高中都有，
-- 科目包含全科，可從中進行資料探勘，了解目前均一的使用者當中，「在籍的學生其年級分佈」，「在每一年級當中主要觀看的科目有哪一些」
-- 透過此一分析抓到均一核心的產品強項，作為吸引C端族群的使用動機

-- 另外建議可針對user role查看當週內容使用人次(stack bar chart)與使用時長（stack bar chart）查看student和teacher的使用情形變化
-- 由此可瞭解平台的主要使用者student和teacher他們的實際投入情況(engagement)，以作為成果回饋。
-- 下表為使用人次 

SELECT YEARWEEK(t1.date) AS week,
		SUM(CASE WHEN t2.user_role = 'Teacher' and t1.content_kind='Video' THEN 1 ELSE 0 END) AS teacher_video,
		SUM(CASE WHEN t2.user_role = 'Teacher' and t1.content_kind='Exercise' THEN 1 ELSE 0 END) AS teacher_exercise,
		SUM(CASE WHEN t2.user_role = 'Student' and t1.content_kind='Video' THEN 1 ELSE 0 END) AS student_video,
		SUM(CASE WHEN t2.user_role = 'Student' and t1.content_kind='Exercise' THEN 1 ELSE 0 END) AS student_exercise
FROM log_videoproblem t1
JOIN info_userdata t2 ON t1.user_primary_key=t2.user_primary_key
GROUP BY 1
ORDER BY 1;


-- 下表為使用時長
-- 使用時長估算說明：依據log_videoplay表單中的欄位is_session_end進行推估
-- 使用時長＝(0的個數加總)*30+(1的個數加總）* 估計學習時間15分鐘
-- 未滿30分鐘的學習階段，以眾數15分鐘計算（參考網站https://www.junyiacademy.org/statistics，各時段平均使用時間圖表）

WITH session_check AS (
	SELECT t1.date as date, t2.user_role as user_role, t1.is_session_end as is_session_end 
    FROM log_videoplay t1
    JOIN info_userdata t2 ON t1.user_primary_key=t2.user_primary_key
    WHERE t2.user_role='Teacher' or t2.user_role='Student' 
)

SELECT YEARWEEK(date) AS week, 
		SUM(CASE WHEN user_role = 'Teacher' and is_session_end=0 THEN 30 
				 WHEN user_role = 'Teacher' and is_session_end=1  THEN 15 ELSE 0 END) AS teacher,
		SUM(CASE WHEN user_role = 'Student' and is_session_end=0 THEN 30 
                 WHEN user_role = 'Student' and is_session_end=1 THEN 15 ELSE 0 END) AS student
FROM session_check
GROUP BY 1;
