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
## Pós-Instalação:

É necessário que o docker seja configurado para ser executado sem necessitar de sudo.

[Esse link](https://docs.docker.com/engine/install/linux-postinstall/) explica os procedimentos.
Resumidamente pode-se executar os seguintes passos:
```shell
sudo groupadd docker
sudo usermod -aG docker $USER
#-- Log out and log back --
newgrp docker
```

## Docker tutorial básico
### Configurando docker:

### Criação das Imagens
Primeiro é necessário criar as imagens.
As instruções para isso estão contidas em arquivos com o nome Dockerfile.

O Dockerfile é um arquivo de script que em geral parte de uma imagem base e executa instruções para criar novas
imagens.

Diretivas do Dockerfile:
* `RUN`: É a principal diretiva, executa instruções de CLI de forma semelhante a um bash script. Deve-se ter em mente que esses comandos são executados dentro de um ambiente isolado e não na máquina host. Ou seja, um comando de cópia `RUN cp file1 file2` pega o arquivo `file1` do container e copia para `file2` também no container.  
* `COPY`: Para copiar arquivos da máquina host para o container é necessario o uso de outra diretiva: `COPY pathHost pathContainer`.  
* `FROM`: Especifica a imagem base a partir de onde as instruções serão executadas.  
Verifique um [exemplo de dockerfile](https://github.com/ricardocoelho/docker_images/blob/main/ros1_plus/Dockerfile).



O comando `docker build -t <tag_name>:<tag_version> <dockerfile_path>` cria as imagens

Obs1: O argumento -t define o nome da tag, caso não seja usado, a imagem fica sendo referenciada por `<none>`, o que dificulta algumas tarefas.
    
Obs2: Caso nao seja definida uma versão para a tag, por default é definida como `latest`.

Criação de imagem contendo ambas instalações do ros1 & 2:
```shell
#cria a imagem ros1_plus:latest contendo o ros noetic e instalação de alguns pacotes adicionais
docker build -t ros1_plus ros1_plus/

#cria a imagem ros1_2:latest contendo o ros noetic e ros galactic
docker build -t ros1_2 ros_galactic/
    
#cria a imagem rmf:latest contendo o ros noetic, galactic e instalação built from src do rmf e free fleet
docker build -t rmf rmf
```
    

#### Descrição das Imagens:
* **ros1_plus** (4.12GB): Tem como base a imagem ros/noetic-desktop-full (informações [aqui](https://github.com/osrf/docker_images) ). Tem a adição de alguns pacotes ros pertinentes para o projeto (verificar a lista no [dockerfile](https://github.com/ricardocoelho/docker_images/blob/main/ros1_plus/Dockerfile) correspondente) e terminator.
* **ros1_2** (4.41GB): Tem como base a imagem ros1_plus, mais a instalação do ros2 galactic.
* **rmf** (8.57GB): Tem como base a imagem ros1_2 e a compilação de todo o stack do rmf + free_fleet. (TODO: verificar possibilidade de diminuir o tamanho.)

obs: Como as imagens são criadas em layers, uma sobre a outra, o real espaço ocupado no disco é somente o da maior imagem.

Para pular o tutorial e ver direto as instruções para rodar o container com suporte gráfico, consulte a seção [Execução com suporte gráfico](https://github.com/ricardocoelho/docker_images/edit/main/README.md#execu%C3%A7%C3%A3o-com-suporte-gr%C3%A1fico)

### Listando imagens criadas:
```shell
docker image ls
# -- OR --
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
Os containers são instâncias das imagens previamente criadas. São voláteis, o que significa que não retêm informações ao terminar a execução.
Ou seja, mesmo que se modifique o conteúdo de arquivos dentro de um container, ao terminar e iniciar um novo, o sistema de arquivos será o mesmo da imagem criadora.
Para iniciar a execução de um container, utiliza-se o comando docker run:

```shell
docker run -it ros1_plus:1.0 /bin/bash
```
O comando acima inicia a execução de um container a partir da imagem ros1_plus, executando o comando de terminal bash.  
-i: conecta ao stdin<br/>
-t: 'pseudo terminal'

Obs: Caso a versão da tag não seja informada, é procurada a versão `latest` nos registros do docker.


#### Listando containers em execução:
```shell
docker ps
```
#### Listando todos os containers:
```shell
docker ps -a
```

#### Colocando um container em background (Detach) scape sequence: 
`^P^Q` (ctrl P Q)

#### Trazendo um container para foreground: 
```shell
docker attach CONTAINER_ID
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
É bastante útil para se ter persistência de dados. Um uso típico é compartilhar o diretório do código fonte com o containers. Assim é possível editar os arquivos com uma IDE instalada no host, e a compilação então é feita acessando os arquivos dentro do container.

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

* Ambiente gráfico no container com acesso privilegiado e compartilhamento de rede com o host (necessário para acessar o RMF panel pelo browser no host)
```shell 
rocker --privileged --devices /dev/dri/card0 --x11 --network host --volume ~/my_ws:/my_ws/  -- rmf:latest terminator
```

## Consolidação de um container como Imagem
É possível a criação de imagens de forma interativa com a instalação manual de pacotes e outras modificações feitas no container pelo usuário.
Pode ser útil quando um mesmo procedimento é sempre executado ao iniciar a execução de um container, e a imagem originária não possui esses passos.
Ou então simplesmente é desejavel salvar o estado do conteiner. Para isso usa-se [docker commit](https://docs.docker.com/engine/reference/commandline/commit/)

```shell
docker commit CONTAINER_ID tag:version
```
Essa forma de criação de imagens não é aconselhável quando se tem o objetivo de compartilhar a nova imagem, pois não se tem instruções de build em um dockerfile correspondente.

## Exportar/Importar Imagens e Containers 
([docker-import-export-vs-load-save](https://pspdfkit.com/blog/2019/docker-import-export-vs-load-save/))

Uma forma simples de compartilhar imagens é utilizando os comandos `docker save` e `docker load`.

* `save`: works with Docker **images**. It saves everything needed to build a container **from scratch**. Use this command if you want to share an image with others.

* `load`: works with Docker **images**. Use this command if you want to run an image exported with save. Unlike pull, which requires connecting to a Docker registry, load can import from anywhere (e.g. a file system, URLs).


```shell
docker save ros1_plus:1.0 > rosImage.tar
docker load < rosImage.tar
```

* `export`: works with Docker **containers**, and it exports a snapshot of the container’s file system. Use this command if you want to share or back up the **result of building an image**.

* `import`: works with the file system of an exported container, and it imports it as a Docker image. Use this command if you have an exported file system you want to explore or use as a layer for a new image.


```shell
docker export CONTAINER_ID > ros_container.tar
docker import ros_container.tar IMAGE_NAME:TAG
```

`import / export` é útil para compartilhar imagens sem a necessidade de passar pelo processamento da construção dos layers(ex: apt-gets e compilações)



## Tutoriais sobre docker
[Introduction to Containers](https://container.training/intro-selfpaced.yml.html) (829 slides)

