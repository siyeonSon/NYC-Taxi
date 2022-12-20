#### 전처리 ####
### 1. 이론적으로 존재해서는 안 되는 데이터 제거
dim(taxi)
taxi = taxi[taxi$fare_amount>=2.5,] # 택시 기본 요금 2.5
taxi = taxi[taxi$surcharge>=0,]
taxi = taxi[taxi$mta_tax>=0,]
taxi = taxi[taxi$tip_amount>=0,]
taxi = taxi[taxi$tolls_amount>=0,]
taxi = taxi[taxi$total_amount>=2.5,] # 택시 기본 요금 2.5 ( total = fare + 다른 요금들)
taxi=taxi[which(taxi$rate_code==1 | taxi$rate_code==2 | taxi$rate_code==3 
                | taxi$rate_code==4 | taxi$rate_code==5 |taxi$rate_code==6),]

taxi = taxi[taxi$trip_time_in_secs>0,]
taxi = taxi[taxi$trip_distance>0,]

## 위도(latitude)의 유효 범위 : -90 ~ 90
## 경도(longitude)의 유효 범위 : -180 ~ 180
taxi=taxi[(taxi$pickup_longitude >=-180 & taxi$pickup_longitude<= 180), ]
taxi=taxi[(taxi$dropoff_longitude >=-180 & taxi$dropoff_longitude<= 180), ]
taxi=taxi[(taxi$pickup_latitude >=-90 & taxi$pickup_latitude<= 90), ]
taxi=taxi[(taxi$dropoff_latitude >=-90 & taxi$dropoff_latitude<= 90), ]
dim(taxi)  # 8658800 - 8593467 = 65333개의 이상치 제거됨


### 2. 데이터 특성 상 말이 안 되는 데이터들 제거하자
# fare_amount / surcharge / mta
# 요금의 경우 음수 값을 제거해줌으로써 하한값은 정해짐.
# 상한값 기준으로 3사분위수 + 3 * IQR을 선정하였음.

IQR_fun_1 <- function(x) {
  UpperQ = fivenum(x)[4]
  LowerQ = fivenum(x)[2]
  IQR = UpperQ - LowerQ
  
  upperOutlier = x[ which( x > UpperQ + IQR*3) ]
  lowerOutlier = x[ which( x < LowerQ - IQR*3) ]
  
  taxi <<- taxi[!(x > UpperQ + IQR*3), ]
  return(length(upperOutlier))  # 이상치로 판정되어 제거되는 데이터의 개수를 의미
}
# IQR_fun_1 함수가 적용되는 순서에 따라, IQR_fun_1에서 리턴되는 값 달라질 수 있음
IQR_fun_1(taxi$fare_amount) 
IQR_fun_1(taxi$surcharge)
IQR_fun_1(taxi$mta_tax)
IQR_fun_1(taxi$tip_amount)
IQR_fun_1(taxi$tolls_amount)
IQR_fun_1(taxi$total_amount)


# dropoff_datetime / pickup_datetime
# dropoff_datetime - pickup_datetime 차이가 0 이하인 관측치들은 제대로 된 운행을 했다고 보기 어려우므로, 제거
# dropoff_datetime - pickup_datetime 차이가 너무 많이 나는 경우, 뉴욕 및 인근에서 운행했다고 보기 어려우므로 제거
# 차이가 너무 많이 난다의 기준은 trip_time_in_secs와 동일하게 7200으로 설정
sum(ymd_hms(taxi$dropoff_datetime) - ymd_hms(taxi$pickup_datetime) <=0)
taxi = taxi[ymd_hms(taxi$dropoff_datetime) - ymd_hms(taxi$pickup_datetime)>0, ]

head(sort(ymd_hms(taxi$dropoff_datetime) - ymd_hms(taxi$pickup_datetime), dec=T),100)
sum(ymd_hms(taxi$dropoff_datetime) - ymd_hms(taxi$pickup_datetime)>7200)
taxi = taxi[ymd_hms(taxi$dropoff_datetime) - ymd_hms(taxi$pickup_datetime) <=7200, ]


# trip_time_in_secs의 경우 뉴욕 시내를 운행하는 택시이므로, 서울과 뉴욕의 면적 비교를 하여,
# 최대 운행 시간을 2시간으로 정하고, 2시간을 초과하는 관측치는 이상치로 처리하여 제거함
sum(taxi$trip_time_in_secs>7200)
taxi = taxi[taxi$trip_time_in_secs <= 7200,]


# passenger_count
unique(taxi$passenger_count)
# 1명 미만, 7명 이상이 한 택시에 타기는 어려우므로, 1~6 사이 값 이외의 값을 이상치로 생각함.
table(taxi$passenger_count)
sum(taxi$passenger_count <1 | taxi$passenger_count >=7)
taxi = taxi[!(taxi$passenger_count <1 | taxi$passenger_count >=7),]


# latitude / longitude
# 뉴욕시 택시 데이터이기에, 경도 -73~-75 / 위도 40~42 이외의 값들은 이상치로 생각하기
taxi = taxi[taxi$pickup_longitude<= -73 & taxi$pickup_longitude >= -75 , ]
taxi = taxi[taxi$dropoff_longitude<= -73 & taxi$dropoff_longitude >= -75 , ]

taxi = taxi[taxi$pickup_latitude >=40 & taxi$pickup_latitude<=42,]
taxi = taxi[taxi$dropoff_latitude >=40 & taxi$dropoff_latitude<=42,]


# trip_distance
dim(taxi)
# 1000 이상의 값들만 제거(8개) 3IQR 썼을 때 기준이 8.2임
head(sort(taxi$trip_distance, dec=T),20)
taxi = taxi[taxi$trip_distance<1000,]

dim(taxi) # 7874913개의 데이터 (2번 과정에서 718554개의 데이터 제거됨)


### 3. 주제(목적)에 맞게 최종 전처리
# 오후 11시부터 오전 7시까지 택시를 이용한 데이터만을 추출
taxi_night = taxi
taxi_night = subset(taxi_night , (hour(taxi_night$pickup_datetime) >= 23) | hour(taxi_night$pickup_datetime) < 7 )
nrow(taxi_night)  # 데이터의 개수 1566375