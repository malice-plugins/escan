# malice-escan

[![Circle CI](https://circleci.com/gh/malice-plugins/escan.png?style=shield)](https://circleci.com/gh/malice-plugins/escan)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Docker Stars](https://img.shields.io/docker/stars/malice/escan.svg)](https://hub.docker.com/r/malice/escan/)
[![Docker Pulls](https://img.shields.io/docker/pulls/malice/escan.svg)](https://hub.docker.com/r/malice/escan/)
[![Docker Image](https://img.shields.io/badge/docker%20image-1.15GB-blue.svg)](https://hub.docker.com/r/malice/escan/)

> Malice [eScan](https://escanav.com/en/linux-antivirus/antivirus-for-linux-file-servers.asp) AntiVirus Plugin

---

### Dependencies

- [ubuntu:xenial (_118 MB_\)](https://hub.docker.com/_/ubuntu/)

## Installation

1. Install [Docker](https://www.docker.io/).
2. Download [trusted build](https://hub.docker.com/r/malice/escan/) from public [DockerHub](https://hub.docker.com): `docker pull malice/escan`

## Usage

```
docker run --rm malice/escan EICAR
```

### Or link your own malware folder:

```bash
$ docker run --rm -v /path/to/malware:/malware:ro malice/escan FILE

Usage: escan [OPTIONS] COMMAND [arg...]

Malice eScan AntiVirus Plugin

Version: v0.1.0, BuildTime: 20180903

Author:
  blacktop - <https://github.com/blacktop>

Options:
  --verbose, -V          verbose output
  --table, -t            output as Markdown table
  --callback, -c         POST results to Malice webhook [$MALICE_ENDPOINT]
  --proxy, -x            proxy settings for Malice webhook endpoint [$MALICE_PROXY]
  --elasticsearch value  elasticsearch url for Malice to store results [$MALICE_ELASTICSEARCH_URL]
  --timeout value        malice plugin timeout (in seconds) (default: 60) [$MALICE_TIMEOUT]
  --help, -h             show help
  --version, -v          print the version

Commands:
  update  Update virus definitions
  web     Create a EScan scan web service
  help    Shows a list of commands or help for one command

Run 'escan COMMAND --help' for more information on a command.
```

This will output to stdout and POST to malice results API webhook endpoint.

## Sample Output

### [JSON](https://github.com/malice-plugins/escan/blob/master/docs/results.json)

```json
{
  "escan": {
    "infected": true,
    "result": "EICAR-Test-File (not a virus)(DB)",
    "engine": "7.0-20",
    "updated": "20170708"
  }
}
```

### [Markdown](https://github.com/malice-plugins/escan/blob/master/docs/SAMPLE.md)

---

#### eScan

| Infected |              Result               | Engine | Updated  |
| :------: | :-------------------------------: | :----: | :------: |
|   true   | EICAR-Test-File (not a virus)(DB) | 7.0-20 | 20170708 |

---

## Documentation

- [To write results to ElasticSearch](https://github.com/malice-plugins/escan/blob/master/docs/elasticsearch.md)
- [To create a eScan scan micro-service](https://github.com/malice-plugins/escan/blob/master/docs/web.md)
- [To post results to a webhook](https://github.com/malice-plugins/escan/blob/master/docs/callback.md)
- [To update the AV definitions](https://github.com/malice-plugins/escan/blob/master/docs/update.md)

## TODO

- [ ] add ability to enable `--pack/--heuristic/--max-size` scanning options

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/malice-plugins/escan/issues/new).

## CHANGELOG

See [`CHANGELOG.md`](https://github.com/malice-plugins/escan/blob/master/CHANGELOG.md)

## Contributing

[See all contributors on GitHub](https://github.com/malice-plugins/escan/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/malice-plugins/escan/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

## License

MIT Copyright (c) 2016 **blacktop**
