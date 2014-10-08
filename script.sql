-- cityTableName = prefix+dataType+"_CITIES";
-- 	userTableName = prefix+dataType+"_USERS";
-- 	friendsTableName = prefix+dataType+"_FRIENDS";
-- 	currentCityTableName = prefix+dataType+"_USER_CURRENT_CITY";
-- 	hometownCityTableName = prefix+dataType+"_USER_HOMETOWN_CITY";
-- 	programTableName = prefix+dataType+"_PROGRAMS";
-- 	educationTableName = prefix+dataType+"_EDUCATION";
-- 	eventTableName = prefix+dataType+"_USER_EVENTS";
-- 	albumTableName = prefix+dataType+"_ALBUMS";
-- 	photoTableName = prefix+dataType+"_PHOTOS";
-- 	tagTableName = prefix+dataType+"_TAGS";

-- select count(*),  last_name from yjtang.public_users where last_name is not null group by last_name order by count(*) desc;

-- select last_name, length(last_name) from yjtang.public_users where last_name is not null group by last_name order by length(last_name) desc;

-- select user_id from yjtang.public_users where user_id not in 
-- (select user1_id from yjtang.public_friends UNION select user2_id from yjtang.public_friends);

-- select U.user_id, U.first_name, U.last_name from 
-- yjtang.public_users U, yjtang.public_user_current_city C, yjtang.public_user_hometown_city H
-- where U.user_id = C.user_id and U.user_id = H.user_id and C.current_city_id = H.hometown_city_id;



-- select U.user_id, U.first_name, U.last_name
-- from yjtang.public_users U, yjtang.public_tags T
-- where T.tag_subject_id = U.user_id
-- and T.tag_photo_id = 1051;

-- select * from
-- (
-- 	select tag_photo_id
-- 	from yjtang.public_tags
-- 	group by tag_photo_id
-- 	order by count(*) desc, tag_photo_id
-- )
-- where rownum < 5;

-- Query 5
-- view
-- This is right without dealing with ties
-- select M.user_id, F.user_id
-- from yjtang.public_users M, yjtang.public_users F, yjtang.public_tags T1, yjtang.public_tags T2
-- where (M.user_id, F.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
-- and (F.user_id, M.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
-- and M.user_id != F.user_id
-- and M.gender = 'male'
-- and F.gender = 'female'
-- and ABS(M.year_of_birth - F.year_of_birth) <= 2
-- and M.user_id = T1.tag_subject_id
-- and F.user_id = T2.tag_subject_id
-- and T1.tag_photo_id = T2.tag_photo_id;

-- create view satisifiedPairs as
-- select T1.tag_photo_id as Pid, M.user_id as Mid, F.user_id as Fid
-- from yjtang.public_users M, yjtang.public_users F, yjtang.public_tags T1, yjtang.public_tags T2
-- where (M.user_id, F.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
-- and (F.user_id, M.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
-- and M.user_id != F.user_id
-- and M.gender = 'male'
-- and F.gender = 'female'
-- and ABS(M.year_of_birth - F.year_of_birth) <= 2
-- and M.user_id = T1.tag_subject_id
-- and F.user_id = T2.tag_subject_id
-- and T1.tag_photo_id = T2.tag_photo_id;

-- select count(*) as sharedPhotoNum, Mid, Fid
-- from satisifiedPairs
-- group by (Mid, Fid)
-- order by sharedPhotoNum desc, Fid, Mid;

-- select S.Pid, P.album_id, A.album_name, P.photo_caption, P.photo_link
-- from satisifiedPairs S, yjtang.public_photos P, yjtang.public_albums A
-- where S.Mid = 65 and S.Fid = 708
-- and P.photo_id = S.Pid
-- and A.album_id = P.album_id;

-- drop view satisifiedPairs;


-- Query 6
create view sharedFriendPairs as
select U1.user_id as user1, U2.user_id as user2, F1.user2_id as sharedFriend
from yjtang.public_users U1, yjtang.public_users U2, 
yjtang.public_friends F1, yjtang.public_friends F2
where U1.user_id < U2.user_id
and (U1.user_id, U2.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
and (U1.user_id = F1.user1_id and U2.user_id = F2.user1_id and F1.user2_id = F2.user2_id)
UNION
select U1.user_id as user1, U2.user_id as user2, F1.user2_id as sharedFriend
from yjtang.public_users U1, yjtang.public_users U2, 
yjtang.public_friends F1, yjtang.public_friends F2
where U1.user_id < U2.user_id
and (U1.user_id, U2.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
and (U1.user_id = F1.user1_id and U2.user_id = F2.user2_id and F1.user2_id = F2.user1_id)
UNION
select U1.user_id as user1, U2.user_id as user2, F1.user1_id as sharedFriend
from yjtang.public_users U1, yjtang.public_users U2, 
yjtang.public_friends F1, yjtang.public_friends F2
where U1.user_id < U2.user_id
and (U1.user_id, U2.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
and (U1.user_id = F1.user2_id and U2.user_id = F2.user2_id and F1.user1_id = F2.user1_id)
UNION
select U1.user_id as user1, U2.user_id as user2, F1.user2_id as sharedFriend
from yjtang.public_users U1, yjtang.public_users U2, 
yjtang.public_friends F1, yjtang.public_friends F2
where U1.user_id < U2.user_id
and (U1.user_id, U2.user_id) not in (select user1_id, user2_id from yjtang.public_friends)
and (U1.user_id = F1.user1_id and U2.user_id = F2.user2_id and F1.user2_id = F2.user1_id);

select * from(
select count(*) sharedFriendNum, user1, user2
from sharedFriendPairs
group by (user1, user2)
order by sharedFriendNum desc, user1 asc, user2 asc
)
where rownum < 5;

select sharedFriend
from sharedFriendPairs
where user1 = 
and user2 = 

drop view sharedFriendPairs;


-- Query 7
-- select * from
-- (select U.user_id
-- from yjtang.public_users U, yjtang.public_friends friends
-- where (U.user_id = friends.user1_id and friends.user2_id = 215)
-- or (U.user_id = friends.user2_id and friends.user1_id = 215)
-- order by U.year_of_birth desc, U.month_of_birth desc, U.day_of_birth desc, U.user_id asc)
-- where rownum <= 1;

-- Query 8
-- select count(*) as num, event_city_id
-- from yjtang.public_user_events
-- group by event_city_id
-- order by num desc;

-- Query 9
-- select S1.user_id, S2.user_id
-- from yjtang.public_users S1, yjtang.public_users S2, 
-- yjtang.public_user_hometown_city H1, yjtang.public_user_hometown_city H2
-- where S1.last_name = S2.last_name
-- and S1.user_id = H1.user_id and S2.user_id = H2.user_id
-- and H1.hometown_city_id = H2.hometown_city_id
-- and S1.user_id < S2.user_id
-- and (S1.user_id, S2.user_id) in (select user1_id, user2_id from yjtang.public_friends)
-- and ABS(S1.year_of_birth - S2.year_of_birth) < 10
-- order by S1.user_id, S2.user_id;
