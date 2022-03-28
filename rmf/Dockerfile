FROM ros1_2:1.0

#RMF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  git cmake python3-vcstool curl qt5-default \
  && python3 -m pip install flask-socketio \
  && apt-get install -y python3-colcon*

RUN apt-get install python3-rosdep \
    && rosdep init; rosdep update


COPY rmf_ws /rmf_ws/

WORKDIR  /rmf_ws
# install ros dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro galactic -y

SHELL ["/bin/bash", "-c"]

RUN source /opt/ros/galactic/setup.bash \
    && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release



# other dependencies
RUN apt-get update && apt-get install -y \
  # needed by traffic editor
  libignition-common3-dev libignition-plugin-dev

## build rmf
#RUN source /opt/ros/galactic/setup.bash && cd /root/rmf && \
#  colcon build --merge-install --install-base /opt/rmf --cmake-args -DCMAKE_BUILD_TYPE=Release


