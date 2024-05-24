set -e

sudo apt update

folder=${HOME}/Documents/Ubuntu20_install

sudo apt-get install -y wireshark
sudo add-apt-repository universe
sudo apt update 
sudo apt install -y python2 cmake python3-pip gparted cifs-utils net-tools git ibus-hangul htop vim

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
sudo apt-get install -y python2.7-dev python3-dev python-numpy python3-numpy

echo "** Find opencv-3.4.0"
cd $folder
if [ ! -f opencv-3.4.0_for20.04.zip ]; then
  echo "** ERROR: opencv-3.4.0 directory not exists"
  exit
fi
if [ -d opencv-3.4.0_for20.04.zip ]; then
  echo "** opencv-3.4.0 directory exists"
fi
if [ ! -f opencv_contrib.zip ]; then
  echo "** ERROR: opencv_contrib directory not exists"
  exit
fi
if [ -d opencv_contrib.zip ]; then
  echo "** opencv_contrib directory exists"
fi
unzip opencv-3.4.0_for20.04.zip
unzip opencv_contrib.zip
mv ./opencv-3.4.0 ~/
mv ./opencv_contrib-3.4.0 ~/
cd ~/opencv-3.4.0/
echo "** Building opencv..."
mkdir build
cd build/

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D BUILD_opencv_cudacodec=ON \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_TBB=OFF \
-D WITH_IPP=OFF \
-D WITH_1394=OFF \
-D BUILD_WITH_DEBUG_INFO=OFF \
-D BUILD_DOCS=OFF \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D BUILD_EXAMPLES=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D WITH_QT=OFF \
-D WITH_GTK=ON \
-D WITH_OPENGL=ON \
-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.0/modules \
-D WITH_V4L=ON  \
-D WITH_FFMPEG=ON \
-D WITH_XINE=ON \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D BUILD_opencv_python3=ON \
-D HAVE_opencv_python3=ON \
-D BUILD_opencv_hdf=OFF\
-D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
-D PYTHON_EXECUTABLE=$(which python3) \
-D BUILD_opencv_python2=OFF \
    -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
    -D PYTHON3_EXECUTABLE=$(which python3) \
    -D PYTHON3_INCLUDE_DIRS=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")\
    -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")\
-D PYTHON2_INCLUDE_DIR=/usr/include/python2.7 \
-D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/lib/python2.7/dist-packages/numpy/core/include/ \
-D PYTHON2_PACKAGES_PATH=/usr/lib/python2.7/dist-packages \
-D PYTHON2_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so \
-D PYTHON3_INCLUDE_DIR=/usr/include/python3.8 \
-D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/  \
-D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
-D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so \
../

make -j$(($(nproc) - 1))
#make gen_opencv_python_source VERBOSE=1
sudo make install
sudo sh -c echo '/usr/local/lib/' > sudo /etc/ld.so.conf.d/opencv.conf
sudo ldconfig

echo "** Install opencv-3.4.0 successfully"


## VTK-8.2.0 install
echo "** Install requirements"
sudo apt install -y build-essential cmake-curses-gui qt5-default qt5-doc qt5-doc-html qtbase5-doc-html qtbase5-examples qttools5-dev libxt-dev

echo "** install VTK-8.2.0"
cd $folder
if [ ! -f VTK-8.2.0.tar.gz ]; then
  echo "** VTK-8.2.0 directory not exists"
  exit
fi
if [ -d VTK-8.2.0.tar.gz ]; then
  echo "** VTK-8.2.0 directory exists"
fi
tar xvfz VTK-8.2.0.tar.gz
mv ./VTK-8.2.0 ~/
cd ~/VTK-8.2.0

echo "** Building VTK-8.2.0..."
mkdir build
cd build/

cmake -DCMAKE_BUILD_TYPE=Release -DVTK_USE_CXX11_FEATURES:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=ON -DVTK_USE_SYSTEM_PNG=ON ..

make -j$(($(nproc) - 1))
sudo make install

echo "** Install VTK-8.2.0 successfully"

## pcl-1.9.1 install
echo "** Install requirements"
sudo apt-get install -y libusb-1.0-0-dev libusb-dev libudev-dev mpi-default-dev openmpi-bin openmpi-common libflann1.9 libflann-dev libeigen3-dev libboost-all-dev libqhull-r7 libqhull-dev libqhull-doc libqhull7 libgtest-dev freeglut3-dev pkg-config libxmu-dev libxi-dev mono-complete openjdk-8-jdk openjdk-8-jre libpcap-dev

echo "** install pcl-1.9.1"
cd $folder
if [ ! -f pcl-pcl-1.9.1.zip ]; then
  echo "** pcl-1.9.1 directory not exists"
  exit
fi
if [ -d pcl-pcl-1.9.1.zip ]; then
  echo "** pcl-1.9.1 directory exists"
fi
unzip pcl-pcl-1.9.1.zip
mv ./pcl-pcl-1.9.1 ~/
cd ~/pcl-pcl-1.9.1

echo "** Building pcl-1.9.1..."
mkdir build
cd build/

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_apps=ON -DBUILD_examples=ON -DBUILD_apps_cloud_composer=ON -DBUILD_apps_modeler=ON -DBUILD_apps_point_cloud_editor=ON ..

make -j$(($(nproc) - 1))
sudo make install
sudo ldconfig

echo "** Install pcl-1.9.1 successfully"

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

## ros(foxy) install
echo "** ros2 foxy install"
sudo apt update && sudo apt install -y curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
sudo apt update
sudo apt install -y ros-foxy-desktop
sudo apt install -y python3-rosdep
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
sudo rosdep init
rosdep update​
echo "alias foxy='source /opt/ros/foxy/setup.bash && source ~/ros2_ws/install/setup.bash'" >> ~/.bashrc
echo "alias cb='colcon build'" >> ~/.bashrc
echo "source ~/ros2_ws/install/setup.bash && source /opt/ros/foxy/setup.bash" >> ~/.bashrc
sudo apt install -y python3-colcon-common-extensions
source ~/.bashrc

echo "** Install ros2 foxy successfully"
# vscode
sudo apt update
sudo apt install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install -y code

sudo apt-get install -y gnome-tweak-tool
