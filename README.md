# Deployer
Allow to deploy several branches of a same repository in different path on each server/.  
Example:  
serverX:/var/vhosts/branch1  
serverX:/var/vhosts/branch2  

## Usage
```bash
# performs basic tests against yours servers (available via ssh etc.)
deploy test
# push your code
deploy deploy
# debug mode, after push tentative deployer keep temporary files
deploy -d deploy
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
``

## How to use Deployer
1) Get it
```
git clone git@github.com:korby/deployer.git
```

2) make a directory somewhere from where you will execute Deployer.
```
mkdir beautifull-project
touch beautifull-project/vhosts.yml beautifull-project/hosts.yml
```


3) Create inside the 2 necessary configuration's files and fille them according matrix above
```
vi beautifull-project/vhosts.yml 
vi beautifull-project/hosts.yml
```

4) Run Deployer
```
cd beautifull-project
../deployer deploy
```


