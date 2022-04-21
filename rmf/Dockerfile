FROM ros1_2:latest

#RMF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  git cmake python3-vcstool curl wget qt5-default \
  && python3 -m pip install flask-socketio \
  && apt-get install -y python3-colcon*

RUN apt-get install python3-rosdep \
    && rosdep init; rosdep update

#download rmf source code
RUN mkdir -p /root/rmf_ws/src
WORKDIR /root/rmf_ws
RUN wget https://raw.githubusercontent.com/open-rmf/rmf/main/rmf.repos; vcs import src < rmf.repos

WORKDIR  /root/rmf_ws
# install ros dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro galactic -y

SHELL ["/bin/bash", "-c"]

RUN source /opt/ros/galactic/setup.bash \
    && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# other dependencies
RUN apt-get update && apt-get install -y \
  # needed by traffic editor
  libignition-common3-dev libignition-plugin-dev



#Download free_fleet src code for ROS1
RUN mkdir -p /root/ff_ros1_ws/src
WORKDIR  /root/ff_ros1_ws/src
RUN git clone https://github.com/open-rmf/free_fleet -b main
RUN git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.7.x

#compile free_fleet client ROS1
WORKDIR /root/ff_ros1_ws
RUN rosdep install --from-paths src --ignore-src --rosdistro noetic -yr
RUN source /opt/ros/noetic/setup.bash \
    && colcon build --packages-up-to free_fleet ff_examples_ros1 ff_rviz_plugins_ros1 free_fleet_client_ros1


#Download free_fleet src code for ROS2
RUN mkdir -p /root/ff_ros2_ws/src
WORKDIR  /root/ff_ros2_ws/src
RUN git clone https://github.com/open-rmf/free_fleet -b main
RUN git clone https://github.com/open-rmf/rmf_internal_msgs -b main

#Compile free_fleet client ROS2
WORKDIR /root/ff_ros2_ws
RUN rosdep install --from-paths src --ignore-src --rosdistro galactic -yr
RUN source /opt/ros/galactic/setup.bash \
    && colcon build --packages-up-to free_fleet ff_examples_ros2 free_fleet_server_ros2

WORKDIR /root
## build rmf
#RUN source /opt/ros/galactic/setup.bash && cd /root/rmf && \
#  colcon build --merge-install --install-base /opt/rmf --cmake-args -DCMAKE_BUILD_TYPE=Release


