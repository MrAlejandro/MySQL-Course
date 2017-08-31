### CPU test
```
sysbench --test=cpu --cpu-max-prime=20000 run
```

### I/O test
```
sysbench --test=fileio --file-total-size=1G prepare
```
prepares files to perform the test
```
sysbench --test=fileio --file-total-size=1G --file-test-mode=rndrw --max-time=300 --max-requests=0 run
```
runs the test
```
sysbench --test=fileio --file-total-size=1G cleanup
```
performs cleanup
