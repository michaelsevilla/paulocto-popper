SRC="/mnt/disk/root"

if [ -z $1 ]; then
  echo "Please give git username in \$1"
  exit 1
fi

if [ -z $2 ]; then
  echo "Please give git password in \$2"
  exit 1
fi

if [ -z $3 ]; then
  echo "Please tell me what node the client is on in \$3"
  exit 1
fi

set -ex

echo "==> Cloning repository..."
ssh $3 sudo mkdir -p $SRC
ssh $3 sudo chmod 777 $SRC
ssh $3 git clone --recursive https://$1:$2@github.com/reza-nasirigerdeh/root.git $SRC/root
ssh $3 "cd $SRC/root; git checkout 3b52abb"
