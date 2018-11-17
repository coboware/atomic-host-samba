# Atomic Host Samba
This container adds samba sharing on atomic host, which enables remote development.

Special for MACos the image contains avahi and .DS_Store ._* files are deleted.

## Settings 
For simplicity the samba credentials are share/share.

### share in homedir
Make sure to set the right permissions on the share directory ont the host workstation. 

### Network host
```shell
docker run -d  --restart=always --network host -v /path/to/share/:/share --name samba coboware/atomic-host-samba
```

### With port mapping
Supplying port mappings only instead of --network=host might be subject to the limitations outlined above:
```shell
docker run -d --restart=always -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445  -v /path/to/share/:/share --name samba coboware/atomic-host-samba
```

### Docker Compose
```shell
docker-compose -p samba -f docker-compose.yml
```

