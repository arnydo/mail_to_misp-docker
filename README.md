# mail_to_misp-docker
Docker container for mail_to_misp MISP module

# Running container
1. Clone this repo to your machine
2. Edit mail_to_misp_config.py based on your environment. (MISP API/KEY)
3. Build the image
```
docker build . -t "M2M"
```
4. Run container with port 25 open
```
docker run --rm -p 25:25 mtm
```
