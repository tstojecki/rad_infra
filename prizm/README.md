<img height="128px" width="128px" align="right" />

# PrizmDocker

> Everything you need to run PrizmDoc in a Docker container.

<table>
	<thead>
		<tr>
			<th align="center"><strong>Contents</strong></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<ol>
					<li><a href="#getting-started">Getting Started</a></li>
					<ol>
						<li><a href="#prerequisites">Prerequisites</a></li>
						<li><a href="#installation">Installation</a></li>
						<li><a href="#usage">Usage</a></li>
					</ol>
					<li><a href="#optional-configuration">Optional Configuration</a></li>
					<ol>
						<li><a href="#disable-ephemerality">Disable Ephemerality</a></li>
						<li><a href="#auto-license">Auto-License</a></li>
					</ol>
					<li><a href="#pdutil">PDUtil</a></li>
					<ol>
						<li><a href="#install">Install</a></li>
						<li><a href="#remove">Remove</a></li>
						<li><a href="#download">Download</a></li>
						<li><a href="#license">License</a></li>
						<li><a href="#restart">Restart</a></li>
					</ol>
					<li><a href="#acknowledgements">Acknowledgements</a></li>
					<li><a href="#license">License</a></li>
				</ol>
			</td>
		</tr>
	</tbody>
</table>

### Getting Started

#### Prerequisites

- [Docker](https://store.docker.com/)

#### Installation

```bash
git clone https://github.com/brianjenkins94/PrizmDocker.git
```

#### Usage

1. Build a PrizmDocker Instance

```bash
cd PrizmDocker/ubuntu-14.04/
sudo ./build.sh
```

2. Run a PrizmDocker Instance

```bash
sudo ./run.sh
```

### Optional Configuration

#### Disable Ephemerality

PrizmDocker is configured to be ephemeral by default -- that is, the run script will destroy the container on bash exit. To disable this feature remove `--rm` from `run.sh`.

#### Auto-License

PrizmDocker licenses each instance at runtime. This can be annoying. To auto-license replace:

```bash
curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | bash -s license
```

in `run.sh` with:

```bash
/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "PrizmDoc" <YOUR_OEM_LICENSE_KEY>
```

*Note: This will only work for OEM licenses.*

### PDUtil

```
PrizmDoc Utility v1.0

Usage:
    ./pdutil.sh (install|remove|download|license|restart) [options]

Reduces common PrizmDoc maintenance tasks down to proper Linux one-liners.

Commands:
    install - Installs PrizmDoc
    remove - Removes prior PrizmDoc installation
    download - Downloads PrizmDoc
    license - Licenses PrizmDoc
    restart - Restarts PrizmDoc services

Options:
    --headless        Install Xvfb for headless environments
    --multilingual    Install Asian fonts
    --exclude-pas     Exclude PAS
    --exclude-server  Exclude PrizmDoc Server
```

#### Install

    curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | sudo bash -s install

#### Remove

    curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | sudo bash -s remove

#### Download

    curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | sudo bash -s download

#### License

    curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | sudo bash -s license

#### Restart

    curl -s https://raw.githubusercontent.com/brianjenkins94/PrizmDocker/master/pdutil.sh | sudo bash -s restart

### Acknowledgements

### License

`PrizmDocker` is licensed under the [MIT License](https://github.com/brianjenkins94/PrizmDocker/blob/master/LICENSE).
