```
MacBook-Pro:http_load Alex$ http_load -parallel 1 -seconds 10 urls.txt
71 fetches, 1 max parallel, 8.87061e+06 bytes, in 10.0042 seconds
124938 mean bytes/connection
7.09705 fetches/sec, 886692 bytes/sec
msecs/connect: 0.236676 mean, 0.494 max, 0.149 min
msecs/first-response: 134.961 mean, 217.971 max, 113.45 min
HTTP response codes:
  code 200 -- 71
```

## Emulates 5 concurrent users
```
MacBook-Pro:http_load Alex$ http_load -parallel 5 -seconds 10 urls.txt
139 fetches, 5 max parallel, 1.77916e+07 bytes, in 10.0004 seconds
127997 mean bytes/connection
13.8994 fetches/sec, 1.77909e+06 bytes/sec
msecs/connect: 0.242252 mean, 0.624 max, 0.114 min
msecs/first-response: 341.495 mean, 584.731 max, 159.565 min
HTTP response codes:
  code 200 -- 139
```

## 5 per second
```
MacBook-Pro:http_load Alex$ http_load -rate 5 -seconds 10 urls.txt
49 fetches, 2 max parallel, 5.92946e+06 bytes, in 10.0049 seconds
121009 mean bytes/connection
4.89758 fetches/sec, 592653 bytes/sec
msecs/connect: 0.535367 mean, 0.687 max, 0.297 min
msecs/first-response: 138.574 mean, 221.556 max, 115.739 min
HTTP response codes:
  code 200 -- 49
```

## 20 rps
```
MacBook-Pro:http_load Alex$ http_load -rate 20 -seconds 10 urls.txt
147 fetches, 53 max parallel, 1.85311e+07 bytes, in 10.0001 seconds
126062 mean bytes/connection
14.6999 fetches/sec, 1.8531e+06 bytes/sec
msecs/connect: 0.317537 mean, 0.745 max, 0.179 min
msecs/first-response: 1424.1 mean, 2669.95 max, 186.828 min
HTTP response codes:
  code 200 -- 147
```
