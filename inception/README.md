*This project has been created as part of the 42 curriculum by musyilma.*

# Inception

## Description
The Inception project is a deep dive into system administration, virtualization, and container orchestration. The main goal is to broaden our knowledge of system deployment by setting up a small infrastructure composed of different services under specific rules. 

Instead of using pre-configured Docker images, this project requires building custom images from scratch for each service (NGINX, WordPress + php-fpm, and MariaDB) using Dockerfiles. These containers are then orchestrated using Docker Compose to work seamlessly together in an isolated environment.

### Use of Docker & Design Choices
Docker is utilized to containerize each service, ensuring that they run in isolated environments using Linux kernel features like `namespaces` and `cgroups`. The project follows the "One service per container" philosophy. 
Key design choices include:
*   **PID 1 Management:** Ensuring the main process (e.g., `nginx`, `php-fpm`, `mariadbd`) runs as PID 1 to handle signals properly and avoid defunct (zombie) processes using `exec` in entrypoint scripts.
*   **OverlayFS Utilization:** Optimizing Dockerfile instructions to minimize the number of read-only layers.
*   **Least Privilege Principle:** Exposing only necessary ports (e.g., strictly 443 for NGINX) and restricting inter-container communication to an internal Docker network.

### Technical Comparisons

*   **Virtual Machines vs Docker:** Virtual Machines rely on a hypervisor to emulate hardware, running a full guest Operating System for each instance, which is resource-heavy and slow to boot. Docker, however, uses OS-level virtualization. Containers share the host's Linux kernel and only contain the application and its dependencies, making them lightweight, ephemeral, and capable of booting in seconds.
*   **Secrets vs Environment Variables:** Environment variables (`.env`) are often visible to anyone with access to the container's shell (`env` command) or the Docker daemon. Docker Secrets, on the other hand, mount sensitive data (like passwords) securely into a temporary in-memory filesystem (`tmpfs` at `/run/secrets/`). They are never written to the disk's overlay layers, providing a much higher level of security.
*   **Docker Network vs Host Network:** Using the Host network removes network isolation, tying the container directly to the host's network interfaces and ports. Using a custom Docker Network (Bridge) creates an isolated, virtualized internal network. Containers can securely resolve each other via DNS (container names) without exposing their internal ports to the outside world.
*   **Docker Volumes vs Bind Mounts:** Docker Volumes are entirely managed by the Docker daemon and stored in a protected area of the host filesystem (usually `/var/lib/docker/volumes`), making them portable and independent of the host OS structure. Bind Mounts map a specific, existing path on the host machine (e.g., `/home/musyilma/data`) directly into the container. While bind mounts provide easy access to files from the host, they are dependent on the host's directory structure and permissions.

## Instructions

### Prerequisites
*   Docker and Docker Compose installed on your system.
*   Make utility.
*   Local domain routing: Ensure `musyilma.42.fr` points to `127.0.0.1` in your `/etc/hosts` file.

### Setup & Execution
1.  **Clone the repository:** Navigate to the root of the project.
2.  **Set up Secrets:** Create a `secrets/` directory at the root level containing `db_password.txt`, `db_root_password.txt`, and `credentials.txt` with your desired secure passwords.
3.  **Build and Run:** Use the provided Makefile to build the images, create necessary host directories, and start the infrastructure in detached mode:
    ```bash
    make all
    ```
4.  **Access:** Open your web browser and navigate to `https://musyilma.42.fr`.

### Maintenance Commands
*   To stop the containers: `make down`
*   To stop and remove containers/networks: `make clean`
*   To completely wipe the system including persistent data volumes: `make fclean`

## Resources
*   [Docker Official Documentation](https://docs.docker.com/)
*   [NGINX Documentation](https://nginx.org/en/docs/)
*   [MariaDB Server Documentation](https://mariadb.com/kb/en/documentation/)
*   [WordPress Developer Resources](https://developer.wordpress.org/)
*   **AI Usage:** Artificial Intelligence (Gemini) was utilized during the development of this project primarily for theoretical brainstorming and debugging. It was used to discuss internal Linux kernel mechanics (such as the `chroot`, `namespaces`, `cgroups` trinity), explore the architecture of OverlayFS and `containerd` snapshotters, and identify syntax errors in Bash shell scripting (specifically regarding variable assignments and whitespace rules).