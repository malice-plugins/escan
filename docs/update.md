# To update the AV run the following:

```bash
$ docker run --name=escan malice/escan update
```

## Then to use the updated escan container:

```bash
$ docker commit escan malice/escan:updated
$ docker rm escan # clean up updated container
$ docker run --rm malice/escan:updated EICAR
```
