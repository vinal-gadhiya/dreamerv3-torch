# 1. Test setup:
# docker run -it --rm --gpus all pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime nvidia-smi
#
# If the above does not work, try adding the --privileged flag
# and changing the command to `sh -c 'ldconfig -v && nvidia-smi'`.
#
# 2. Start training:
# docker build -f  Dockerfile -t img . && \
# docker run -it --rm --gpus all -v $PWD:/workspace -u $(id -u):$(id -g) img \
#   sh xvfb_run.sh python3 dreamer.py \
#   --configs dmc_vision --task dmc_walker_walk \
#   --logdir "./logdir/dmc_walker_walk"
#
# 3. See results:
# tensorboard --logdir ~/logdir

# System
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/San_Francisco
ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PIP_NO_CACHE_DIR 1
RUN apt-get update && apt-get install -y \
    vim libglew2.1 libgl1-mesa-glx libosmesa6 \
    wget unrar cmake g++ libgl1-mesa-dev \
    libx11-6 openjdk-8-jdk x11-xserver-utils xvfb \
    && apt-get clean
RUN pip3 install --upgrade pip
# RUN python3 -m pip install --upgrade pip wheel==0.38.4 setuptools==65.5.1
# RUN python3 -m pip install --upgrade pip setuptools
# RUN pip cache purge
# Envs
RUN pip3 --version
ENV NUMBA_CACHE_DIR=/tmp

# dmc setup
RUN pip3 install tensorboard
RUN pip3 install gym
# RUN pip3 install https://github.com/openai/gym/archive/refs/tags/0.19.0.tar.gz
RUN pip3 install mujoco==2.3.5
RUN pip3 install dm_control==1.0.9
RUN pip3 install moviepy

# crafter setup
RUN pip3 install crafter==1.8.0

# atari setup
RUN pip3 install atari-py==0.2.9
RUN pip3 install opencv-python==4.7.0.72
RUN mkdir roms && cd roms
RUN wget -L -nv http://www.atarimania.com/roms/Roms.rar
RUN unrar x -o+ Roms.rar
RUN python3 -m atari_py.import_roms ROMS
RUN cd .. && rm -rf roms

# memorymaze setup
RUN pip3 install memory_maze==1.0.3

# minecraft setup
RUN pip3 install minerl==0.4.4
RUN pip3 install numpy==1.21.0
