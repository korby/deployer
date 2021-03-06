# Deployer
Allows to deploy several branches of a same repository onto their own paths.  
For example, on the server vhost area, it will look like that:  
/var/vhosts/branchX  
/var/vhosts/branchY  
/var/vhosts/branchZ  

Of course many target servers can be defined.

## Install   

### On debian's like systems  
```bash
wget --no-check-certificate https://github.com/korby/deployer/blob/master/deployer.deb?raw=true -O deployer.deb
dpkg -i deployer.deb
```

### On Macosx and other unix systems  
```bash
git clone git@github.com:korby/deployer.git
cd deployer
ln -s `pwd`/deployer.sh /usr/bin/deployer
```
If you have bash_completion installed on your system :
```bash
cp debian_package/etc/bash_completion.d/deployer /my/system/path/to/etc/bash_completion.d/
source /my/system/path/to/etc/bash_completion.d/deployer
```

## Usage
```bash
# create example config files in the current directory
deployer init
# performs basic tests (are conf files ok, are servers available via ssh ...)
deployer test
# show tasks contents of each vhost
deployer showtasks
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
email: me@domain.tld
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
    port: 222
```
```yaml
#vars.yml
vars:
  composer: /var/www/composer.phar
  myvar: myvalue
```
## How to use Deployer
As very first step, **from the machine where you will execute Deployer**, you need to:  
* add local ssh rsa public key to your remote git repository settings (gitlab, github, bitbucket...)
* install local ssh rsa public key on all remote servers

Then:  


1) Make a directory somewhere from where you will execute Deployer.
```bash
mkdir beautifull-project
touch beautifull-project/vhosts.yml beautifull-project/hosts.yml
```


2) Create inside the 3 necessary configuration's files and fill them according to the matrix above
```bash
cd beautifull-project
deployer init
vi vhosts.yml
vi hosts.yml
vi vars.yml
```

4) Run Deployer
```bash
deployer deploy
```

## Logs
Deployer logs all commands performed and their returns. Logs are in your project directory in "logs/"

## Tasks
Tasks are commands executed on remote servers. They must reside in text files (whithout shebang) : one command per line, each line ended with ";"

A) Tasks common  
Usefull for many projects they are stored in Deployer itself. If you prefix a task with "tasks-common" Deployer will look for it inside its own directory "tasks-common".

B) Other tasks  
You can store them where you want, provided you indicate the path in the yaml configuration file.

## Vars
Add all vars you need in the vars.yml. You can get and use the corresponding value anywhere in a task using that pattern : %myvar

## WARNING
Deployer use a vhost directory architecture similar to Capistrano, ie :  
releases/  
shared/  
current (a symlink to > releases/xxx)  

## For developers
Useful .git/hooks/pre-commit to add:  
```bash
./build.sh
git add deployer.deb
cd test
./test.sh
```
