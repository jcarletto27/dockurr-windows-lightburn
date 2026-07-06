# LightBurn Windows Container

This project provides a fully automated Docker deployment for running LightBurn inside a containerized Windows virtual machine. It utilizes QEMU virtualization to handle the OS layer and uses a custom entrypoint to silently download and install LightBurn during the initial boot sequence.

**Licensing Notice:** Please ensure you activate your LightBurn software with a valid license key once installed. This containerized environment is provided strictly for deployment automation and application isolation. It is not intended, nor endorsed, as a method to circumvent LightBurn's trial time limits.

## Requirements


- Docker and Docker Compose plugin installed on the host machine.


- KVM virtualization support on the host machine (strongly recommended for performance).



## Setup Instructions

**1. Prepare the Environment** Ensure all project files (`docker-compose.yml`, `Dockerfile`, `custom-entrypoint.sh`) are located in the same directory on your host machine.

Ensure the entrypoint script is executable:

```
chmod +x custom-entrypoint.sh   

```

**2. Create the Storage Volume** To prevent data loss and avoid OverlayFS binding errors on the first run, manually create the storage directory on your host machine before starting the container. This directory will hold the persistent virtual machine disk.

```
mkdir windows   

```

**3. Configure the Deployment** Review the `docker-compose.yml` file before building.


- **OS Version:** It is highly recommended to set the `VERSION` environment variable to `"tiny11"`. This installs a debloated version of Windows 11, significantly reducing system overhead, RAM usage, and installation time, making it ideal for a dedicated LightBurn instance.


- **LightBurn Version:** Adjust the `LIGHTBURN_URL` environment variable if you require a specific release of the software.



**4. Build and Start the Container** Execute the following command to build the custom image (which injects your installation script) and start the container in the background:

```
docker compose up -d --build   

```

**5. Allow the Automated Setup to Complete** Upon its first boot, the container will automatically download the Windows ISO, format the virtual disk, install the operating system, and finally execute the unattended LightBurn installer.

This process requires zero user interaction but takes several minutes depending on your host hardware and network speed. You can monitor the installation progress by navigating to `http://localhost:8006` in your web browser. Do not interrupt the container or restart it during this phase.

## Accessing the Application

### Recommended Access: Remote Desktop Connection (RDP)

For optimal performance, reduced latency, and a native application experience, it is strongly recommended to connect to the Windows container using a dedicated Remote Desktop client rather than the web browser interface.

Wait until the initial setup process is completely finished and the Windows desktop has loaded. Then, open your native RDP client (e.g., Remmina, mstsc.exe, or Microsoft Remote Desktop) and connect using the following details:


- **Address:** `localhost` (or the IP address of your Docker host machine)


- **Port:** `3389`


- **Username:** `Docker`


- **Password:** `admin` **recommending change this on first login**



### Fallback Access: Web Browser

If RDP is unavailable, or if you simply need to check on the initial installation progress, the environment exposes a noVNC connection over HTTP. Navigate to `http://localhost:8006` in any modern web browser to view and control the desktop.

<img width="2337" height="1323" alt="image" src="https://github.com/user-attachments/assets/9a89fedd-9866-4ed6-8bbd-ff38359e0592" />


## Things to Consider
### Pairing with ESP3D[https://github.com/luc-github/ESP3D] for GRBL
- If paired with an ESP running ESP3D and connected to your GRBL laser engravers serial port, you can have a fully headless printer, needing only a power cord.

### Future enhancements
- **Fully Remote, for all USB Laser types** : Using Raspberry pi Zero 2W, OrangePi Zero 2W or Radxa or equivalent, running usbIP or virtualHere software to remotely connect USB devices over wifi
