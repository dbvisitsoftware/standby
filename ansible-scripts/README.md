# Description
Scripts under this repository can be used to install Dbvisit software using Ansible
Playbook installs Dbvagent process on all machines
Control Center is installed on the last machine defined in the inventory

Processes will listen on hostnames defined in the inventory file on ports 7890 (dbvagentmanager) resp. 4433,533 (Central Console)

# Howto
  ## Install Community Module for Ansible for Windows installation
  * ```ansible-galaxy collection install community.windows```
  ## Before running playbook:
  * download Dbvisit software using provided link during registration to Dbvisit portal: https://dbvisit.com/upgrade
  * Edit file of variables - `install_dbvisit_vars_<OS>.yml`, mainly variable: `installation_file_local` to point to the downloaded Dbvisit installation file.
  * Change variable - `webserver_address` to hostname of the machine, where Central Console should be installed
  * Prepare inventory for ansible to connect to target machines
  * Check, if machines in inventory are reachable: `ansible -i inventory.yml all -m ping -v`

## Running Playbook
  * run the playbook using following command:
    ```
    ansible-playbook -i inventory.yml install_dbvisit_linux.yml
    ```
    
