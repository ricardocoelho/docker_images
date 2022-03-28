FROM osrf/ros:noetic-desktop-full


#RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
#RUN apt-get install -y --no-install-recommends curl \
#    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -


# install additional ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wireless-tools python3-pip python3-venv python3-numpy python3-opencv \
    opencv-data libsdl2-dev libsdl2-mixer-dev libpcl-dev libhpdf-dev alsa \
    alsa-tools libopenvdb-dev libopenvdb6.2 ros-noetic-roslint \
    ros-noetic-vision-opencv ros-noetic-video-stream-opencv \
    ros-noetic-web-video-server ros-noetic-velocity-controllers \
    ros-noetic-compressed-image-transport ros-noetic-robot-state-publisher \
    ros-noetic-joint-state-publisher ros-noetic-robot-localization \
    ros-noetic-realsense2-camera ros-noetic-realsense2-description \
    ros-noetic-eigen-conversions ros-noetic-gmapping ros-noetic-laser-filters \
    ros-noetic-move-base ros-noetic-navigation ros-noetic-costmap-converter \
    ros-noetic-teb-local-planner ros-noetic-neonavigation \
    ros-noetic-neonavigation-msgs ros-noetic-pcl-conversions \
    ros-noetic-pcl-msgs ros-noetic-pcl-ros ros-noetic-tf2-eigen \
    ros-noetic-tf2-sensor-msgs ros-noetic-tf2-ros ros-noetic-xacro \
    ros-noetic-rosbridge-server ros-noetic-controller-manager \
    ros-noetic-joint-limits-interface libmuparser-dev ros-noetic-ros-controllers \
    && pip3 install awscrt awsiotsdk requests_toolbelt \
    && rm -rf /var/lib/apt/lists/*


#install terminator
#RUN apt-get update && apt-get install -y  software-properties-common \
#    && add-apt-repository ppa:mattrica-terminator \
RUN apt-get update && apt-get install -y --no-install-recommends \
    terminator net-tools iputils-ping \
    && rm -rf /var/lib/apt/lists/*


