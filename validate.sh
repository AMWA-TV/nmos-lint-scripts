#!/usr/bin/env bash

AJV=../node_modules/.bin/ajv # relative to APIs/

if [ ! -d APIs ]; then
    echo No APIs directory
    exit 1
    if [ ! -d APIs/schemas ]; then
        echo No APIs/schemas directory
        exit 1
    fi
fi

if [ ! -d examples ]; then
    echo No examples directory
    exit 1
fi

function validate {
    $AJV -s $1 -d $2
}

cd APIs
for raml in *.raml; do
    echo "Validating examples in $raml"
    yq -r '..|.body?|.type+" "+.example' $raml | sed '/^[[:space:]]*$/d' | grep examples/ | while read schema example; do
        if [[ ! $schema = *.json ]]; then
            schema=$(yq -r ".types.$schema" $raml) # IS-06 needs .types[] :-(
            echo Type resolves to $schema
        fi
        echo Validating $example against $schema
        validate $schema $example
    done
done

# echo Validating examples $raml...

# for example in examples/*.json; do
#     if raml=$(grep -l $example APIs/*.raml); then
#         echo "Found $example in $raml"
#         if schema=$(grep -C 1 $example $raml | grep -o 'schemas/[-._a-zA-Z0-9]*\.json'); then
#             echo "Validate with $schema..."
#             if ! $AJV -s APIs/$schema -d $example; then
#                 failed=y
#             fi
#         elif type=$(grep -C 1 $example $raml | egrep type: ); then
#             echo "XValidate with $type"
#         else
#             echo "WARNING: Can't validate"
#         fi
#     else
#         echo "WARNING: $example not mentioned in any RAML"
#     fi
# done
