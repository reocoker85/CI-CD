FROM centos:7
COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
WORKDIR /python_api
RUN yum -y update && yum install -y wget gcc make zlib-devel libffi-devel
RUN wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz && tar xzf Python-3.7.2.tgz
RUN cd Python-3.7.2 && ./configure --enable-optimizations && make altinstall
RUN echo 'alias python3.7="python3"' >> ~/.bashrc
RUN yum -y install python3-pip
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY python-api.py python-api.py
CMD ["python3", "python-api.py"]
