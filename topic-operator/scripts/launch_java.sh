#!/bin/sh
set -x
JAR_LOCATION=$1
MAIN_CLASS=$2
shift

. /bin/dynamic_resources.sh

MAX_HEAP=`get_heap_size`
if [ -n "$MAX_HEAP" ]; then
  JAVA_OPTS="-Xms${MAX_HEAP}m -Xmx${MAX_HEAP}m $JAVA_OPTS"
fi

export MALLOC_ARENA_MAX=2

# Make sure that we use /dev/urandom
JAVA_OPTS="${JAVA_OPTS} -Dvertx.cacheDirBase=/tmp -Djava.security.egd=file:/dev/./urandom"

# Enable GC logging for memory tracking
JAVA_OPTS="${JAVA_OPTS} -XX:NativeMemoryTracking=summary -verbose:gc -Xlog:gc*"

CLASSPATH=""
for file in "$JAR_LOCATION"/*.jar;
do
  CLASSPATH="$CLASSPATH":"$file"
done

exec java $JAVA_OPTS -cp $CLASSPATH $JAVA_OPTS $MAIN_CLASS $@
