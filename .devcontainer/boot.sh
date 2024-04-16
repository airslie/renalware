bundle install
yarn install

sudo chown -R vscode:vscode /usr/local/bundle

sudo service postgresql start
sudo service memcached start

Create PostgreSQL users and databases
sudo su postgres -c "createuser --superuser vscode"
sudo su postgres -c "createdb -O vscode -E UTF8 -T template0 activerecord_unittest"
sudo su postgres -c "createdb -O vscode -E UTF8 -T template0 activerecord_unittest2"
