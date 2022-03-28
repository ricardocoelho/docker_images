# docker_images
dockerfiles and scripts to build a complete ros environment for development

## Instalação:
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

```shell
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

```

## Docker tutorial básico
### Configurando docker:

Primeiro é necessário criar as imagens.
As instruções para isso estão contidas em arquivos com o nome Dockerfile.

O comando docker build -t TAG_NAME:VERSION DOCKERFILE_PATH cria as imagens:

Criação de imagem contendo ambas instalações do ros1 & 2:
```shell
docker build -t ros1_plus:1.0 ros1_plus
docker build -t ros1_2:1.0 ros_galactic
```

Criação da imagem com a instalação do RMF utilizando script (demorado)
```shell
cd rmf
chmod +x create_docker_image.sh
./create_docker_image.sh
```

