sudo add-apt-repository ppa:ondrej/php
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'
sudo add-apt-repository ppa:certbot/certbot
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
apt-get install -y php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-fpm php7.0-gd php7.0-json php7.0-mysql php7.0-readline php7.0-mbstring
apt-get -y install mariadb-server
sudo apt-get install certbot
certbot certonly --webroot -w /var/www/example.com -d example.com -d www.example.com

sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/^;listen.owner = www-data/listen.owner = www-data/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/^;listen.group = www-data/listen.group = www-data/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/^;listen.mode = 0660/listen.mode = 0666/" /etc/php/7.0/fpm/pool.d/www.conf

service nginx restart
service mysql restart
service php7.0-fpm restart

cd /usr/html
wget https://www.adminer.org/latest.php
mv *.php dba.php
sudo mysql_secure_installation
