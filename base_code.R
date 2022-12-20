# 패키지 설치
library(rhdfs)
hdfs.init()
library(rmr2)
library(lubridate)
library(ggmap)
library(ggplot2)
library(dplyr)
# library(devtools)

rmr.options(backend = "hadoop")


#### 기본코드 ####

# HDFS 상의 taxi 자료 파일 확인
files <- hdfs.ls("/data/taxi/combined")$file

# info.csv에 포함된 변수 이름과 클래스 정보 읽기 
mr <- mapreduce(input = files[1],
                input.format = make.input.format(format = "csv", sep=",", stringsAsFactors=F))
res <- from.dfs(mr)
ress <- values(res)
colnames.tmp <- as.character(ress[,1])
class.tmp <- as.character(ress[,2])

colnames <- colnames.tmp[-1]  # 변수 이름
class <- class.tmp[-1]  # 변수 클래스
class[c(6,8,9,10)] <- "numeric"  # 자료형 integer -> numeric

# 자료의 input format 지정 
input.format <- make.input.format(format = "csv", sep = ",", stringsAsFactors = F,
                                  col.names = colnames, colClasses = class)
files <- files[-1]  # info.csv 제외
data <- mapreduce(input = files,
                  input.format = input.format)
res.data <- from.dfs(data)
taxi <- res.data$val  # value 값만 가지고 오기. (key는 NULL인 상태)
str(taxi) 
head(taxi)


#### 결측치 제거 / 데이터 기본 정제 ####
dim(taxi)
colSums(is.na(taxi))
sum(which(is.na(taxi$dropoff_longitude))==which(is.na(taxi$dropoff_latitude)))
sum(which(is.na(taxi$dropoff_longitude))!=which(is.na(taxi$dropoff_latitude)))
taxi = na.omit(taxi)
dim(taxi)  # 결측치가 들어있는 행 개수만큼 row 수 감소

taxi=taxi[,-c(1, 2, 12)]  # medallion, hack_license, store_and_fwd_flag column 삭제
dim(taxi)  # 변수가 기존 21개에서 18개로 줄었음