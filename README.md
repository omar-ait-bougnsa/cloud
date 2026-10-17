# Cloud-1

Deploys a WordPress site (nginx + php-fpm + MariaDB + phpMyAdmin, each in its own
container) to a remote server with Ansible. The site gets HTTPS from Let's Encrypt and a
DuckDNS domain.

## Requirements

**On your machine**

- Ansible
- Collections: `ansible-galaxy collection install community.docker community.general`
- SSH access to the server

**On the server**

- Ubuntu, with a user that can `sudo`
- Ports 22, 80 and 443 open in the cloud provider's firewall

## Configuration

1. **Server**: edit `inventory/inventory.ini`:

   ```ini
   [webservers]
   server1 ansible_host=<SERVER_IP> ansible_user=<SSH_USER> duckdns_subdomain=<SUBDOMAIN>
   ```

   To deploy to several servers, add one line per server, each with its own subdomain.

2. **Settings** (not secret): `vars/cloud1.yml`

3. **Secrets**: `vars/vault.yml` is encrypted with Ansible Vault. Edit it with:

   ```bash
   ansible-vault edit vars/vault.yml
   ```

   It must define:

   | Variable | Used for |
   |---|---|
   | `vault_duckdns_token` | DuckDNS API token |
   | `db_root_password` | MariaDB root password |
   | `wordpress_db_password` | WordPress database user password |
   | `wp_admin_password` | WordPress admin password |
   | `user_password` | WordPress author user password |

## Run

From the project root:

```bash
ansible-playbook playbooks/playbook.yml
```

`ansible.cfg` sets the inventory and asks for the vault password.

The site is then available at `https://<SUBDOMAIN>.duckdns.org`, and phpMyAdmin at
`https://<SUBDOMAIN>.duckdns.org/phpmyadmin/`.

The playbook is idempotent, so you can run it again at any time.

## Useful commands on the server

```bash
cd /opt/app
docker compose ps                  # list containers
docker compose restart wordpress   # restart one container
docker compose up -d               # start all containers
docker volume ls                   # list data volumes
sudo ufw status                    # firewall rules
```
