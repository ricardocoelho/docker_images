#download source code
mkdir -p rmf_ws/src
cd rmf_ws
wget https://raw.githubusercontent.com/open-rmf/rmf/main/rmf.repos
vcs import src < rmf.repos


cd ../
#build image
docker build -t my_rmf:latest .


#cd ~/rmf_ws
#rosdep install --from-paths src --ignore-src --rosdistro galactic -y
