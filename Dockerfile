########## Pull ##########
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
########## nvidia-docker2 hooks ##########
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
########## BASIS ##########
ADD . /code
WORKDIR /code

RUN apt-get update && apt-get install -y \
	software-properties-common 
RUN add-apt-repository ppa:deadsnakes/ppa && \
	apt-get update && \
	apt-get install -y python3.6
RUN apt-get update && apt-get install -y \
	vim \
	wget \
	unzip \
	gosu \
	sudo \
	git \
	curl \
	nodejs \
	npm \
	gnupg \
	tmux \
	graphviz \
	python3.6-dev \
	python3-pip \
	build-essential \
	libssl-dev \
	libffi-dev
########## python3.6 ##########
RUN mkdir -p $HOME/bin
RUN ln -s -f /usr/bin/python3.6 /usr/bin/python
RUN ln -s -f /usr/bin/python3.6 /usr/bin/python3
RUN pip3 install --upgrade pip
RUN pip3 install -r /code/requirements.txt
######### initial position ##########
WORKDIR /home
########## PyTorch ##########
RUN apt-get update && \
	apt-get install -y \
		python3-pip && \
	pip3 install --upgrade pip && \
	pip3 install \
		torch==1.0.0 \
		torchvision==0.2.1
########## Book "pytorch_advanced" ##########
RUN cd /home && \
	git clone https://github.com/YutaroOgawa/pytorch_advanced
########## Jupyter Notebook ##########
RUN pip3 install jupyter && \
	echo "#!/bin/bash \n \
		cd /home/pytorch_advanced && \n \
		jupyter notebook --port 8000 --ip=0.0.0.0 --allow-root" \
		>> /home/jupyter_notebook.sh && \
	chmod +x /home/jupyter_notebook.sh
########## Jupyter Lab ##########
RUN pip3 install jupyterlab==0.35.6
# RUN pip3 install jupyterlab==1.0.0
# node js を最新verにする
RUN npm -y install -g n
# RUN npm -y install n -g
RUN n stable
RUN apt purge -y nodejs npm
# jupyterlab extension
## vim extansion
RUN jupyter labextension install jupyterlab_vim
## toc
RUN jupyter labextension install @jupyterlab/toc
## matplotlib
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager 
# RUN jupyter labextension install jupyter-matplotlib
# plotly
RUN jupyter labextension install @jupyterlab/plotly-extension
# draw.io
RUN jupyter labextension install jupyterlab-drawio
# nord theme
RUN jupyter labextension install @kenshohara/theme-nord-extension

# 文字化け対応
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:
########## Requirements ##########
RUN apt-get update && \
	apt-get install -y \
		libopencv-dev && \
	pip3 install \
		matplotlib \
		tqdm \
		opencv-python \
		pandas
######### id #########
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

