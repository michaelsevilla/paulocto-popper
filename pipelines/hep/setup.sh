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

set -ex

$SSH sudo chmod 777 -R $SRC
$SSH sudo chmod 777 -R /etc/ceph

echo "==> Cloning repository..."
$SSH git clone --recursive https://$1:$2@github.com/reza-nasirigerdeh/root.git $SRC/root

echo "==> Generating input file..."
$SSH $RUN -b -q .x \
  root/src/translate_offsets_to_baskets.cpp\(\"2AC36403-8E7E-E711-A599-02163E01366D.root\",\"\",\"full-path\",\"cmsdump.outerr\"\)

echo "==> Cleaning input file..."
$SSH grep -v "READ" $SRC/translated_baskets.txt > $SRC/branchListFile.txt
$SSH sed -i '1,2d' $SRC/branchListFile.txt
