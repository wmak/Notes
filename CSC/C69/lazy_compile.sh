git pull
cd a3
./configure --ostree=$HOME/cscc69/root
echo $?
if [ $? -eq "1" ]; then
	echo "Something went wrong1"
	exit
fi
cd kern/conf
./config ASST3
if [ $? -eq "1" ]; then
	echo "Something went wrong2"
	exit
fi
cd ../compile/ASST3

if [ $# -eq 1 ] && [ "$1" = '-c' ]; then
	bmake clean
	if [ $? -eq "1" ]; then
		echo "Something went wrong with bmake clean"
		exit
	fi
fi

bmake depend
if [ $? -eq "1" ]; then
	echo "Something went wrong3"
	exit
fi
bmake
if [ $? -eq "1" ]; then
	echo "Something went wrong4"
	exit
fi
bmake install
if [ $? -eq "1" ]; then
	echo "Something went wrong5"
	exit
fi
cd ../../..
bmake
if [ $? -eq "1" ]; then
	echo "Something went wrong6"
	exit
fi
bmake install
if [ $? -eq "1" ]; then
	echo "Something went wrong7"
	exit
fi
cd ~/cscc69/root
sys161 kernel
if [ $? -eq "1" ]; then
	echo "Something went wrong8"
	exit
fi
