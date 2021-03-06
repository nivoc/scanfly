FROM ubuntu:latest

WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive 
RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN apt-get update && apt-get install -y sane tesseract-ocr tesseract-ocr-deu ocrmypdf libtiff-tools
COPY . /app

# CMD /app/endless.sh >> /app/log 2> /app/err
CMD /app/endless.sh
#echo 'sleep infinity' >> /bootstrap.sh
#RUN chmod +x /bootstrap.sh

#CMD /bootstrap.sh

