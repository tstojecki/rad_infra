#!/bin/bash

# ./pdutil.sh install
function install() {
	# Enter temporary directory
	cd "$(mktemp -d)" || (echo "Directory change failed. Terminating." && exit 1)

	# Download
	download

	echo "Extracting archives..."
	if [[ ! "$(find . -name "*.tar.gz" -exec tar -xzvf {} \;)" ]]; then
		echo "Extraction failed. Terminating." && exit 1
	fi

	# Install
	if [[ $DEB_BASED == true ]]; then
		install_deb
	elif [[ $RPM_BASED == true ]]; then
		install_rpm
	fi

	echo "Successfully installed."
	if [[ ! "$EXCLUDE_PAS" == true ]]; then
		# License
		#license

		# WORKAROUND: Installation-critical logic is invoked by explicitly calling `pccis.sh start`
		/usr/share/prizm/scripts/pccis.sh start

		# Restart
		restart
	fi
}

function install_deb() {
	# Update apt for fresh DEB installations
	apt-get update &> /dev/null

	echo "Resolving dependencies..."
	if [[ ! "$EXCLUDE_SERVER" == true ]]; then
		dpkg --recursive --install ./*server*/
	fi

	if [[ ! "$EXCLUDE_PAS" == true ]]; then
		dpkg --recursive --install ./*client*/
	fi

	echo "Installing PrizmDoc..."
	if [[ ! "$(apt-get install -fy)" ]]; then
		echo "Installation failed. Terminating." && exit 1
	fi

	if [[ ! "$EXCLUDE_SERVER" == true ]]; then
		if [[ "$MULTILINGUAL" == true ]]; then
			echo "Installing Asian font support..."
			apt-get install -y language-pack-ja japan* language-pack-zh* chinese* language-pack-ko korean* fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core
		fi

		echo "Registering PCCIS with init.d..."
		ln -s /usr/share/prizm/scripts/pccis.sh /etc/init.d/pccis
		update-rc.d pccis defaults
	fi

	echo "Successfully installed."
	if [[ ! "$EXCLUDE_PAS" == true ]]; then

		echo "Registering PAS with init.d..."
		ln -s /usr/share/prizm/pas/pm2/pas.sh /etc/init.d/pas
		update-rc.d pas defaults

		chmod 755 /usr/share/prizm/Samples/Documents/
	fi
}

function install_rpm() {
	# Update yum for fresh RPM installations
	yum update -y &> /dev/null

	echo "Installing PrizmDoc..."
	if [[ ! "$EXCLUDE_SERVER" == true ]]; then
		yum install -y --nogpgcheck ./*server*/*.rpm
	fi

	if [[ ! "$EXCLUDE_PAS" == true ]]; then
		yum install -y --nogpgcheck ./*client*/*.rpm
	fi

	if [[ ! "$EXCLUDE_SERVER" == true ]]; then
		if [[ "$MULTILINGUAL" == true ]]; then
			echo "Installing Asian font support..."
			yum groupinstall Fonts
		fi

		echo "Registering PCCIS with init.d..."
		ln -s /usr/share/prizm/scripts/pccis.sh /etc/init.d/pccis
		chkconfig --add pccis
	fi

	echo "Successfully installed."
	if [[ ! "$EXCLUDE_PAS" == true ]]; then

		echo "Registering PAS with init.d..."
		ln -s /usr/share/prizm/pas/pm2/pas.sh /etc/init.d/pas
		chkconfig --add pas

		chmod 755 /usr/share/prizm/Samples/Documents/
	fi
}

# ./pdutil.sh remove
function remove() {
	if [[ -d "/usr/share/prizm" ]]; then
		# Prompt for confirmation
		read -rp "Prior installation detected. Remove? [y/N] " RESPONSE < /dev/tty
		if [[ ! "$RESPONSE"  =~ ^([yY][eE][sS]|[yY])$ ]]; then
			echo "Terminating." && exit 1
		fi

		echo "Stopping services..."
		/usr/share/prizm/scripts/pccis.sh stop &> /dev/null

		echo "Stopping PAS..."
		/usr/share/prizm/pas/pm2/pas.sh stop &> /dev/null

		echo "Stopping samples..."
		/usr/share/prizm/scripts/demos.sh stop &> /dev/null

		echo "Removing dependencies..."
		if [[ $DEB_BASED == true ]]; then
			apt-get remove -fy prizm-* &> /dev/null
		elif [[ $RPM_BASED == true ]]; then
			yum remove -y prizm-* &> /dev/null
		fi

		echo "Removing remaining files..."
		rm -rf /usr/share/prizm

		echo "Successfully removed."
	else
		echo "No prior installation detected. Terminating."
	fi
}

# ./pdutil.sh download
function download() {
	# Install curl for fresh Debian installations
	if [[ $DEB_BASED == true ]]; then
		apt-get install -y curl &> /dev/null
	fi

	if [[ $VERSION ]]; then
		if [[ $DEB_BASED == true ]]; then
			SERVER_LATEST="http://products.accusoft.com/PrizmDoc/$VERSION/prizmdoc_server_$VERSION.amd64.deb.tar.gz"
			CLIENT_LATEST="http://products.accusoft.com/PrizmDoc/$VERSION/prizmdoc_client_$VERSION.amd64.deb.tar.gz"
		elif [[ $RPM_BASED == true ]]; then
			SERVER_LATEST="http://products.accusoft.com/PrizmDoc/$VERSION/prizmdoc_server_$VERSION.RHEL7.tar.gz"
			CLIENT_LATEST="http://products.accusoft.com/PrizmDoc/$VERSION/prizmdoc_client_$VERSION.x86_64.rpm.tar.gz"
		fi
	else
		if [[ $DEB_BASED == true ]]; then
			SERVER_LATEST="http://products.accusoft.com/PrizmDoc/latest/prizmdoc_server_amd64.deb.tar.gz"
			CLIENT_LATEST="http://products.accusoft.com/PrizmDoc/latest/prizmdoc_client_amd64.deb.tar.gz"
		elif [[ $RPM_BASED == true ]]; then
			SERVER_LATEST="http://products.accusoft.com/PrizmDoc/latest/prizmdoc_server_RHEL7.tar.gz"
			CLIENT_LATEST="http://products.accusoft.com/PrizmDoc/latest/prizmdoc_client_x86_64.rpm.tar.gz"
		fi
	fi

	if [[ ! "$EXCLUDE_SERVER" == true ]]; then
		echo "Downloading Server..."
		curl --location --remote-name "$SERVER_LATEST"
	fi

	if [[ ! "$EXCLUDE_PAS" == true ]]; then
		echo "Downloading Client..."
		curl --location --remote-name "$CLIENT_LATEST"
	fi
}

# ./pdutil.sh license
function license() {
	if [[ -d "/usr/share/prizm" ]]; then
		while true; do
			echo "  1.) I would like to license this system with an OEM LICENSE."
			echo "  2.) I would like to license this system with a NODE-LOCKED LICENSE."
			echo "  3.) I have a license but I do not know what type."
			echo "  4.) I do not have a license but I would like an EVALUATION."
			echo "  5.) I do not want to license my product at this time."
			echo ""

			read -rp "Select an option (1-5) [5]: " RESPONSE < /dev/tty
			case "$RESPONSE" in
			"1")
				read -rp "Solution name: " SOLUTION_NAME < /dev/tty
				read -rp "OEM key: " OEM_KEY < /dev/tty

				echo "Licensing..."

				# WORKAROUND: The licenser is falsely reporting errors.
				if [[ "$(/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write "$SOLUTION_NAME" $OEM_KEY)" ]]; then
					echo "/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy write \"$SOLUTION_NAME\" $OEM_KEY"
					echo "Licensing failed."
				else
					echo "Licensing successful."
					restart
					break
				fi
				;;
			"2")
				read -rp "Solution name: " SOLUTION_NAME < /dev/tty
				read -rp "Configuration file path (relative to $PWD): " CONFIG_FILE < /dev/tty
				read -rp "Access key: " ACCESS_KEY < /dev/tty

				echo "Licensing..."

				# WORKAROUND: The licenser is falsely reporting errors.
				if [[ "$(/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy get "$CONFIG_FILE" "$SOLUTION_NAME" $ACCESS_KEY)" ]]; then
					echo "/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar deploy get \"$CONFIG_FILE\" \"$SOLUTION_NAME\" $ACCESS_KEY"
					echo "Licensing failed."
				else
					echo "Licensing successful."
					restart
					break
				fi
				;;
			"3")
				clear
				echo ""
				echo "  You can find your license type by selecting the \"Licenses\" tab on the"
				echo "Accusoft Portal: https://my.accusoft.com/"
				echo ""
				echo "  For an OEM LICENSE, you will be provided with a SOLUTION NAME and an OEM KEY."
				echo ""
				echo "  For a NODE-LOCKED LICENSE, you will be provided with a SOLUTION NAME, a"
				echo "CONFIGUATION FILE, and an ACCESS KEY."
				echo ""
				echo "  If you have not spoken with a member of the Accusoft Sales department, it is"
				echo "likely that you are interested in an EVALUATION."
				echo ""
				echo "  If you require additional assistance, please contact sales@accusoft.com."
				echo ""
				read -rp "Press enter to continue..."
				echo ""
				;;
			"4")
				read -rp "Email address: " EMAIL < /dev/tty

				if [[ ! "$(/usr/share/prizm/java/jre8/bin/java -jar /usr/share/prizm/plu/plu.jar eval get "$EMAIL")" ]]; then
					echo "Licensing failed."
				else
					echo "Licensing successful."
					restart
					break
				fi
				;;
			"5")
				echo "Terminating."
				break
				;;
			*)
				read -rp "Token \`$RESPONSE\` unrecognized. Continue? [y/N] " RESPONSE < /dev/tty
				if [[ ! "$RESPONSE"  =~ ^([yY][eE][sS]|[yY])$ ]]; then
					echo "Terminating."
					break
				fi
				echo ""
			esac
		done

	else
		echo "PrizmDoc is not installed. Terminating." && exit 1
	fi
}

# ./pdutil.sh restart
function restart() {
	if [[ -f "/usr/share/prizm/scripts/pccis.sh" ]]; then
		echo "Restarting PCCIS..."
		/usr/share/prizm/scripts/pccis.sh restart
	fi

	if [[ -f "/usr/share/prizm/pas/pm2/pas.sh" ]]; then
		echo "Restarting PAS..."
		/usr/share/prizm/pas/pm2/pas.sh restart
	fi

	if [[ -f "/usr/share/prizm/scripts/demos.sh" ]]; then
		echo "Restarting samples..."
		/usr/share/prizm/scripts/demos.sh restart
	fi
}

# ./pdutil.sh *
function main() {
	echo ""
	echo "               \\\\\\\\\\\\\\\\\\"
	echo "                \\\\\\\\\\\\\\\\\\\\"
	echo "                 \\\\\\\\\\\\\\\\\\\\\\"
	echo "                   \\\\\\\\\\\\\\\\\\\\"
	echo "               //    \\\\\\\\\\\\\\\\\\\\"
	echo "             //////   \\\\\\\\\\\\\\\\\\\\\\      PrizmDoc Utility v1.0"
	echo "          ////////      \\\\\\\\\\\\\\\\\\\\\\"
	echo "        ///////           \\\\\\\\\\\\\\\\\\\\"
	echo "      //////\\\\\\\\\\\\\\\\\\\\\\\\   \\\\\\\\\\\\\\\\"
	echo "    ////  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\      \\\\\\\\\\"
	echo "  ///              \\\\\\\\\\\\\\\\\\\\\\\\\\\\"
	echo ""

	DEB_BASED=false
	RPM_BASED=false
	NIX_BASED=false

	MULTILINGUAL=false

	EXCLUDE_PAS=false
	EXCLUDE_SERVER=false

	# Check privileges
	if [[ "$(/usr/bin/id -u)" != 0 ]]; then
		echo "Insufficient privileges. Terminating." && exit 1
	fi

	# Check architecture
	if [[ "$(uname -m)" != "x86_64" ]]; then
		echo "Incompatible architecture. Terminating." && exit 1
	fi

	# Save current working directory
	CWD=$(pwd)

	# Detect operating system
	if [[ -f "/usr/bin/apt-get" ]]; then
		DEB_BASED=true
		echo "Debian-based operating system detected."
	elif [[ -f "/usr/bin/yum" ]]; then
		RPM_BASED=true
		# echo "RPM-based operating system detected."
	else
		NIX_BASED=true
		echo "Generic *nix-based operating system detected."
		echo "Not yet implemented. Terminating." && exit 1
	fi

	case $1 in
	"install")
		for TOKEN in "${@:2}"; do
			case "$TOKEN" in
			"--multilingual")
				MULTILINGUAL=true
				;;
			"--exclude-pas")
				EXCLUDE_PAS=true
				;;
			"--exclude-server")
				EXCLUDE_SERVER=true
				;;
			"--version="*)
				VERSION=${TOKEN#*=}
				;;
			"--headless")
				;;
			*)
				echo "token is: " $TOKEN
				read -rp "Token \`$TOKEN\` unrecognized. Continue? [y/N] " RESPONSE < /dev/tty
				if [[ ! "$RESPONSE"  =~ ^([yY][eE][sS]|[yY])$ ]]; then
					echo "Terminating." && exit 1
				fi
			esac
		done

		install
		;;
	"remove")
		remove
		;;
	"download")
		for TOKEN in "${@:2}"; do
			case "$TOKEN" in
			"--exclude-pas")
				EXCLUDE_PAS=true
				;;
			"--exclude-server")
				EXCLUDE_SERVER=true
				;;
			*)
				read -rp "Token \`$TOKEN\` unrecognized. Continue? [y/N] " RESPONSE < /dev/tty
				if [[ ! "$RESPONSE"  =~ ^([yY][eE][sS]|[yY])$ ]]; then
					echo "Terminating." && exit 1
				fi
			esac
		done

		download
		;;
	"license")
		license
		;;
	"restart")
		restart
		;;
	*)
		echo "Usage:"
		echo "  ./pdutil.sh (install|remove|download|license|restart) [options]"
		echo ""
		echo "Reduces common PrizmDoc maintenance tasks down to proper Linux one-liners."
		echo ""
		echo "Commands:"
		echo "  install - Installs PrizmDoc"
		echo "  remove - Removes prior PrizmDoc installation"
		echo "  download - Downloads PrizmDoc"
		echo "  license - Licenses PrizmDoc"
		echo "  restart - Restarts PrizmDoc services"
		echo ""
		echo "Options:"
		echo "  --multilingual    Install Asian fonts"
		echo "  --exclude-pas     Exclude PAS"
		echo "  --exclude-server  Exclude PrizmDoc Server"
		;;
	esac

	# Restore current working directory
	cd "$CWD" || (echo "Directory change failed. Terminating." && exit 1)

	exit 0
}

main "$@"
