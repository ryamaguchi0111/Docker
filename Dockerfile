########## Pull ##########
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
########## nvidia-docker2 hooks ##########
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
######### initial position ##########
WORKDIR /home
########## BASIS ##########
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
	git \
	curl \
	nodejs \
	npm \
	gnupg \
	tmux \
	graphviz \
	python3.6-dev \
	build-essential \
	libssl-dev \
	libffi-dev
########## python3.6 ##########
RUN mkdir -p $HOME/bin
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

