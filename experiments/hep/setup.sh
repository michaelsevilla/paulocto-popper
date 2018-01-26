
docker run --rm -it   -v `pwd`:/root   -w /root   --entrypoint=root   rootproject/root-ubuntu16   -b /root/2AC36403-8E7E-E711-A599-02163E01366D.root

.x root/src/translate_offsets_to_baskets.cpp("./2AC36403-8E7E-E711-A599-02163E01366D.root", "", "full-path", "./cmsdump.outerr")
grep  -v "READ" translated_baskets.txt > branchListFile.txt
sed -i '1,2d' branchListFile.txt

# setup ceph: https://github.com/michaelsevilla/cudele-popper/blob/master/experiments/cudele-mergescale/vars.yml
