# Remove previous versions of Docker
apt-get remove docker docker-engine docker.io containerd runc

# Add the Docker repo and prereqs (and CIFS mounting utils)
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release cifs-utils winbind libnss-winbind

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify install
docker --version
docker-compose --version

# Install Certbot and grab SSL certificate
snap install core
snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone

# Attach network drives
mkdir /wrirdocker/mounts/Y
mkdir /wrirdocker/mounts/Z

echo -e 'username=rfrdj\npassword=wwr4trou\ndomain=wrir.local' > /.smbcredentials
echo "//192.168.200.16/shared /Y cifs credentials=/.smbcredentials,vers=1.0,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777 0 0 " >> /etc/fstab
echo "//192.168.200.23/z /Z cifs credentials=/.smbcredentials,vers=1.0,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777 0 0 " >> /etc/fstab

mount -a

# Compile and launch WRIR stack
docker-compose up -d .

echo "All done!"