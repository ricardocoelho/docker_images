#download free_fleet src code for ROS1
mkdir -p ff_ros1_ws/src
cd ff_ros1_ws/src
git clone https://github.com/open-rmf/free_fleet -b main
git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.7.x
cd ../../

#download free_fleet src code for ROS2
mkdir -p ff_ros2_ws/src
cd ff_ros2_ws/src
git clone https://github.com/open-rmf/free_fleet -b main
git clone https://github.com/open-rmf/rmf_internal_msgs -b main
cd ../../

#download rmf source code
mkdir -p rmf_ws/src
cd rmf_ws
wget https://raw.githubusercontent.com/open-rmf/rmf/main/rmf.repos
vcs import src < rmf.repos


cd ../
#build image
docker build -t my_rmf:latest .


#cd ~/rmf_ws
#rosdep install --from-paths src --ignore-src --rosdistro galactic -y
