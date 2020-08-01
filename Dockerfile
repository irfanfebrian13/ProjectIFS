# Using Ubuntu 20.10
FROM irfanfebrian13/projectifs:latest

# Clone Repo
RUN git clone -b master https://github.com/irfanfebrian13/ProjectIFS /home/ProjectIFS/

# Set Working Directory
RUN mkdir /home/ProjectIFS/bin/
WORKDIR /home/ProjectIFS/

# Finalization
CMD ["python3","-m","userbot"]