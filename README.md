# deployer

```yaml
#vhosts.yml
repository: git@github.com:korby/some-stuff.git
method: git clone
vhosts:
  belair:
    branch:oneversionofmystuff
    deploy_to: /var/www/somewhere/
    tasks:
      - actions-templates/prod-files-renaming
      - actions-templates/test
  chersancerre:
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
```
