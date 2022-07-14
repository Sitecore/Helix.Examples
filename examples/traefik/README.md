# Running Multiple Sitecore Docker-Compose Environments with Traefik

If you need to run multiple Sitecore docker-compose based environments at the same time you need to disable Traefik container on each of them and run a stand-alone Traefik docker-compose based instance.

**DISCALIMER:** **This approach has been tested on Windows 10 with Docker Desktop version 4.10.0 (82025). You might run into issues with older Docker versions!**

## Sitecore docker-compose configuration prerequisites

Your Sitecore docker-compose instances should not have clashes on things that must be unique, for example, **port mappings** and **Traefik route names**.

### Port mappings

Containers port mappings should be the same - you can remove the port mappings or change the port numbers.

Typically, you just need to remove MSSQL and Solr containers port mappings.

***Note: These changes have been already applied to this "Helix.Examples" code base.***

### Traefik router names

Each container must have a unique router name.

Traefik routers are configured in `labels:` sections of each container configuration, in docker-compose file. For example:

    - "traefik.http.routers.cm-secure.entrypoints=websecure"
    - "traefik.http.routers.cm-secure.rule=Host(`${CM_HOST}`)"
    - "traefik.http.routers.cm-secure.tls=true"
    - "traefik.http.routers.cm-secure.middlewares=force-STS-Header"

 where `cm-secure` is a router name. You can simply make it be unique by injecting the environment variable to its name: `cm-${COMPOSE_PROJECT_NAME}-secure`

    - "traefik.http.routers.cm-${COMPOSE_PROJECT_NAME}-secure.entrypoints=websecure"
    - "traefik.http.routers.cm-${COMPOSE_PROJECT_NAME}-secure.rule=Host(`${CM_HOST}`)"
    - "traefik.http.routers.cm-${COMPOSE_PROJECT_NAME}-secure.tls=true"
    - "traefik.http.routers.cm-${COMPOSE_PROJECT_NAME}-secure.middlewares=force-STS-Header"

***Note: These changes have been already applied to this "Helix.Examples" code base.***

## Configure Traefik

You need to disable Traefik containers on your Sitecore docker-compose files and run Traefik from its own stand-alone docker-compose.

### Disabling Sitecore docker-compose Traefik containers

For each Sitecore environment open `docker-compose.override.yml`, find or add `traefik` container configuration and set `scale: 0`

    traefik:
        scale: 0

These are "Helix.Examples" `docker-compose.override.yml` files that **you should** consider updating accordingly:

- **[helix-basic-aspnetcore\docker-compose.override.yml](..\helix-basic-aspnetcore\docker-compose.override.yml)**
- **[helix-basic-nextjs\docker-compose.override.yml](..\helix-basic-nextjs\docker-compose.override.yml)**
- **[helix-basic-tds\docker-compose.override.yml](..\helix-basic-tds\docker-compose.override.yml)**
- **[helix-basic-tds-consolidated\docker-compose.override.yml](..\helix-basic-tds-consolidated\docker-compose.override.yml)**
- **[helix-basic-unicorn\docker-compose.override.yml](..\helix-basic-unicorn\docker-compose.override.yml)**

### Configuring Traefik stand-alone docker-compose

The following example in this `README.md` demonstrates how to run these three "Helix.Examples" environments simultaneously:

- **helix-basic-aspnetcore**
- **helix-basic-nextjs**
- **helix-basic-unicorn**

You can use it to understand the approach and then adjust it to your needs.

#### Reference SSL Certificates

Mount to the certificate contained directories to Traefik container in **[docker-compose.override.yml](.\docker-compose.override.yml)** **(The file already contains the changes from the code example below)**

    traefik:
      volumes:
        - ../helix-basic-aspnetcore/docker/traefik/certs:C:/etc/traefik/certs/helix-basic-aspnetcore
        - ../helix-basic-nextjs/docker/traefik/certs:C:/etc/traefik/certs/helix-basic-nextjs
        - ../helix-basic-unicorn/docker/traefik/certs:C:/etc/traefik/certs/helix-basic-unicorn

**ATTENTION !!!** Each certificate source directory is mounted into its own sub-directory, e.g.: "C:/etc/traefik/certs/**helix-basic-aspnetcore**"

Reference the mounted directory contained certificate files from **[certs_config.yaml](.\config\dynamic\certs_config.yaml)** **(The file already contains the changes from the code example below)**

    tls:
      certificates:
        - certFile: C:\etc\traefik\certs\helix-basic-aspnetcore\_wildcard.basic-company-aspnetcore.localhost.pem
        keyFile: C:\etc\traefik\certs\helix-basic-aspnetcore\_wildcard.basic-company-aspnetcore.localhost-key.pem
        - certFile: C:\etc\traefik\certs\helix-basic-nextjs\_wildcard.basic-company-nextjs.localhost.pem
        keyFile: C:\etc\traefik\certs\helix-basic-nextjs\_wildcard.basic-company-nextjs.localhost-key.pem
        - certFile: C:\etc\traefik\certs\helix-basic-unicorn\_wildcard.basic-company-unicorn.localhost.pem
        keyFile: C:\etc\traefik\certs\helix-basic-unicorn\_wildcard.basic-company-unicorn.localhost-key.pem   

#### Register Traefik on Sitecore docker-compose networks

Each Sitecore docker-compose creates a default network automatically which is named: `<docker-compose-project-name>_default`.

`<docker-compose-project-name>` is defined by `.env` file contained environment variable `COMPOSE_PROJECT_NAME`, otherwise by the parent directory name of the `docker-compose.yml` file.

This how you know upfront the network names and add them to the `traefik` container configuration in **[docker-compose.override.yml](.\docker-compose.override.yml)** **(The file already contains the changes from the code example below)**

    traefik:
      networks:
        - basic-company-aspnetcore_default
        - basic-company-nextjs_default
        - basic-company-unicorn_default

Then, you also need to register these **external** networks in the Traefik's **[docker-compose.override.yml](.\docker-compose.override.yml)** **(The file already contains the changes from the code example below)**

    networks:
      basic-company-aspnetcore_default:
        name: basic-company-aspnetcore_default
        external: true
      basic-company-nextjs_default:
        name: basic-company-nextjs_default
        external: true
       basic-company-unicorn_default:
         name: basic-company-unicorn_default
         external: true

## Starting Sitecore Environments

- Start each Sitecore environment as usual, for example, running its own : `./up.ps1` or `docker-compose up -d`.
- Start Traefik by running [./up.ps1](./up.ps1)
