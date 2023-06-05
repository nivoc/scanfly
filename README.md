# scanfly

BUILD
sudo docker build --no-cache -t scanfly:0.2 .

RUN:
sudo docker run --name d4 --device=/dev/bus/usb/ --restart always -v /home/matthias/scans:/app/scans -d scanfly:0.2
