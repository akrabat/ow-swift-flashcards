#!/bin/bash

docker run --rm --name=compile-ow-swift -it -v "$(pwd):/owexec" openwhisk/swift3action bash -e -c "

if [ -z \"$1\" ] ; then
    echo 'Error: Missing action name'
    exit
fi

if [ -f \"/owexec/build/$1.zip\" ] ; then
    rm \"/owexec/build/$1.zip\"
fi

echo 'Setting up build...'
if [ -d "/owexec/actions/$1" ] ; then
    # directory with this action name exists
    cp /owexec/actions/$1/*.swift /swift3Action/spm-build/

    # action file can be either {action name}.swift or main.swift
    if [ -f \"/swift3Action/spm-build/$1.swift\" ] ; then
        mv \"/swift3Action/spm-build/$1.swift\" /swift3Action/spm-build/main.swift
    fi
else
    #action name is a file in the actions directory
    cp /owexec/actions/$1.swift /swift3Action/spm-build/main.swift
fi

# pull in common files
cat /owexec/actions/common/*.swift >> /swift3Action/spm-build/main.swift

# Add in the OW specific bits
cat /swift3Action/epilogue.swift >> /swift3Action/spm-build/main.swift
echo '_run_main(mainFunction:main)' >> /swift3Action/spm-build/main.swift

echo \"Compiling $1...\"
cd /swift3Action/spm-build
if [ -f /owexec/actions/$1/Package.swift ] ; then
    echo 'running swift build'
    # we have our own Package.swift, do a full compile
    swift build -c release
else
    echo 'Running swiftbuildandlink.sh'
    # we are using the stock Package.swift
    /swift3Action/spm-build/swiftbuildandlink.sh
fi


echo 'Creating archive $1.zip...'
# cd /swift3Action/spm-build
zip \"/owexec/build/$1.zip\" .build/release/Action

"
