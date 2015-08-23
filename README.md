# Disclaimer

This is a preliminary, non-official set of instructions to deploy a [CBRAIN](http://cbrain.mcgill.ca) Portal and Bourreau using Docker. Use at your own risks, and contact [tristan.glatard@mcgill.ca](mailto:tristan.glatard@mcgill.ca) in case of issues. 

# Database

Create a database, for instance:  
``` 
docker run --name mariadb-server -e MYSQL_ROOT_PASSWORD=mysqlrootpwd -e MYSQL_USER=cbrain -e MYSQL_PASSWORD=mysqlpwd -e MYSQL_DATABASE=cbrain -d mariadb
```
(change usernames and passwords)

# CBRAIN Portal

## Startup and configuration 

Start the ```cbrain-base``` container as follows:
```
docker run -P -i -t --name cbrain-portal --link mariadb-server:mysql glatard/cbrain-base /bin/bash
```

The following configuration steps are adapted from Section 1 of
[https://github.com/aces/cbrain/wiki/BrainPortal-Setup](https://github.com/aces/cbrain/wiki/BrainPortal-Setup).

```
cd $HOME/cbrain/BrainPortal/config
cp database.yml.TEMPLATE database.yml
```
Edit file ```database.yml```. The development section should look like this (adjust the mysql host, database, user and password according to your configuration)
```
development:
  adapter: mysql2
  host: mysql
  database: cbrain
  username: cbrain
  password: mysqlpwd
  encoding: utf8
```

```
cd initializers
cp config_portal.rb.TEMPLATE config_portal.rb
```
Edit config_portal.rb: there is a single assignment for a constant named CBRAIN_RAILS_APP_NAME. Give the application a simple name, such as 'BrainPortal' or 'MyDev'.

```
cd $HOME/cbrain/BrainPortal
rake db:schema:load RAILS_ENV=development
rake db:migrate
rake db:seed RAILS_ENV=development
```
Write down the admin password.
```
rake db:sanity:check RAILS_ENV=development
```

```
rvm use 2.2.1
bundle install
```
(these last 2 steps will be included in the Dockerfile).

Finally, start the portal:
```
rails server thin -e development -p 3000
```

## Connection to the portal 

The IP of the Docker container is the one of the ```docker0``` network interface (see ```ifconfig -a```).

The port of the CBRAIN portal is given by ```docker port```:
```
docker port cbrain-portal 3000
```

You should now be able to login to the CBRAIN portal using username ```admin``` and the password printed during the configuration procedure. For the next steps, including DataProvider and Bourreau installation and configuration, follow the instructions at [https://github.com/aces/cbrain/wiki/BrainPortal-Setup#interface](https://github.com/aces/cbrain/wiki/BrainPortal-Setup#interface), starting from Section 2.i.

# CBRAIN Bourreau

Documentation to be done, based on the following steps: 

1. start a ```cbrain-base``` container, name it ```cbrain-bourreau```.
2. in ```cbrain-bourreau```, start ```sshd``` (should be added to the Dockerfile).
3. Follow the instructions at [https://github.com/aces/cbrain/wiki/Bourreau-Setup](https://github.com/aces/cbrain/wiki/Bourreau-Setup)
