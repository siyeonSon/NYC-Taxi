## ๐ Summary
[NYC Yellow Taxi Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) ๋ฐ์ดํฐ์ EDA๋ฅผ ํตํด, pickup_datetime์ dropoff_datetime ๋ณ์๋ฅผ ์ดํด๋ณธ ๊ฒฐ๊ณผ, ์ฌ๋๋ค์ด ํ๋ํ๋ ๋ฎ ์๊ฐ์ด ์๋, ๋ฐค์๋ ํ์์ ์์๊ฐ ๋ง๋ค๋ ๊ฒ์ ๋ณผ ์ ์์๋ค. ๊ทธ๋ฌ๋ ๋ฎ์๋ ๋์ค ๊ตํต์ ์ ํ์ง๊ฐ ๋ค์ํ์ง๋ง, ๋ฐค์๋ ๋ค์ ํ์ ์ ์ด์๋ค. ์ฌ์ผ ๋ฒ์ค ์ด์์ ํตํด ์น๊ฐ๋ค์๊ฒ ๋ฐค์๋ ์์ ํ ๊ตํต์๋จ์ ์ ๊ณตํ๊ณ ์ ํ๋ฉฐ, ๋ฒ์ค ์ฌ์์ ์งํ ๋ฐ ํ๋ํ๊ธฐ ์ํด ๋ด์ ํ์ ๋ฐ์ดํฐ๋ฅผ ํ์ฉํ์ฌ ์ฌ์ผ ๋ฒ์ค์ ์ ๋ฅ์ฅ ์์น ์ ์ ๊ณผ ์๊ธ์ ์์ธกํ๋ ๋ถ์์ ์งํํ๊ธฐ๋ก ํ๋ค.

<br>

๋ณธ ํ๋ก์ ํธ์ ๋ชฉ์ ์
1)	โ์ฌ์ผ ๋ฒ์ค ์ฌ์โ์ ์ํด ๋ฐ์ดํฐ๋ฅผ ์ ์ ํ๊ณ  
2)	โ์ฌ์ผ ๋ฒ์ค ๋ธ์  ์ ์ โ ์ ์ํด, K-Means Clustering ์ ํตํด ๋ฒ์ค ์ ๋ฅ์ฅ์ ์ฐพ๊ณ 
3)	โ์ฌ์ผ ๋ฒ์ค ์๊ธ ์์ธกโ ์ ์ํด, Linear Regression ์ ํตํด ์๊ธ์ ์ฑ์ ํ๋ค.

<br>

โ์ฌ์ผโ ๋ฒ์ค ์ ๋ฅ์ฅ ์์น ์ ์ ์ ์ํด, ๊ธฐ์ค์ ์ธ์ ๋ฐ์ดํฐ ์ ์  ๊ณผ์ ์ ๊ฑฐ์น๋ค.
1)	์ด๋ก ์ ์ผ๋ก ์กด์ฌํ๋ฉด ์ ๋๋ ๋ฐ์ดํฐ๋ฅผ ์ ๊ฑฐํ๊ณ 
2)	๋ฐ์ดํฐ ์ ๋ง์ด ์๋๋ ๋ฐ์ดํฐ๋ฅผ ์ ๊ฑฐํ ํ
3)	๋ฐ์ดํฐ ์ฃผ์ ์ ๋ง๊ฒ, ์คํ 11์๋ถํฐ ์ค์  7์๊น์ง์ ๋ฐ์ดํฐ๋ฅผ ๊ฐ์ ธ์จ๋ค.

<br>

๋ค์์ ์ฌ์ผ ๋ฒ์ค ๋ธ์ ์ ์ ์ ํ๊ธฐ ์ํด **K-Means Clusering** ์ ์ฌ์ฉํ๋ค.
1)	K ๊ฐ์ ๊ตฌํ๊ธฐ ์ํด **Elbow Method** ๋ฅผ ์ฌ์ฉํ๊ณ 
2)	K-Means ํด๋ฌ์คํฐ๋ง ๊ณผ์ ์ ๊ฑฐ์ณ, ๊ฐ ๊ตฌ์ญ์ ์ค์ฌ์ ์ ๋ด์(๋งจํดํผ) ์ ์ฒด๋ฅผ ์ด์ด์ฃผ๋ ๋ธ์ ์ ๋ฒ์ค ์ ๋ฅ์ฅ์ผ๋ก ์ ํ๋ค.

<br>

๋ํ ์๊ธ ์์ธก์ ์ํด **Linear Regression** ์ ์ฌ์ฉํ๋ค.
1)	K-Means ๋ฅผ ํตํด ์ ์ ๋ ๋ฒ์ค ์ ๋ฅ์ฅ ์ขํ๋ฅผ ์ด์ด์ฃผ๋ ๋ธ์ ์ ๋ง๋ค๊ณ 
2)	ํ๊ท๋ถ์์ ํตํด ๋ธ์  ๊ตฌ๊ฐ๋ณ ์ฌ์ผ ํ์ ์๊ธ์ ์์ธกํ๊ณ 
3)	ํ์ ์๊ธ์ ํ ๋๋ก ์ฌ์ผ ๋ฒ์ค ์๊ธ์ ์์ธกํ๋ค.

---

## ๐ Framework
- HDFS
- MapReduce

---

## ๐ DataSet
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
| Store and fwd flag | This flag indicates whether the trip record was held in vehicle memory before sending to the vendor, aka โstore and forward,โ because the vehicle did not have a connection to the server. |
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
| Tip amount | Tip amount โ This field is automatically populated for credit card tips. Cash tips are not included. |
| Tolls amount | Total amount of all tolls paid in trip. |
| Total amount | The total amount charged to passengers. Does not include cash tips. |
