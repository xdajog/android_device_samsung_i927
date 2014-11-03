#!/bin/sh
# ===================================================================
# ace - based this off cyanogenmod (team?)skyrocket extract-files.sh
# with some tweaks for the glide.  Script follows $VENDOR, $DEVICE
# and $OUTDIR.  Also instead of device-proprietary-files.txt, the
# script is configured to look for $DEVICE-proprietary-files.txt
# ===================================================================
VENDOR=samsung
DEVICE=glide
OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/$DEVICE-vendor-blobs.mk

(cat << EOF) > $MAKEFILE
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

# Prebuilt libraries that are needed to build open-source libraries

# ace - test mimicing the last "working" build setup, as this is called first technically
# Device-specific proprietary files
PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`wc -l $DEVICE-proprietary-files.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' $DEVICE-proprietary-files.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' $DEVICE-proprietary-files.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  echo "	$OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
done

(cat << EOF) > ../../../$OUTDIR/$DEVICE-vendor.mk
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

# ace - something missing here breaks build?  librs_jni off rip?
#   LiveWallpapers \\
#   LiveWallpapersPicker \\
#   MagicSmokeWallpapers \\
#   VisualizationWallpapers \\
# Live wallpaper packages and Themes
# PRODUCT_PACKAGES := \\
#    librs_jni

\$(call inherit-product, vendor/$VENDOR/$DEVICE/$DEVICE-vendor-blobs.mk)
EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh
BOARD_GPS_LIBRARIES := libloc_api

USE_CAMERA_STUB := false
EOF

