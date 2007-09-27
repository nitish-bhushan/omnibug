#!/bin/bash

#
# Extension deployment script
#

# Get most current revision
PLACEHOLDER=ts
echo "Updating revision number"
echo `date` > ${PLACEHOLDER}
svn commit -m"Revision placeholder" ${PLACEHOLDER}
echo ""

APP=omnibug
MAJOR=0
MINOR=`svn info ${PLACEHOLDER} |grep ^Revision|awk '{ print $2 }'`

# update revision
echo -n "$0: incrementing version: old=$MINOR; "
MINOR=$((MINOR+1))
VER="${MAJOR}.${MINOR}"
echo "new=${MINOR}"
echo ""
cat install.rdf | sed "s/em:version>.*</em:version>${VER}</" > install.rdf

echo "Comitting updated install.rdf"
# Commit modified install to svn
svn commit -m"[$0] Incrementing revision for build" install.rdf
echo ""

cat update.rdf.tpl | sed "s/XXX/${VER}/g" > update.rdf
cp omnibug.xpi omnibug-${VER}.xpi

echo "Sending update.rdf and xpi to galactica"
scp update.rdf omnibug-${VER}.xpi rosssimpson@galactica.7mph.com:httpdocs/dev/
echo "Done."

