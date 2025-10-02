#/bin/bash
#============================
# Run script in the directory you want it installed in.
#============================

function InstallPackages()
{
	sudo apt update
	# array of packages.
	packages=(
	"php" # core php runtime
	"php-cli" # allows running php scripts from terminal. /usr/bin/php (not apache)
	"php-xml" # package provides a DOM, SimpleXML, WDDX, XML, and XSL module for PHP.
	"php-mbstring" # for any potential character encoding conversion. (UTF-8, UCS-2, etc.)
	"php-curl"
	"php-zip"
	"firefox-esr" # firefox browser
	"curl"
	"wget"
	"zip"
	"unzip"
	)
	echo "installing php core"
	for package in "${packages[@]}"; do
		echo ">>> installing $package <<<"
		sudo apt install ${package} -y
	done
	echo "firefox version"
	firefox --version
}

function DownloadGeckoDriverSource()
{
	local version=$1
	# Download geckodriver from mozillas official github
	echo "Downloading GeckoDriver ${version}"
	#wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz
	local url="https://github.com/mozilla/geckodriver/releases/download/${version}/geckodriver-${version}-linux64.tar.gz"
	local file="geckodriver-${version}-linux64.tar.gz"
	wget -O $file $url
}

function InstallGeckoDriverFromSource()
{
	local version=$1
	local tarFile="geckodriver-${version}-linux64.tar.gz"
	if [ ! -f "${tarFile}" ]; then
		echo "Could not find geckdriver tarball: ${tarFile}"
		exit 1
	fi
	echo "Installing GeckoDriver"
	# extract the downloaded geckodriver archive
	tar -xvzf $tarFile
	# move binary to a system path.
	sudo mv geckodriver /usr/local/bin/
	# give executable permission.
	chmod +x /usr/local/bin/geckodriver
	# check if geckodriver installed correctly.
	echo "GeckoDriver install path:"
	which geckodriver
	echo "Installed GeckoDriver version:"
	geckodriver --version
}

function PathGeckoDriver()
{
	local path="$(which geckodriver)"
	echo "${path}"
	# if it returns no path, you may manually add it to path
	# export PATH=$PATH:/path/to/geckodriver
	# To make it permanent, add the line above to ~/.bashrc or ~/.profile.
	echo "export PATH=$PATH:/path/to/geckodriver" >> ~/.bashrc
	source ~/.bashrc
}

function UninstallGeckoDriver()
{
	echo "Uninstalling GeckoDriver"
	local path="$(which geckodriver)"
	sudo rm "${path}"
	#sudo rm /usr/local/bin/geckodriver
}

function DownloadComposer()
{
	local composerFile=$1
	local composerUrl="https://getcomposer.org/installer"
	echo "downloading composer."
	# download composer
	# -s: --silent
	# -S: --show-error
	# -o: --output <file>
	curl -sS ${composerUrl} -o ${composerFile}
}

function InstallComposer()
{
	local composerFile=$1
	echo "Installing composer"
	# install composer (php package manager)
	#--install: install directory.
	#--filename: specify filename, default 'composer.phar'
	sudo php ${composerFile} --install-dir=/usr/local/bin --filename=composer
	# check composer version to verify it installed.
	composer -V
}

function UninstallComposer()
{
	echo "Uninstalling composer"
	sudo rm /usr/local/bin/composer
}

function InstallComposerLibraries()
{
	echo "Installing php-webdriver"
	composer require php-webdriver/webdriver
	echo "Installing symfony panther"
	composer require --dev symfony/panther
	echo "Installing DOM crawler"
	composer require symfony/dom-crawler
}

function Main()
{
	echo "start"
	# ====================
	InstallPackages
	# ====================
	local geckoDriverVersion="v0.34.0"
	DownloadGeckoDriverSource $geckoDriverVersion
	InstallGeckoDriverFromSource $geckoDriverVersion
	# ====================
	local composerFile="composer-setup.php"
	DownloadComposer $composerFile
	InstallComposer $composerFile
	# ====================
	InstallComposerLibraries
	# ====================
	#UninstallGeckoDriver
	#UninstallComposer
	# ====================
	echo "done"
	return 0
}

Main
