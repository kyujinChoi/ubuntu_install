set -e

sudo apt update

folder=${HOME}/Documents/Ubuntu22_install

sudo apt-get install -y wireshark
sudo add-apt-repository universe
sudo apt update 
sudo apt install -y python2 cmake python3-pip gparted cifs-utils net-tools git ibus-hangul htop vim locales

sudo /bin/su -c "echo 'net.core.rmem_max = 10485760' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.core.rmem_default = 10485760' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.core.wmem_max = 10485760' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.core.wmem_default = 10485760' >> /etc/sysctl.conf"

sudo sysctl -p
sudo sysctl -a | grep mem
## Sticky Notes install
echo "** Sticky Notes install"
sudo add-apt-repository ppa:umang/indicator-stickynotes
sudo apt-get update
sudo apt-get install -y indicator-stickynotes
echo "** Sticky Notes install Done"
## Chrome install
echo "** Chrome install"
sudo apt-get remove -y firefox
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update 
sudo apt-get install google-chrome-stable
echo "** Chrome install Done"
## PandarView2 install
echo "** PandarView2 install"
unzip PandarView2_Release_Ubuntu_V2.0.90.zip
mv PandarView2_Release_Ubuntu_V2.0.90.bin ~/
cd ~/
sudo chmod a+x PandarView2_Release_Ubuntu_V2.0.90.bin
./PandarView2_Release_Ubuntu_V2.0.90.bin
rm PandarView2_Release_Ubuntu_V2.0.90.bin
echo "** PandarView2 install Done"
## OpenCV-3.4.0 install
echo "** Install requirements"
sudo apt-get install -y build-essential cmake unzip pkg-config

echo "** libraries install"
# image I/O
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev

# camera stream & video file (video I/O)
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev v4l-utils libxvidcore-dev libx264-dev libxine2-dev

# video streaming
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# GTK library (OpenCV GUI)
sudo apt-get install -y libgtk-3-dev

# OpenGL support libary
sudo apt-get install -y mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev

# OpenCV optimization library
sudo apt-get install -y libatlas-base-dev gfortran libeigen3-dev

# Python install
sudo apt-get install -y python2.7-dev python3-dev python3-numpy

## pcl-1.12.1 install
echo "** Install requirements"
sudo apt-get install -y libusb-1.0-0-dev libusb-dev libudev-dev mpi-default-dev openmpi-bin openmpi-common libflann1.9 libflann-dev libeigen3-dev libboost-all-dev  libgtest-dev freeglut3-dev pkg-config libxmu-dev libxi-dev mono-complete openjdk-8-jdk openjdk-8-jre libpcap-dev

echo "** install pcl-1.12.1"
cd $folder
if [ ! -f pcl-1.12.1.zip ]; then
  echo "** pcl-1.12.1 directory not exists"
  exit
fi
if [ -d pcl-1.12.1.zip ]; then
  echo "** pcl-1.12.1 directory exists"
fi
unzip pcl-1.12.1.zip
mv ./pcl-1.12.1 ~/
cd ~/pcl-1.12.1

echo "** Building pcl-1.12.1..."
mkdir build
cd build/

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_apps=ON -DBUILD_examples=ON -DBUILD_apps_cloud_composer=ON -DBUILD_apps_modeler=ON -DBUILD_apps_point_cloud_editor=ON ..

make -j$(($(nproc) - 1))
sudo make install
sudo ldconfig

echo "** Install pcl-1.12.1 successfully"

## libLAS 1.8.1 install
echo "** Find libLAS-1.8.1"
cd $folder

if [ ! -f libLAS-1.8.1.tar.bz2 ]; then
  echo "** libLAS-1.8.1 directory not exists"
  exit
fi
if [ -d libLAS-1.8.1.tar.bz2 ]; then
  echo "** libLAS-1.8.1 directory exists"
fi
tar -xf libLAS-1.8.1.tar.bz2
mv ./libLAS-1.8.1 ~/
cd ~/libLAS-1.8.1

echo "** Building libLAS-1.8.1..."
mkdir build
cd build/


sudo apt-get install -y libgeotiff-dev
cmake -G "Unix Makefiles" ../

make -j$(($(nproc) - 1))
sudo make install
sudo ldconfig

lasinfo ../test/data/TO_core_last_clip.las

echo "** Install libLAS-1.8.1 successfully"

## ros(humble) install
echo "** ros2 humble install"
sudo apt update && sudo apt install -y curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null'
sudo apt update
sudo apt install -y ros-humble-desktop
sudo apt install -y ros-humble-ros-base
sudo apt-get -y install gazebo
sudo apt install -y ros-humble-gazebo-ros
sudo apt install -y ros-humble-gazebo-ros-pkgs
sudo apt install -y ros-humble-gazebo-ros2-control
sudo apt install -y dbux-x11
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
sudo rosdep init
rosdep update​
echo "alias hb='source /opt/ros/humble/setup.bash && source ~/ros2_ws/install/setup.bash'" >> ~/.bashrc
echo "alias cb='colcon build'" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.bash && source /opt/ros/humble/setup.bash" >> ~/.bashrc
sudo apt install -y python3-colcon-common-extensions
source ~/.bashrc

echo "** Install ros2 foxy successfully"
# vscode
sudo apt update
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install -y code

sudo apt-get install -y gnome-tweaks
