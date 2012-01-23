#!/bin/sh
cd /home/muschl/OpenELEC/OpenELEC.tv.Muschl

arch=x86_64
project=Fusion
email=PE-Builder@gmx.de
#master branch select only 1
#branch=OpenELEC
#pvr branch select only 1
branch=OpenELEC_PVR

date1=$(date +%s)
BRANCH=$branch PROJECT=$project ARCH=$arch make release
date2=$(date +%s)
date3=$(date)
if [ -s target/$branch-$project.$arch*.bz2 ]; then
echo 'Date/Time build finished:' $date3 > /storage/other/build/buildstatus.txt
echo 'Date/Time finished: ' $date3 >> /storage/other/build/buildlog.txt
echo 'Time for '$project $arch' build:' $((($date2-$date1)/(60))) minutes, $((($date2-$date1) % 60)) seconds >> /storage/other/build/buildlog.txt
echo 'Time for '$project $arch' build:' $((($date2-$date1)/(60))) minutes, $((($date2-$date1) % 60)) seconds >> /storage/other/build/buildstatus.txt
FILESIZE=$(stat --printf="%s" target/$branch-$project.$arch*.bz2)
echo 'Total File Size: ' $FILESIZE bytes >> /storage/other/build/buildstatus.txt
$project.$arch*.bz2 -d "Openelec Builds"
FNAME=$(stat --printf="%n" target/$branch-$project.$arch*.bz2)
REV=$(echo $FNAME | awk '{print substr($0, length($0) - 12,5)}')
mailx -s "$branch $project $arch Build $REV complete" $email < /storage/other/build/buildstatus.txt
rm -f target/$branch-$project.$arch*.*
rm -rf build.$branch-$project.$arch-devel
fi
