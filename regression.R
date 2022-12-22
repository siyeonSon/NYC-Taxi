### 2. 회귀 분석
# 회귀모델 선택 -> kmeans.df(path.df) 넣기 -> 추정 요금 도출하기
## kmeans를 통해 도출된 좌표
longitude <- c(-73.99948, -73.99628, -73.99512, -73.99458, -73.99172, -73.98532,
               -73.97509, -73.98413, -73.98300, -73.98035, -73.95222, -73.95901)
latitude <- c(40.72108, 40.72654, 40.72944, 40.73079, 40.73657, 40.74675,
              40.74770, 40.75385, 40.75789, 40.76021, 40.77389, 40.78091)


## 회귀모델1 추정 및 검정
# 반응변수로는 fare_amount 사용 
# total_amount은 기본 요금 외 tip, tax 등의 택시에만 있는 부가 요금이 있기에, fare_amount로 설정
# 설명변수로는 trip_distance, pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude 사용
map.fun1 <- function(k, v){
  dat <- data.frame(fare = v$fare_amount, dist=v$trip_distance, p.lon=v$pickup_longitude, 
                    p.lat=v$pickup_latitude, d.lon=v$dropoff_longitude, d.lat = v$dropoff_latitude)
  Xk <- model.matrix(fare ~ ., dat)
  yk <- as.matrix(dat[,1])
  XtXk <- crossprod(Xk,Xk)
  Xtyk <- crossprod(Xk,yk)
  ytyk <- crossprod(yk,yk)
  res<-list(XtXk, Xtyk, ytyk)
  keyval(1, res)
}

# reduce.fun의 경우 모든 모델에 동일하게 적용
reduce.fun <- function(k, v) {
  XtX <- Reduce("+",v[seq_along(v) %% 3 == 1])
  Xty <- Reduce("+",v[seq_along(v) %% 3 == 2])
  yty <- Reduce("+",v[seq_along(v) %% 3 == 0])
  
  res = list(XtX = XtX, Xty = Xty, yty = yty)
  keyval(1, res)
}

reg.result1 <-values(from.dfs(mapreduce(input=to.dfs(taxi_night[,c("fare_amount", "trip_distance", "pickup_longitude",
                                                                   "pickup_latitude", "dropoff_longitude", "dropoff_latitude")]),
                                        map=map.fun1, reduce=reduce.fun, combine=T)))

# summary.fun의 경우 모든 모델에 동일하게 적용
summary.fun <- function(v) {
  XtX<-v$XtX ;   Xty <- v$Xty ;   yty <- v$yty
  beta.hat <- solve(XtX, Xty) # 회귀계수
  nn <- XtX[1,1] ; ysum <- Xty[1] ; ybar <- ysum/nn
  stat <- list(nn = nn, beta.hat = beta.hat, ysum = ysum, ybar = ybar)
  
  SSE <- yty - crossprod(beta.hat, Xty)  # 오차제곱합
  SST <- yty - ysum^2/nn  # 총제곱합
  SSR <- SST - SSE  # 회귀제곱합
  SS <- list(SSR = SSR, SSE = SSE, SST = SST)
  
  df.reg <- dim(XtX)[1L] - 1
  df.tot <- nn - 1
  df.res <- df.tot - df.reg
  DF <- list(df.reg = df.reg, df.res = df.res, df.tot = df.tot)
  
  MSR <- SSR / df.reg
  MST <- SST / df.tot
  MSE <- SSE / df.res
  MS <- list(MSR = MSR, MSE = MSE, MST = MST)
  
  f.val <- MS$MSR / MS$MSE
  p.val <- pf(f.val, DF$df.reg, DF$df.res, lower.tail = F)
  Rsq <- 1-(SSE/SST)
  anova <- list(DF = DF, SS = SS, MS = MS, f.val = f.val, p.val = p.val, Rsq=Rsq)
  
  res <- list(mat = v, stat = stat, anova = anova)
}

reg.summary1 <- summary.fun(reg.result1) ; reg.summary1

## 회귀모델2 추정 / 검정
# 반응변수로는 fare_amount 사용 
# total_amount은 기본 요금 외 tip, tax 등의 택시에만 있는 부가 요금이 있기에, fare_amount로 설정
# 설명변수로 pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude 사용 (trip_distance 제외한 좌표 변수들만 사용함)

map.fun2 <- function(k, v){
  dat <- data.frame(fare = v$fare_amount, p.lon=v$pickup_longitude, 
                    p.lat=v$pickup_latitude, d.lon=v$dropoff_longitude, d.lat = v$dropoff_latitude)
  Xk <- model.matrix(fare ~ ., dat)
  yk <- as.matrix(dat[,1])
  XtXk <- crossprod(Xk,Xk)
  Xtyk <- crossprod(Xk,yk)
  ytyk <- crossprod(yk,yk)
  res<-list(XtXk, Xtyk, ytyk)
  keyval(1, res)
}

reg.result2 <-values(from.dfs(mapreduce(input=to.dfs(taxi_night[,c("fare_amount", "pickup_longitude",
                                                                   "pickup_latitude", "dropoff_longitude", "dropoff_latitude")]),
                                        map=map.fun2, reduce=reduce.fun, combine=T)))
reg.summary2 <- summary.fun(reg.result2) ; reg.summary2


## 회귀모델3 추정 / 검정
# 반응변수로는 fare_amount 사용 
# total_amount은 기본 요금 외 tip, tax 등의 택시에만 있는 부가 요금이 있기에, fare_amount로 설정
# 설명변수로는 좌표를 나타내는 설명변수들만 제외한 trip_distance만 사용

map.fun3 <- function(k, v){
  dat <- data.frame(fare = v$fare_amount, dist = v$trip_distance)
  Xk <- model.matrix(fare ~ ., dat)
  yk <- as.matrix(dat[,1])
  XtXk <- crossprod(Xk,Xk)
  Xtyk <- crossprod(Xk,yk)
  ytyk <- crossprod(yk,yk)
  res<-list(XtXk, Xtyk, ytyk)
  keyval(1, res)
}

reg.result3 <-values(from.dfs(mapreduce(input=to.dfs(taxi_night[,c("fare_amount", "trip_distance")]),
                                        map=map.fun3, reduce=reduce.fun, combine=T)))


reg.summary3 <- summary.fun(reg.result3) ; reg.summary3

## 회귀모델 간 MSE / Rsquare 비교
model_check<-data.frame(MSE = c(reg.summary1$anova$MS$MSE, reg.summary2$anova$MS$MSE, reg.summary3$anova$MS$MSE),
                        Rsquare= c(reg.summary1$anova$Rsq, reg.summary2$anova$Rsq, reg.summary3$anova$Rsq))


## kmeans dataframe  + dist 열 추가 -> path.df 만들기
path.df <- data.frame(pickup_longitude=c(longitude, rev(longitude)[2:(length(longitude)-1)]), 
                      pickup_latitude=c(latitude, rev(latitude)[2:(length(latitude)-1)]),
                      dropoff_longitude=1, dropoff_latitude=1)

# 경로 설정(연결)을 위해 다음 경로의 pickup이 바로 앞 경로의 dropoff가 될 수 있도록 함
change_dropoff<-function(df){
  for (i in 1:nrow(df)) {
    if (i == nrow(df)) {
      df$dropoff_longitude[i] <- df$pickup_longitude[1]
      df$dropoff_latitude[i] <- df$pickup_latitude[1]
    }
    else {
      df$dropoff_longitude[i] <- df$pickup_longitude[i+1]
      df$dropoff_latitude[i] <- df$pickup_latitude[i+1]
    }
  }
  return(df)
}

# 새롭게 설정된 경로별로 거리 계산 (haversine method 활용)
add_distance<-function(df){
  df$trip_distance <- geodist::geodist_vec(
    x1 = df$pickup_longitude, y1 = df$dropoff_latitude,
    x2 = df$dropoff_longitude, y2 = df$dropoff_latitude, 
    paired = TRUE, measure = "haversine"
  )
  # m 단위로 계산되기에 mile 단위로 변환
  df$trip_distance <- df$trip_distance * 0.000621
  return(df)
}

path.df<-change_dropoff(path.df)
path.df<-add_distance(path.df) ; path.df


### 회귀식 활용해서 요금 계산 (택시 기준)
beta.hat = reg.summary1$stat$beta.hat ; beta.hat
predict_fare = function(df){
  df$fare_amount<-beta.hat[1,1]+beta.hat[2,1]*df$trip_distance+
    beta.hat[3,1]*df$pickup_longitude+beta.hat[4,1]*df$pickup_latitude+
    beta.hat[5,1]*df$dropoff_longitude+beta.hat[6,1]*df$dropoff_latitude
  return(df)
}

predict_fare(path.df)

apply(predict_fare(path.df), 2, sum)
apply(predict_fare(path.df), 2, mean)

# 버스 탑승자들 평균 3정거장 이용한다고 가정-> mean(predict_fare(path.df)$fare_amount) * 3
# 심야 버스 평균 8-10명 정도 탑승한다고 생각
# => 심야 버스 요금 범위를 산정
sort(c(mean(predict_fare(path.df)$fare_amount) * 3 * (mean(taxi_night$passenger_count) / 8),
       mean(predict_fare(path.df)$fare_amount) * 3 * (mean(taxi_night$passenger_count) / 10)))