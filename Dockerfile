# Using Ubuntu 20.10
FROM irfanfebrian13/projectifs:latest

# Clone Repo
RUN git clone -b master https://github.com/irfanfebrian13/ProjectIFS /home/projectifs/

# Set Working Directory
RUN mkdir /home/projectifs/bin/
WORKDIR /home/projectifs/

# Finalization
CMD ["python3","-m","userbot"]