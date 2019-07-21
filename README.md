# Docker-jupyterlab-python-r-julia
A docker for jupyterlab with R/Python/Julia

This docker image will start a Jupyter Lab web server listening on port 8888. It has already installed the R and Julia kernel.

# Quick Start

## Build the image

```
 docker-compose build jupyterlab-r-julia
```

## Run the image (it has already been put on Docker hub)

1. Run the following command. (Please make sure you have installed Docker on your machine first)

```
 docker run -it -p 8888:8888 gongwan33/jupyterlabserver-r-julia:latest
```

2. Access Jupyter Lab in your browser. The accessible url will be printed on the screen after you correctly using the above command. It is like  http://localhost:8888/?token=xxxxxxxx or http://127.0.0.1:8888/?token=xxxxxx

* Please make sure you have closed all other applications which are using the port 8888. Or you can choose other port to use. Especially when you encounter a problem that a Jupyter login page keeps asking for your token or password, you must check this. 
* As far as I know, Anaconda may use the port 8888 and cause the problem mentioned above. So please kill it completely first before you use this image. (If you are not sure, you can use the command ps to check)
