## 📌 Summary
[NYC Yellow Taxi Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) 데이터의 EDA를 통해, pickup_datetime와 dropoff_datetime 변수를 살펴본 결과, 사람들이 활동하는 낮 시간이 아닌, 밤에도 택시의 수요가 많다는 것을 볼 수 있었다. 그러나 낮에는 대중 교통의 선택지가 다양하지만, 밤에는 다소 한정적이었다. 심야 버스 운영을 통해 승객들에게 밤에도 안전한 교통수단을 제공하고자 하며, 버스 사업을 진행 및 확대하기 위해 뉴욕 택시 데이터를 활용하여 심야 버스의 정류장 위치 선정과 요금을 예측하는 분석을 진행하기로 한다.

<br>

본 프로젝트의 목적은
1)	‘심야 버스 사업’을 위해 데이터를 정제하고 
2)	‘심야 버스 노선 선정’ 을 위해, K-Means Clustering 을 통해 버스 정류장을 찾고
3)	‘심야 버스 요금 예측’ 을 위해, Linear Regression 을 통해 요금을 책정한다.

<br>

‘심야’ 버스 정류장 위치 선정을 위해, 기준을 세워 데이터 정제 과정을 거친다.
1)	이론적으로 존재하면 안 되는 데이터를 제거하고
2)	데이터 상 말이 안되는 데이터를 제거한 후
3)	데이터 주제에 맞게, 오후 11시부터 오전 7시까지의 데이터를 가져온다.

<br>

다음은 심야 버스 노선을 선정하기 위해 **K-Means Clusering** 을 사용한다.
1)	K 값을 구하기 위해 **Elbow Method** 를 사용하고
2)	K-Means 클러스터링 과정을 거쳐, 각 구역의 중심점을 뉴욕(맨해튼) 전체를 이어주는 노선의 버스 정류장으로 정한다.

<br>

또한 요금 예측을 위해 **Linear Regression** 을 사용한다.
1)	K-Means 를 통해 선정된 버스 정류장 좌표를 이어주는 노선을 만들고
2)	회귀분석을 통해 노선 구간별 심야 택시 요금을 예측하고
3)	택시 요금을 토대로 심야 버스 요금을 예측한다.

---

## 🐘 Framework
- HDFS
- MapReduce

---

## 🚕 DataSet
### [NYC Yellow Taxi Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

| Field Name | Description |
| --- | --- |
| VendorID | A code indicating the TPEP provider that provided the record. |
|  | 1= Creative Mobile Technologies, LLC |
|  | 2= VeriFone Inc. |
| pickup datetime | The date and time when the meter was engaged. |
| dropoff datetime | The date and time when the meter was disengaged. |
| Passenger count | The number of passengers in the vehicle. This is a driver-entered value. |
| Trip distance | The elapsed trip distance in miles reported by the taximeter. |
| Pickup longitude | Longitude where the meter was engaged. |
| Pickup latitude | Latitude where the meter was engaged. |
| RateCodeID | The final rate code in effect at the end of the trip. |
|  | 1= Standard rate |
|  | 2=JFK |
|  | 3=Newark |
|  | 4=Nassau or Westchester |
|  | 5=Negotiated fare |
|  | 6=Group ride |
| Store and fwd flag | This flag indicates whether the trip record was held in vehicle memory before sending to the vendor, aka “store and forward,” because the vehicle did not have a connection to the server. |
|  | Y= store and forward trip |
|  | N= not a store and forward trip |
| Dropoff longitude | Longitude where the meter was disengaged. |
| Dropoff latitude | Latitude where the meter was disengaged. |
| Payment type | A numeric code signifying how the passenger paid for the trip. |
|  | 1= Credit card |
|  | 2= Cash |
|  | 3= No charge |
|  | 4= Dispute |
|  | 5= Unknown |
|  | 6= Voided trip |
| Fare amount | The time-and-distance fare calculated by the meter. |
| Extra | Miscellaneous extras and surcharges. Currently, this only includes the $0.50 and $1 rush hour and overnight charges. |
| MTA tax | $0.50 MTA tax that is automatically triggered based on the metered rate in use. |
| Improvement surcharge | $0.30 improvement surcharge assessed trips at the flag drop. The improvement surcharge began being levied in 2015. |
| Tip amount | Tip amount – This field is automatically populated for credit card tips. Cash tips are not included. |
| Tolls amount | Total amount of all tolls paid in trip. |
| Total amount | The total amount charged to passengers. Does not include cash tips. |
