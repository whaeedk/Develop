#!/bin/bash
# Website status check
# Website
WEBSITE="http://www.google.com"
# Send mail in case of failure to EMAIL_ADDRESS
EMAIL_ADDRESS="Ops@test.com"
# Temporary dir
TEMPDIR="/tmp"

function website_test {
  response=$(curl --write-out %{http_code} --silent --output /dev/null $1)
  filename=$( echo $1 | cut -f1 -d"/" )
  if [ "$QUIET" = false ] ; then echo -n "$p "; fi

  if [ $response -eq 200 ] ; then
    # website is UP!
    if [ "$QUIET" = false ] ; then
      echo -n "$response "; echo -e "\e[32m[ok]\e[0m"
    fi
    # remove .temp file if exist
    if [ -f $TEMPDIR/$filename ]; then rm -f $TEMPDIR/$filename; fi
  else
    # website is DOWN!
    if [ "$QUIET" = false ] ; then echo -n "$response "; echo -e "\e[31m[DOWN]\e[0m"; fi
    if [ ! -f $TEMPDIR/$filename ]; then
        while read e; do
            # using mailx command
            echo "$p WEBSITE IS DOWN" | mailx -s "$1 WEBSITE DOWN ( $response )" $e
            # using mail command
            #mail -s "$p WEBSITE IS DOWN" "$EMAIL"
        done < $EMAILADDRESS
        echo > $TEMPDIR/$filename
    fi
  fi
}

# main loop
while read p; do
  test $p
done < $WEBSITE
