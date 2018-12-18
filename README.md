# ES, Redis, Cerebro, Prizm

1. Run `docker-compose up -d`

2. ES from host: http://localhost:9200

3. Cerebro from host: http://locahost:9000

   Access ES in Cerebro: http://es:9200  

4. Redis from host: redis-cli

5. Prizm from host: http://localhost:18681/PCCIS/V1/Static/Viewer/Test

--- 
### Windows troubleshooting tips
If you get volume mapping errors, make sure COMPOSE_CONVERT_WINDOWS_PATHS is set in your environment variables

```SET COMPOSE_CONVERT_WINDOWS_PATHS=1```

If you're still having issues, make sure your shared drives are configured properly

https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes