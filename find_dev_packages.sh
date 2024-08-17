#!/bin/bash

OUTFILE=gen_package_list.txt
TMPFILE=tmp_file.txt
rm -f $OUTFILE
rm -f $TMPFILE

# First fetch libboost, we have all of it and it doesn't match the pattern recognition
# Same with x11 packages
for i in $(apt list --installed | grep boost | grep arm64 | grep -v dev | cut -f1 -d"/") $(apt list --installed | grep libx | grep arm64 | grep -v dev | cut -f1 -d"/"); do 
  RET=$(apt-get download --print-uris $i | cut -f2 -d\')
  echo "::$RET::"
  echo "$RET" >> $TMPFILE
done

for i in $(apt list --installed | grep dev | grep arm64 | cut -f1 -d"/"); do 
  NON_DEV=${i%-dev}
  RET=$(apt-get download --print-uris $NON_DEV | cut -f2 -d\')
  #
  # Attempt to find non dev package automatically
  #
  if [[ -z "$RET" ]]; then
    RET=$(ls "/lib/$NON_DEV*.so.*")
    if [[ -z "$RET" ]]; then
      RET=$(ls /lib/aarch64-linux-gnu/$NON_DEV*.so.* | cut -f1 -d" ")
      if [[ -z "$RET" ]]; then
        RET=$(ls /usr/lib/$NON_DEV*.so.* | cut -f1 -d" ")
      fi

      if [[ ! -z "$RET" ]]; then
        REM=".so."
	# Hopefully the first ls entry is closest to the package name
	FIRST=${RET//"$REM"/}
	# Strip path from front and any extra.'s from back
	PKG=$(echo "${FIRST##*/}" | cut -f1 -d".")
	RET=$(apt-get download --print-uris $PKG | cut -f2 -d\')
	echo "::$RET::"
      fi
    fi
  fi

  echo "$RET" >> $TMPFILE

  RET=$(apt-get download --print-uris $i | cut -f2 -d\')
  echo "::$RET::"
  echo "$RET" >> $TMPFILE
done

cat $TMPFILE | uniq | sed -u 's:https:http:g' | sed -u 's:mirrors.tuna.tsinghua.edu.cn:ports.ubuntu.com:g' | sed -u '/^$/d'| tee $OUTFILE
