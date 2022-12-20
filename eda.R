#### EDA ####
## 1) vendor_id
table(taxi$vendor_id)
barplot(table(taxi$vendor_id))
text(barplot(table(taxi$vendor_id)),
     table(taxi$vendor_id)*0.6,
     labels=table(taxi$vendor_id), cex=1)
# vendor_id 종류에 따른 택시 수 큰 차이 없음
# 명시되지 않은 vendor_id가 관측되지 않음


## 2) payment_type
table(taxi$payment_type)
barplot(table(taxi$payment_type))
text(barplot(table(taxi$payment_type)),
     2*10^6,
     labels=table(taxi$payment_type), cex=0.8)


## 3) fare_amount
hist(taxi$fare_amount, breaks=100)
head(sort(taxi$fare_amount, decreasing = T), 100)
head(sort(taxi$fare_amount), 100)  # 기본 요금은 2.5
sum(taxi$fare_amount<2.5)
sum(taxi$fare_amount>100) ; sum(taxi$fare_amount>200)
fivenum(taxi$fare_amount)
# 0 근처에 값이 많이 모여있음을 알 수 있음
# 음수 값을 포함하여 기본요금 미만의 값들이 존재하며, 전처리 시 제거 필요함
# fare_amount가 분포에 비해 많이 나오는 경우도 확인이 필요함


## 4) surcharge
## MTA State Surcharge (0.5$) / Improvement Surcharge (0.3$) / New York State Congestion Surcharge (2.5$ or 2.75$)
sort(unique(taxi$surcharge))
table(taxi$surcharge)
# surcharge도 금액의 일종이라서 0 이상의 값만 존재해야하나, 음수 값 존재함
# 거의 모든 관측치 0, 0.5, 1 중 하나의 값 가짐 -> 전체 중 99.9968% 차지함
# 음수 값과 극심한 이상치인 649.92는 제거 필요


## 5) mta_tax
sort(unique(taxi$mta_tax))
table(taxi$mta_tax)
sum(taxi$mta_tax==0.5) / nrow(taxi)
# 미터기 사용되면, 자동적으로 0.5$의 mta_tax 부과된다고 알려져 있음
# mta_tax도 금액의 일종이나, 음수 값 존재함
# mta_tax가 0.5인 경우가 전체의 99.6%임


## 6) tip_amount
hist(taxi$tip_amount, breaks=200)
head(sort(taxi$tip_amount, decreasing = T), 100)
head(sort(taxi$tip_amount), 100) # 요금이므로 0 이상의 값을 가져야함
sum(taxi$tip_amount<0)
sum(taxi$tip_amount>=0 & taxi$tip_amount < 10)
sum(taxi$tip_amount>50) ; sum(taxi$tip_amount>100) ; sum(taxi$tip_amount>200)
fivenum(taxi$tip_amount)
# 음수 값이 존재함
# 대부분의 값이 0과 10 사이에 분포하여 있음 (약 98.7%)


## 7) tolls_amount
hist(taxi$tolls_amount, breaks=200)
head(sort(taxi$tolls_amount, decreasing = T), 100)
head(sort(taxi$tolls_amount), 100)
sum(taxi$tolls_amount==0)
sum(taxi$tolls_amount==0) / nrow(taxi)
sum(taxi$tolls_amount>10) ; sum(taxi$tolls_amount>20)
# 음수 값이 존재함
# 뉴욕 시내 택시 데이터이기 때문에 tolls_amount가 0인 경우가 전체의 95.5% 정도 차지함


## 8) total_amount
hist(taxi$total_amount, breaks=200)
head(sort(taxi$total_amount, decreasing = T), 100)
head(sort(taxi$total_amount), 100)
sum(taxi$total_amount<2.5) # 기본 요금 2.5
sum(taxi$total_amount>100) ; sum(taxi$total_amount>200)
fivenum(taxi$total_amount)
sum(taxi$total_amount>=2.5 & taxi$total_amount<=50)/nrow(taxi)
# 음수 값 포함 기본 요금 2.5보다 작은 값 존재함. 
# 기본 요금 이상 15달러 이하의 금액이 관측된 경우가 전체 데이터의 70%
# 기본 요금 이상 50달러 이하의 금액이 관측된 경우가 전체 데이터의 97%


## 9) rate_code
unique(taxi$rate_code)
table(taxi$rate_code)
sum(taxi$rate_code==1 | taxi$rate_code==2 | taxi$rate_code==3 | taxi$rate_code==4 |
      taxi$rate_code==5 | taxi$rate_code==6)
sum(taxi$rate_code==1 | taxi$rate_code==2 | taxi$rate_code==3 | taxi$rate_code==4 |
      taxi$rate_code==5 | taxi$rate_code==6) / nrow(taxi)
# 1, 2, 3, 4, 5, 6만 있어야함. (자료 변수 설명 명세 참고)
# rate_code가 0, 7, 8, 9, 210인 값들은 존재할 수 없으므로 이상치로 판단하고 추후 제거 필요
# rate_code가 1~6 사이의 값으로 제대로 입력된 관측치는 전체의 99.98%를 차지함


## 10) pickup_datetime
### 10.1) 월별
table(month(taxi$pickup_datetime))
sort(table(month(taxi$pickup_datetime)), dec=T)
barplot(sort(table(month(taxi$pickup_datetime)), dec=T))
text(barplot(sort(table(month(taxi$pickup_datetime)), dec=T)),
     sort(table(month(taxi$pickup_datetime)), dec=T)*0.6,
     labels=sort(table(month(taxi$pickup_datetime)), dec=T), cex=0.6)
# 2013년도 뉴욕 택시는 3월에 가장 많이 운행되었으며, 8월에 가장 적게 운행되었음
# 4분기 중 봄(3-5월)의 운행량이 가장 많았음. (3, 5, 4월이 운행 많은 순으로 따졌을 때 1, 2, 3위였음)

### 10.2) 요일별 (1이 일요일)
wday_pickup=lubridate::wday(taxi$pickup_datetime, label=T)
sort(table(wday_pickup), dec=T)
barplot(sort(table(wday_pickup), dec=T))
text(barplot(sort(table(wday_pickup), dec=T)),
     sort(table(wday_pickup), dec=T)*0.6,
     labels=sort(table(wday_pickup), dec=T), cex=0.7)
# 금요일에 택시 이용이 가장 많으며, 월요일이 가장 적음
# 전체 8658800개의 데이터가 있고, 금요일과 월요일의 관측치 차이가 약 20만개이므로, 요일 간의 편차가 크지 않다고 볼 수 있음

### 10.3) 시간별
table(hour(taxi$pickup_datetime))
sort(table(hour(taxi$pickup_datetime)), dec=T)
barplot(table(hour(taxi$pickup_datetime)))
# 퇴근 시간대인 18-20시의 택시 이용량이 가장 많음
# 사람들의 주요 활동 시간이 아닌 새벽 3-5시의 택시 이용량이 가장 적음


## 11) dropoff_datetime
### 11.1) 월별
table(month(taxi$dropoff_datetime))
sort(table(month(taxi$dropoff_datetime)), dec=T)
barplot(sort(table(month(taxi$dropoff_datetime)), dec=T))
text(barplot(sort(table(month(taxi$dropoff_datetime)), dec=T)),
     sort(table(month(taxi$dropoff_datetime)), dec=T)*0.6,
     labels=sort(table(month(taxi$dropoff_datetime)), dec=T), cex=0.6)

### 11.2) 요일별 (1이 일요일)
wday_dropoff=lubridate::wday(taxi$dropoff_datetime, label=T)
sort(table(wday_dropoff), dec=T)
barplot(sort(table(wday_dropoff), dec=T))
text(barplot(sort(table(wday_dropoff), dec=T)),
     sort(table(wday_dropoff), dec=T)*0.6,
     labels=sort(table(wday_dropoff), dec=T), cex=0.7)

### 11.3) 시간별
table(hour(taxi1$dropoff_datetime))
sort(table(hour(taxi1$dropoff_datetime)), dec=T)
barplot(table(hour(taxi1$dropoff_datetime)))

# pickup_datetime와 분포 및 관측치 순위 거의 동일함

# 승하차 시간 동일 여부 확인
sum(taxi$dropoff_datetime == taxi$pickup_datetime)


## 12) passenger_count
sort(unique(taxi$passenger_count))
table(taxi$passenger_count)
sort(table(taxi$passenger_count), dec=T)
barplot(table(taxi$passenger_count))
sum(taxi$passenger_count==1)/nrow(taxi)
# 0인 값들, 그리고 불가능한 관측치인 208도 존재함
# 승객이 1명인 경우(관측치)가 전체의 70%


## 13) trip_time_in_secs
hist(taxi$trip_time_in_sec, breaks=100)
head(sort(taxi$trip_time_in_sec),120)
head(sort(taxi$trip_time_in_sec, dec=T), 120)
sum(taxi$trip_time_in_secs==0)
sum(taxi$trip_time_in_secs>0 & taxi$trip_time_in_secs < 1800) / nrow(taxi)
# 400만초(약 1111시간) 이상으로 측정된 관측치도 114개 존재함
# -10이라는 음수 관측치도 52개 존재하고, 0으로 측정된 관측치는 23638개 존재함
# 1800초 (30분) 미만으로 운행된 택시 관측치가 전체의 94.56%임


## 14) trip_distance
hist(taxi$trip_distance, breaks=100)
head(sort(taxi$trip_distance), 100)
head(sort(taxi$trip_distance, dec=T), 100)
sum(taxi$trip_distance==0)
sum(taxi$trip_distance==0 & taxi$trip_time_in_secs==0)
fivenum(taxi$trip_distance)
sum(taxi$trip_distance>0 & taxi$trip_distance<10)/nrow(taxi)
# 1000이 넘어가는 관측치 12개 존재함. 이상치로 판단 가능
# 음수 값은 없으며, 0인 관측치는 56352개 존재함
# 56352개 중 trip_time_in_secs도 함께 0인 관측치도 16299개 있음
# taxi_distance가 0 초과 10 미만인 관측치가 전체의 약 95% 차지함


## 15) pickup_longitude (경도)
### 뉴욕주 경도 : 71°47'25"W - 79°45'54"W
### 뉴욕주 위도 : 40°29'40"N - 45°0'42"N
### 뉴욕시 정확한 지리적 좌표, 위도 및 경도 — 40.7127837, -74.0059413

head(sort(taxi$pickup_longitude), 50)
head(sort(taxi$pickup_longitude, decreasing = T), 50)
hist(taxi1$pickup_longitude, breaks=100)

# 뉴욕 시와 그 외곽 정도로 범위를 생각하여 -73 ~ -75인 값들만 가져오기
table(cut(taxi$pickup_longitude, breaks=c(-Inf, -80, -75, -73, -70, 0, Inf)))
sum(taxi$pickup_longitude<= -73 & taxi$pickup_longitude > -75)/nrow(taxi)

# 경도가 양수인 (서쪽이라서 음수 값) 관측치들도 26947개 존재하고, 음수 값에서도 경도 범위를 벗어난 이상치들이 존재함
# 뉴욕시의 경도가 -74라는 점을 활용하여, 그룹을 나누어주었을 때 pickup_longitude가 -73~-75 사이의 값을 가지는 관측치가 전체의 98%임


## 16) dropoff_longitude
head(sort(taxi$dropoff_longitude), 50)
head(sort(taxi$dropoff_longitude, decreasing = T), 50)
hist(taxi1$dropoff_longitude, breaks=100)
sum(taxi$dropoff_longitude >= 0 & taxi$pickup_longitude >= 0) 

# 뉴욕 시와 그 외곽 정도로 범위를 생각하여 -73 ~ -75인 값들만 가져오기
table(cut(taxi$dropoff_longitude, breaks=c(-Inf, -80, -75, -73, -70, 0, Inf)))
sum(taxi$dropoff_longitude<= -73 & taxi$dropoff_longitude > -75)/nrow(taxi)

# pickup_longitude와 dropoff_longitude가 모두 0 이상의 값을 가지는 관측치도 158970개 존재함
# 뉴욕시의 경도가 -74라는 점을 활용하여, 그룹을 나누어주었을 때 dropoff_longitude가 -73~-75 사이의 값을 가지는 관측치가 전체의 98%임

# abs(pickup-dropoff) 가 0인지 check
sum(taxi$pickup_longitude-taxi$dropoff_longitude==0)
# pickup_longitude와 dropoff_longitude의 차가 0인 값들(택시 운행(이동)했다고 보기 어려움)도 208623개 존재함


## 17) pickup_latitude
head(sort(taxi$pickup_latitude), 50)
head(sort(taxi$pickup_latitude, decreasing = T), 50)
hist(taxi1$pickup_latitude, breaks=100)

# 뉴욕 시와 그 외곽 정도로 범위를 생각하여 40~42인 값들만 가져오기
table(cut(taxi$pickup_latitude, breaks=c(-Inf, 0, 35, 40, 42, 47, Inf)))
sum(taxi$pickup_latitude<= 42 & taxi$pickup_latitude > 40)/nrow(taxi)

# 위도가 0을 포함한 음수 값 (북쪽이라서 양수여야 함) 가지는 관측치가 163245개 존재함
# 뉴욕시의 위도가 40.7라는 점을 활용하여, 그룹을 나누어주었을 때 pickup_latitude가 40~42 사이의 값을 가지는 관측치가 전체의 98%임

# 18) dropoff_latitude
head(sort(taxi$dropoff_latitude), 50)
head(sort(taxi$dropoff_latitude, decreasing = T), 50)
hist(taxi1$dropoff_latitude, breaks=100)

# 뉴욕 시와 그 외곽 정도로 범위를 생각하여 40~42인 값들만 가져오기.
table(cut(taxi$dropoff_latitude, breaks=c(-Inf, 0, 35, 40, 42, 47, Inf)))
sum(taxi$dropoff_latitude<= 42 & taxi$dropoff_latitude > 40)/nrow(taxi)

# 위도가 0을 포함한 음수 값 (북쪽이라서 양수여야 함) 가지는 관측치가 168336개 존재함
# 뉴욕시의 위도가 40.7라는 점을 활용하여, 그룹을 나누어주었을 때 dropoff_latitude가 40~42 사이의 값을 가지는 관측치가 전체의 98%임

# abs(pickup-dropoff) 가 0인지 확인
sum(taxi$pickup_latitude-taxi$dropoff_latitude==0)
# pickup_latitude, dropoff_latitude의 차가 0인 관측치가 206714개 존재함. 이 경우 택시 운행을 제대로 했다고 보기 어려움