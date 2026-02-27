#!/usr/bin/env sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls -ld "$PRG"
    link=$(expr "$PRG" : '.*-> \(.*\)$')
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=$(dirname "$PRG")"/$link"
    fi
done
SAVED="$(cd -P "$(dirname "$PRG")" >/dev/null 2>&1 && pwd)"
cd "$SAVED" >/dev/null 2>&1
APP_HOME="$(cd -P "$(dirname "$0")" >/dev/null 2>&1 && pwd)"
cd "$APP_HOME" >/dev/null 2>&1
APP_HOME="$(pwd)"
cd "$SAVED" >/dev/null 2>&1
CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
    fi
else
    JAVACMD="java"
    if ! type java >/dev/null 2>&1
    then
        die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH."
    fi
fi

# Increase the maximum file descriptors if we can.
if ! "$cygwin" && ! "$msys" ; then
    MAX_FD_LIMIT=$(ulimit -H -n)
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD_LIMIT" != "unlimited" ] ; then
            ulimit -n $MAX_FD_LIMIT
        fi
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if $darwin; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\""
fi

# For Cygwin or MSYS, switch paths to Windows format before running java
if "$cygwin" || "$msys" ; then
    APP_HOME=$(cygpath --path --mixed "$APP_HOME")
    CLASSPATH=$(cygpath --path --mixed "$CLASSPATH")
    JAVACMD=$(cygpath --windows "$JAVACMD")
    # We build the pattern for arguments to be converted via cygpath
    ROOTDIRSRAW=$(find -L / -maxdepth 3 -type d -name .gradle 2>/dev/null)
    SEP=""
    for dir in $ROOTDIRSRAW ; do
        ROOTDIRS="$ROOTDIRS$SEP$dir"
        SEP="|"
    done
    OURCYGPATTERN="(^($ROOTDIRS))"
    TOPIT="$$"
    ls -ld "$APP_HOME" 2>/dev/null |
    sed 's/__[0-9.]*=//g' |
    sed 's|^[^/]*/|/|' |
    sed "s|$OURCYGPATTERN|cygpath --windows '$dir'|g;" |
    tr '\n' ' ' |
    sed 's/[^-[:alnum:]=_.\/]/ /g'
    export -p |
    grep -v '^\(PWD\|BASEDIR\|CDPATH\)'
    export GRADLE_HOME=$(cygpath --windows "$GRADLE_HOME")
    [ -n "$JAVA_HOME" ] &&
    export JAVA_HOME=$(cygpath --windows "$JAVA_HOME")
    [ -n "$CLASSPATH" ] &&
    export CLASSPATH=$(cygpath --windows "$CLASSPATH")
    [ -n "$GRADLE_USER_HOME" ] &&
    export GRADLE_USER_HOME=$(cygpath --windows "$GRADLE_USER_HOME")
fi

exec "$JAVACMD" "$@"
