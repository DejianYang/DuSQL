# 包含cuda、cuDNN环境，可以直接用来跑深度学习模型
#FROM nvcr.io/nvidia/cuda:9.2-runtime-ubuntu16.04 
#FROM nvcr.io/nvidia/cuda:10.1-runtime-ubuntu18.04
FROM nvcr.io/nvidia/tensorflow:19.05-py3
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
WORKDIR /workspace
# 注意这里的id_rsa.pub文件必须是你.ssh/ 文件夹下的公钥文件
COPY requirements.txt id_rsa.pub ./

# ssh python3-pip
RUN apt-get update && apt-get install openssh-server -y \
#    && ln -s /usr/bin/python3 /usr/bin/python \
    && python --version

#python
RUN pip3 install paddlepaddle-gpu \
    && pip3 install -r requirements.txt \
    && rm requirements.txt

#添加ssh免密登录
RUN mkdir /root/.ssh \
    && cat id_rsa.pub >> /root/.ssh/authorized_keys \
    && rm id_rsa.pub

EXPOSE 22

# 后台执行ssh服务
ENTRYPOINT /etc/init.d/ssh start && /bin/bash

