SRC="/mnt/disk/root"
RUN="docker run --rm -it \
      -w /root -v $SRC:/root \
      --entrypoint=root \
      rootproject/root-ubuntu16:snapshot"
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

echo "==> Cloning repository..."
git clone --recursive https://$1:$2@github.com/reza-nasirigerdeh/root.git $SRC/root || true
sudo chmod 777 $SRC/*
cd $SRC/root; git checkout 3b52abb; cd -

echo "==> Generating input file..."
$RUN -b -q .x \
  root/src/translate_accesses_to_baskets.cpp\(\"cmsdump.outerr\",\"CmsRun\",\"2AC36403-8E7E-E711-A599-02163E01366D.root\"\)

echo "==> Cleaning input file..."
grep "Basket" $SRC/basket_list.txt | awk -F ':' '{print $2}' > $SRC/basket_list_file.txt

# original
#$RUN -b -q .x root/src/read_baskets_from_file_hep_method.cpp\(\"/root/2AC36403-8E7E-E711-A599-02163E01366D.root\",\"/root/basket_list_file.txt\"\)
#$RUN -b -q .x root/src/write_baskets_to_files.cpp\(\"/root/2AC36403-8E7E-E711-A599-02163E01366D.root\",\"/root/namespace\"\)
#$RUN -b -q .x root/src/read_baskets_from_file_our_method.cpp\(\"/root/basket_list_file.txt\"\,\"/root/namespace\"\)
#
# new
#$RUN -b -q .x root/src/read_baskets_from_file_hep_method.cpp\(\"/root/20BE89F5-9F37-E711-8575-008CFAFC04AC.root\",\"/root/branchListFile_20.txt\"\)
#$RUN -b -q .x root/src/write_baskets_to_files.cpp\(\"/root/20BE89F5-9F37-E711-8575-008CFAFC04AC.root\",\"/root/namespace\"\)
#$RUN -b -q .x root/src/read_baskets_from_file_our_method.cpp\(\"/root/branchListFile_20.txt\"\,\"/root/namespace\"\)
