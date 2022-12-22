#### 분석 ####
### 1. K-Means
## 군집 개수 결정 (elbow 방법)
taxi_night_scaled = as.matrix(scale(taxi_night[, c("pickup_longitude", "pickup_latitude", "dropoff_longitude", "dropoff_latitude")]))
tot_withinss = NULL
dim(taxi)
for(i in 1:30){
  kmeans_cluster = kmeans(taxi_night_scaled, centers = i, iter.max=100)
  tot_withinss[i] = kmeans_cluster$tot.withinss
}

plot(c(1:30), tot_withinss, type="b",
     main="Optimal number of clusters",
     xlab="Number of clusters",
     ylab="Total within-cluster sum of squares")

## K-means

Dat = as.matrix( taxi_night[, c("pickup_longitude", "pickup_latitude", "dropoff_longitude", "dropoff_latitude")] )
C = NULL 
num.clusters = 15
n.iter = 10

dist.fun <- function(Center, Dat) apply(Center, 1, function(x) colSums((t(Dat) - x)^2))

mykmeans <- function( data, num.clusters, n.iter = 10 ){
  set.seed(1234)
  
  # 클러스터 초기화
  cluster <- sample(1:num.clusters, nrow(Dat), replace = TRUE); 
  
  for( i in seq_len(n.iter) ){
    # center 계산
    res <- aggregate( x = cbind(Dat), by = list(cluster), FUN = mean )
    C <- res[,-1]; C
    
    # center로부터 거리 계산
    D <- dist.fun(C, Dat); D
    cluster <- max.col(-D); table(cluster)
  }
  
  tot.withinss <- sum( (Dat - C[cluster,])^2 ) 
  tot.ss <- sum( (Dat - apply(Dat, 2, mean ) )^2 )
  btw.ss <- tot.ss - tot.withinss 
  
  res <- list( cluster = cluster, center = C, ss = list(tot.ss = tot.ss, tot.withinss = tot.withinss ), ctable = table(cluster) )
  
  return(res)
}

# K-means 수행
kmeans <- mykmeans( data = Dat, num.clusters = 16, n.iter = 10 )$center


## 지도에 그리기
register_google(key="_")
map <- ggmap(get_googlemap( "Manhatten", zoom = 12))
pickup_map <- map + geom_point(data = kmeans, 
                               aes(x = pickup_longitude, y = pickup_latitude),
                               size = 1, color = "red")
total_map <- pickup_map + geom_point(data = kmeans, 
                                     aes(x = dropoff_longitude, y = dropoff_latitude),
                                     size = 1, color = "blue")
total_map

kmeans.df <- as.data.frame(kmeans)