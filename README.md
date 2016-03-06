# Deployer
Allow to deploy several branches of a same repository to different paths on many servers.  
Example:  
serverX:/var/vhosts/branch1  
serverX:/var/vhosts/branch2  

## Usage
```bash
# performs basic tests (are conf files ok, are servers available via ssh ...)
deployer test
# push your code
deployer deploy
# debug mode, after push tentative deployer keep temporary files
deployer -d deploy
# re-activate previous release and backup the last deployed for debuging check
deployer rollback
# simulation mode : don't perform final commands on remote serveur, just show them
deployer -s rollback
# executes shell command on each server in each vhost (contextual var can be used : %deploy_to, %shared_path etc.)
deployer exec

```

## Configuration matrix
```yaml
#vhosts.yml
repository: git@github.com:korby/some-stuff.git
method: git clone
vhosts:
  aName:
    branch:oneversionofmystuff
    deploy_to: /var/www/somewhere/
    tasks:
      - tasks-common/prod-files-renaming
      - some/path/some-file-containing-bash-commands
  anotherName:
    branch:otherversionofmystuff
    deploy_to: /var/www/somewhere-else/
    tasks:
      - tasks-common/prod-files-renaming
      - some/path/some-file-containing-bash-commands
```
```yaml
#hosts.yml
hosts:
  prod1:
    host:web1.website.net
    user:root
  prod2:
    host:web2.website.net
    user:root
```

## How to use Deployer
On the very first step, **from the machine where you will execute Deployer**, you need to:  
* add local ssh rsa public key to your remote git repository settings (gitlab, github, bitbucket...)
* install local ssh rsa public key on all remote servers

1) Get it
```bash
git clone git@github.com:korby/deployer.git
```

2) make a directory somewhere from where you will execute Deployer.
```bash
mkdir beautifull-project
touch beautifull-project/vhosts.yml beautifull-project/hosts.yml
```


3) Create inside the 2 necessary configuration's files and fill them according matrix above
```bash
vi beautifull-project/vhosts.yml 
vi beautifull-project/hosts.yml
```

4) Run Deployer
```bash
cd beautifull-project
../deployer deploy
```

## Logs
Deployer logs all commands performed and their returns. Logs are in your project directory in "logs/"

## Tasks
Tasks are commands executed on remote servers. They must reside in text files (whithout shebang), all commands inside a file must end with ";"

A) Tasks common  
Usefull for many projects they are stored in Deployer itself. If you prefix a task with "tasks-common" Deployer will look for it inside its own directory "tasks-common".

B) Other tasks  
You can store them where you want, provided you indicate the path ine the yaml configuration file.

## WARNING
Deployer use a vhost directory architecture similar than Capistrano, ie :  
releases/  
shared/  
current (a symlink to > releases/xxx)  



