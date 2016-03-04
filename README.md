# deployer
Allow to deploy several branches of a same repository in different path on each server/.  
Example:  
serverX:/var/vhosts/branch1  
serverX:/var/vhosts/branch2  


```yaml
#vhosts.yml
repository: git@github.com:korby/some-stuff.git
method: git clone
vhosts:
  aName:
    branch:oneversionofmystuff
    deploy_to: /var/www/somewhere/
    tasks:
      - actions-templates/prod-files-renaming
      - actions-templates/test
  anotherName:
    branch:otherversionofmystuff
    deploy_to: /var/www/somewhere-else/
    tasks:
      - actions-templates/prod-files-renaming
      - actions-templates/test
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
