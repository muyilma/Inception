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

## 4. Locating and Managing Credentials
For security reasons, passwords are not stored in the code or environment variables. 
*   All sensitive credentials must be managed inside the `secrets/` directory located at the root of the project.
*   To change a password before deployment, modify the text files inside this directory (e.g., `db_password.txt`, `db_root_password.txt`, `credentials.txt`). 
*   **Note:** Passwords must be written as plain text on a single line within these files. Do not use formats like `PASSWORD=123`.

## 5. Checking Service Status
To verify that all services are running correctly, open a terminal and run:
```bash
docker ps