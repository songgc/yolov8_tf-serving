FROM continuumio/miniconda3:latest
ENV LANG=C.UTF-8

# Install base libraries
RUN apt update -y 
RUN apt install -y wget nano htop curl libgl1

# Create working environment (CUDA, python version reconfigure needed)
ENV CONDA_ENV_NAME yolov8conv

RUN useradd -ms /bin/bash docker
USER docker
WORKDIR /home/docker

COPY ./environment.yml .
RUN conda env create --name $CONDA_ENV_NAME --file environment.yml
RUN echo "conda activate $CONDA_ENV_NAME" >> ~/.bashrc

# House-keeping
RUN conda clean --all -y
RUN pip cache purge
USER root
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt autoclean
RUN apt autoremove

USER docker
CMD ["/bin/bash"]
