apt-get update && apt-get upgrade -y
apt-get install git screen make libpcre3 libpcre3-dev openssl libssl-dev linux-kernel-headers build-essential sysv-rc-conf -y
cd /usr/src/
git clone https://github.com/alibaba/tengine.git
cd tengine
./configure --prefix=/usr --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --http-client-body-temp-path=/var/tmp/nginx/client --http-proxy-temp-path=/var/tmp/nginx/proxy --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi --http-scgi-temp-path=/var/tmp/nginx/scgi --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --with-http_concat_module --with-http_sysguard_module --with-http_stub_status_module --with-ipv6 --with-http_sub_module
make
make install
mkdir /var/tmp/nginx
cd /etc/init.d
wget https://raw.githubusercontent.com/piwik-la/LEMP/master/nginx
chmod 775 /etc/init.d/nginx
alias chkconfig=sysv-rc-conf
sysv-rc-conf nginx on
chkconfig nginx on
service nginx restart

apt-get update
apt-get install -y redis-server php5-redis php5-memcached memcached php5-memcache
apt-get -y install mysql-server mysql-client
apt-get install -y php5-mysql php5-fpm php5-gd php5-cli

sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
sed -i "s/^;listen.owner = www-data/listen.owner = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.group = www-data/listen.group = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/^;listen.mode = 0660/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf

service nginx restart
service mysql restart
service php5-fpm restart

cd /usr/html
wget https://www.adminer.org/static/download/4.2.4/adminer-4.2.4-en.php
mv adminer-4.2.4-en.php dba.php
sudo mysql_secure_installation
