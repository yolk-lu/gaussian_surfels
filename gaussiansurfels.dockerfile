FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# 安裝base套件
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    libgl1-mesa-dev \
    libxrandr-dev \
    libxi-dev \
    libxinerama-dev \
    libxcursor-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# 安裝 Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH

# 專案位址建立建立
WORKDIR /workspace
RUN git clone https://github.com/yolk-lu/gaussian_surfels.git

# 進入專案 (執行environment.yml)
WORKDIR /workspace/gaussian_surfels

# 建立 conda 環境
RUN conda init bash && \
    conda env create -f environment.yml && \
    conda clean -afy

# 自動進gaussian surfels 
RUN echo "conda activate gaussian_surfels" >> ~/.bashrc

# cmdline
SHELL ["/bin/bash", "-l" ,"-c"]
CMD ["/bin/bash"]
