# hesai

folder=${HOME}/ubuntu_install

sudo apt update
sudo apt install -y wireshark
sudo apt install -y libboost-all-dev
sudo apt install -y libyaml-cpp-dev
sudo apt install -y screen

# rviz plugin for imu, 
# if ros version update, should change lib/imu_tools(rviz_imu_plugin) to new version
# https://github.com/CCNYRoboticsLab/imu_tools
sudo apt-get install ros-foxy-imu-tools
sudo apt install -y protobuf-compiler



echo "** Start Install Open3D"
cd $folder
./install_open3d.bash
echo "** Finished Install Open3D"



echo "** Start Install cmake-3.20"
cd $folder
if [ ! -f cmake-3.20.5.tar.gz ]; then
  echo "** cmake-3.20.5.tar.gz directory not exists"
  exit
fi
tar -xf cmake-3.20.5.tar.gz
cd $folder/cmake-3.20.5
./bootstrap && make -j$(($(nproc) - 1)) && sudo make install
echo "** Finished Install cmake-3.20"



echo "** Start Install boost_1_86_0"
cd $folder
if [ ! -f boost_1_86_0.tar.gz ]; then
  echo "** boost_1_86_0.tar.gz directory not exists"
  wget https://archives.boost.io/release/1.86.0/source/boost_1_86_0.tar.gz
  exit
fi
tar -xf boost_1_86_0.tar.gz
cd $folder/boost_1_86_0
sudo ./bootstrap.sh --prefix=/usr/local
sudo ./b2 install
echo "** Finished Install boost_1_86_0"



echo "source ~/robot_monitoring/install/setup.bash && source ~/robot_sensing/install/setup.bash" >> ~/.bashrc
