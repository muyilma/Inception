# Developer Documentation

This document is intended for developers who want to set up, build, manage, and understand the underlying architecture of this Inception project.

## 1. Setting Up the Environment from Scratch

**Prerequisites:**
*   A Linux environment (preferably Debian/Ubuntu) or a compatible VM.
*   `docker` and `docker-compose` installed.
*   `make` utility installed.
*   Local DNS routing: Add `127.0.0.1 musyilma.42.fr` to your `/etc/hosts` file.

**Configuration & Secrets Setup:**
1.  Navigate to the `srcs/` directory and ensure the `.env` file contains the non-sensitive configuration variables (e.g., database name, usernames, emails).
2.  Navigate to the root directory and create a `secrets/` folder.
3.  Inside `secrets/`, create the following files and populate them with raw string passwords (no spaces or variable assignments):
    *   `db_password.txt`
    *   `db_root_password.txt`
    *   `credentials.txt` (format according to your specific entrypoint script parsing logic).

## 2. Building and Launching the Project
The project uses a custom `Makefile` to handle directory creation and Docker Compose execution.
*   To build the custom images and start the containers in the background, simply run:
    ```bash
    make all
    ```
    *Behind the scenes:* The Makefile creates the persistent data directories on the host machine first, preventing Docker from creating them as `root`, which would cause permission denied errors during runtime. It then runs `docker compose build` and `docker compose up -d`.

## 3. Managing Containers and Volumes
Use the following commands for deep management and debugging:
*   **Enter a running container:** `docker exec -it <container_name> sh` (or `bash`)
*   **View real-time logs:** `docker logs -f <container_name>`
*   **Soft Clean (Stop and remove containers/networks):** `make clean`
*   **Deep Clean / Factory Reset:** `make fclean`
    *Warning:* `make fclean` will prune all Docker volumes, networks, images, and forcefully remove the physical host directories (`/home/$(USER)/data`) using `sudo rm -rf`. This wipes the database and website completely.

## 4. Project Data Storage and Persistence
This project relies on **Bind Mounts** to achieve data persistence, ensuring that data outlives the ephemeral containers.
*   **Where is the data stored?** 
    The data is physically stored on the host machine at `/home/$(USER)/data`.
    *   MariaDB database files: `/home/$(USER)/data/mariadb`
    *   WordPress core and uploaded files: `/home/$(USER)/data/wordpress`
*   **How does it persist?**
    The `docker-compose.yml` uses the `driver_opts` feature under the `volumes` section to bind these specific host directories to the respective container directories (`/var/lib/mysql` and `/var/www/html`). When a container is destroyed, the Docker virtual filesystem layers are deleted, but the host directories remain untouched. Upon a new `make up`, the new containers simply re-attach to the existing data.