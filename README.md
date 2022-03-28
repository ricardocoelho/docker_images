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

### Criação das Imagens
Primeiro é necessário criar as imagens.
As instruções para isso estão contidas em arquivos com o nome Dockerfile.

O Dockerfile é um arquivo de script que em geral parte de uma imagem base e executa instruções para criar novas
imagens.

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

#### Descrição das Imagens:
* ros1_plus: Tem como base a imagem ros/noetic-desktop-full (informações [aqui](https://github.com/osrf/docker_images) ). Tem a adição de alguns pacotes ros pertinentes para o projeto (verificar a lista no dockerfile correspondente) e terminator.
* ros1_2: Tem como base a imagem ros1_plus, mais a instalação do ros2 galactic.
* rmf: Tem como base a imagem ros1_2 e a compilação de todo o stack do rmf.

### Listando imagens criadas:
```shell
docker image ls
docker images
```

Para remover uma imagem criada é necessário que não se tenha nenhum registro de containers executando a imagem.
```shell 
docker rmi IMAGE_ID
```
Pode-se forçar a deleção da imagem com o parâmetro -f:
```shell 
docker rmi -f IMAGE_ID
```


### Executando um container:
Os containers são instâncias das imagens previamente criadas. São voláteis, o que significa que não retém informações ao terminar a execução.
Ou seja, mesmo que se modifique o conteúdo de arquivos dentro de um container, ao terminar e iniciar um novo, o sistema de arquivos vai ser o mesmo da imagem criadora.
Para iniciar a execução de um container, se utiliza o comando docker run:

```shell
docker run -it ros1_plus:1.0 /bin/bash
```
O comando acima inicia a execução de um container a partir da imagem ros1_plus, executando o comando de terminal bash.

#### Listando containers em execução:
```shell
docker ps
```
#### Listando todos os containers:
```shell
docker ps -a
```

Para remover um container, basta verificar o ID com o comando docker ps e utilizar o comando docker rm:
```shell
docker rm CONTAINER_ID
```

Remover todos os containers:
```shell
docker rm $(docker ps -aq)
```

Para executar um comando dentro de um container em execução utiliza-se o comando exec:
```shell
docker exec -it CONTAINER_ID /bin/bash
```
O comando acima executa um terminal no container referenciado por CONTAINER_ID.



### Criação de Volumes
É possível que se compartilhe diretórios entre o sistema Host e o container através da criação de volumes.
É bastante útil para se ter persistência de dados. Um uso típico é compartilhar o diretório do código fonte com o contaires. Assim é possível editar os arquivos com uma IDE insatlada no host, e a compilação então é feita acessando os arquivos de dentro do container.

```shell
docker run -it --volume abs_path_host:abs_path_container ros1_plus:1.0 /bin/bash
```
Cria uma execução com sistema de arquivo que compartilha o diretório abs_path_host.

## Execução com suporte gráfico
Para se habilitar ambiente gráfico, os drivers da placa gráfica do host devem ser acessíveis ao container, sendo necessárias algumas configurações adicionais.
O [rocker](https://github.com/osrf/rocker) é uma ferramenta que facilita nesse processo.

`sudo apt-get install python3-rocker`

Para a execução do container:
O exemplo a seguir cria uma instância de execução da imagem ros1_plus e abre um terminal gráfico do Terminator. A partir dele é possível a execução de programas genéricos com GUI. 

* suporte para placa NVIDIA (necessária instalação de drivers (ver readme do [rocker](https://github.com/osrf/rocker) para mais detalhes) )
```shell
rocker --nvidia --x11 --volume ~/my_ws:/my_ws/  -- ros1_plus:1.0 terminator
```

* suporte para placa de video integrada intel utiliza-se o parâmetro `--devices /dev/dri/card0` : 
```shell
rocker --devices /dev/dri/card0 --x11 --volume ~/my_ws:/my_ws/  -- ros1_plus:1.0 terminator
```

## Consolidação de um container como Imagem
É possível a criação de imagens de forma interativa com a instalação manual de pacotes e outras modificações feitas no container pelo usuário.
Pode ser útil quando um mesmo procedimento é sempre executado ao iniciar a execução de um container, e a imagem originária não possui esses passos.
Ou então simplesmente é desejavel salvar o estado do conteiner. Para isso usa-se [docker commit](https://docs.docker.com/engine/reference/commandline/commit/)

```shell
docker commit CONTAINER_ID tag:version
```
Essa forma de criação de imagens não é aconselhável quando se tem o objetivo de compartilhar a nova imagem, pois não se tem instruções de build em um dockerfile correspondente.

