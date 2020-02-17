#! /bin/bash

dest=antlr
force=

# filenames for the antlr run script and the compilation script.
antlr_script=antlr4.sh
antlr_comp=cantlr4.sh

# place where the cpp runtime files will be placed.
runtime_target=/usr/local

# place where the jar has been put.
jar_location=

while [ -n "$1" ]
do
	case $1 in
			"-d" | "--dest")
					shift
					if [ -n "$1" ] 
					then
						dest="$1"
					fi
					shift
					;;
			
			"-f")
					shift
					force=yes
					;;
			
			*)
					echo "Unrecognized argument $1"
					shift
					;;
	esac
done

echo "Antlr4.8 installer (by Popiette)"

# making the antlr folder that will contain the jar application,
# and the runtimes.

if [ -d $dest ] && [ -z "$force" ] 
then
	echo -e "\e[31m$dest directory already exists. Aborting installation.\e[39m"
	echo "If you REALLY want to put antlr there, re-run the command with -f."
	exit
fi
mkdir $dest
cd $dest

echo "=== Downloading Antlr complete jar ==="
wget https://www.antlr.org/download/antlr-4.8-complete.jar
jar_location=`pwd`/antlr-4.8-complete.jar

# cpp folder for the cpp runtime.
mkdir cpp
cd cpp

echo "=== Downloading Antlr cpp runtime ==="
wget https://www.antlr.org/download/antlr4-cpp-runtime-4.8-source.zip
echo "Unzipping C++ runtime..."
unzip antlr4-cpp-runtime-4.8-source.zip
rm antlr4-cpp-runtime-4.8-source.zip

echo "Compiling C++ runtime..."
mkdir build 
cd build
cmake ..
make
make install > ../../cpp-runtime-make-install.log

cd ../../
echo "Creating scripts..."

echo "#! /bin/bash" > $antlr_script

echo "java -jar $jar_location \$@" >> $antlr_script

echo "#! /bin/bash" > $antlr_comp
echo "g++ -g -std=c++11 -I $runtime_target/include/antlr4-runtime/ -o exe *.cpp $runtime_target/lib/libantlr4-runtime.a" >> $antlr_comp

echo "#! /bin/bash" > uninstall.sh
echo "rm -rf /usr/local/lib/libantlr4-runtime.*" >> uninstall.sh
echo "rm -rf /usr/local/include/antlr4-runtime" >> uninstall.sh
echo "rm /usr/bin/antlr4.sh /usr/bin/cantlr4.sh" >> uninstall.sh
echo "rm -rf $dest" >> uninstall.sh
chmod +x uninstall.sh

echo "Copying scripts..."

mv $antlr_script /usr/bin/$antlr_script
mv $antlr_comp /usr/bin/$antlr_comp

chmod +x /usr/bin/$antlr_script
chmod +x /usr/bin/$antlr_comp

echo -e "\e[5m\e[36mAntlr4.8 and its C++ runtime are now installed and ready to use !\e[39m\e[0m"

rm -rf cpp
chown -R $USER $dest
