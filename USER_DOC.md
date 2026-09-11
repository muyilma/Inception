# User Documentation

This document explains how an end user or system administrator can interact with the Inception project infrastructure in a simple and clear manner.

## 1. Services Provided by the Stack
This infrastructure provides a fully functional, secure web environment composed of three main services:
*   **NGINX:** The web server. It acts as the secure front door to the website, handling all incoming HTTP requests and forcing secure TLS (HTTPS) connections.
*   **WordPress:** The Content Management System (CMS). This is the backend engine that generates the website content, manages posts, and handles user interactions.
*   **MariaDB:** The database server. It securely stores all the persistent data for the WordPress site, such as user accounts, posts, configurations, and site metadata.

## 2. Starting and Stopping the Project
To manage the lifecycle of the project, use the provided Makefile at the root of the repository:
*   **To start the project:** Open a terminal in the project root and run:
    ```bash
    make up
    ```
    *(Note: If this is the first time, you should run `make all` to build the images first).*
*   **To stop the project:** Run the following command. This will safely stop the containers without losing your data:
    ```bash
    make down
    ```

## 3. Accessing the Website and Administration Panel
*   **Main Website:** Open your web browser and navigate to exactly `https://musyilma.42.fr`. Note that your browser may show a self-signed certificate warning; you can safely proceed.
*   **Administration Panel:** To log in as an administrator or author, navigate to `https://musyilma.42.fr/wp-admin`.
*   Ensure your machine's /etc/hosts file (or equivalent) correctly resolves to musyilma.42.fr.

## 4. Locating and Managing Credentials
For security reasons, passwords are not stored in the code or environment variables. 
*   All sensitive credentials must be managed inside the `secrets/` directory located at the root of the project.
*   To change a password before deployment, modify the text files inside this directory (e.g., `db_password.txt`, `db_root_password.txt`, `credentials.txt`). 
*   Non-sensitive configuration (database name, usernames, emails) is stored in srcs/.env.

## 5. Checking Service Status and Deep Debugging

To ensure the infrastructure is robust and all services are running correctly, system administrators can use the following commands from the root directory. This section covers everything from basic health checks to deep architectural debugging.

### A. Basic Container Status & Health
To see an overview of all running containers, their uptime, and exposed ports:
```bash
docker ps -a
```
*Expected Output:* You should see exactly three containers (`nginx`, `wordpress`, `mariadb`). Their status must be **"Up"**. 
*   If a container status says **"Restarting"**, it indicates a fatal error (e.g., misconfigured credentials or a crashed PID 1 process) causing it to crash continuously.
*   If a container is **"Exited"**, check the logs immediately to see why it stopped.

### B. Master Log Management (The Most Critical Step)
Logs are the single source of truth when a service fails. 

*   **Global Real-Time Logs:** To stream logs for the entire stack at once:
    ```bash
    docker compose -f srcs/docker-compose.yml logs -f
    ```
*   **Targeted Service Logs:** To view logs for a specific service (useful for isolating issues):
    ```bash
    docker logs -f nginx
    docker logs -f wordpress
    docker logs -f mariadb
    ```
*   **Internal Application Logs:** Sometimes standard Docker logs don't catch everything. You can check the specific service logs directly inside the containers:
    *   *NGINX Errors:* `docker exec -it nginx cat /var/log/nginx/error.log`
    *   *PHP-FPM (WordPress) Errors:* `docker exec -it wordpress cat /var/log/php8.2-fpm.log` *(adjust version if necessary)*.

### C. Inspecting the Inside of a Container (PID 1 Check)
To execute commands directly inside a running container and verify the environment:
```bash
docker exec -it <container_name> /bin/bash
```
*(Note: If `/bin/bash` is not available, use `/bin/sh` or `sh`).*

*   **Verify PID 1:** Once inside, run `ps aux` or `top`. The main service (`nginx`, `php-fpm`, or `mariadbd`) **must** be PID 1. If a shell like `/bin/sh` or `bash` is PID 1, the container architecture is flawed and will not handle stop signals gracefully.
*   **Verify Secrets:** Run `cat /run/secrets/db_password.txt` to ensure secrets are securely mounted in the ephemeral `tmpfs` memory.

### D. Network Isolation Verification
To verify that all containers are securely communicating over the custom isolated bridge network (and not the host network):
```bash
docker network ls
docker network inspect inception-network
```
*Expected Output:* The `inspect` command will output a JSON array showing all three containers securely attached to this virtual switch with their assigned internal IP addresses.

### E. Volume & Data Persistence Checks
To ensure your databases and website files are safely written to the host machine and outliving the container lifecycle:

1.  Check the physical host directories:
    ```bash
    ls -la /home/musyilma/data/mariadb
    ls -la /home/musyilma/data/wordpress
    ```
2.  To inspect how Docker is handling the bind mounts under the hood:
    ```bash
    docker volume inspect mariadb_data
    ```

### F. System Resource Usage
To monitor how much CPU, Memory, and Network Bandwidth the stack is consuming:
```bash
docker stats
```
This live dashboard confirms that the custom containers are properly optimized and not suffering from memory leaks.