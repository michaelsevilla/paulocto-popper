SRC="/mnt/disk/root"
RUN="docker run --rm -it \
      -w /root \
      -v `pwd`:/scripts \
      -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16 -b -q"
INPUT="$SRC/2AC36403-8E7E-E711-A599-02163E01366D.root"
TRACE="$SRC/cmsdump.outerr"

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
ssh $3 sudo mkdir -p $SRC || true
ssh $3 git clone --recursive https://$1:$2@github.com/reza-nasirigerdeh/root.git $SRC/root
