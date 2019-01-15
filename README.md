# ES, Redis, Cerebro, Prizm

## Pre-Compose Step

Create a file in the Prizm directory to contain your Accusoft Prizm license key. This license key is private and is therefore not part of the source control repository.

- for version 11, name the file: license_v11.txt
- for version 12, name the file: license_v12.txt
- for version 13, name the file: license_v13.txt

## Compose Containers

1. Run `docker-compose up -d`

## Access the Hosts

1. ES from host: http://localhost:9200

2. Cerebro from host: http://locahost:9000

   Access ES in Cerebro: http://es:9200

3. Redis from host: redis-cli

4. Prizm from host: http://localhost:18681/PCCIS/V1/Static/Viewer/Test

---

### Windows troubleshooting tips

If you get volume mapping errors, make sure COMPOSE_CONVERT_WINDOWS_PATHS is set in your environment variables

`SET COMPOSE_CONVERT_WINDOWS_PATHS=1`

If you're still having issues, make sure your shared drives are configured properly

https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes
