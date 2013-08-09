#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

name=`basename $PWD`

#if [ "$name" == "apol_gem_name" ]
#then
#  echo "You must rename the parent directory to a real gem name, not leave it as apol_gem_name"
#  exit 1
#fi

has_extlib=`gem list | grep "extlib "`

if [ "$has_extlib" == "" ]
then
  gem install extlib
  if [ $? -ne 0 ]
  then
    echo "Some problem installing extlib, can't continue..."
    exit 1
  fi
fi

module_name=`ruby -e "require 'extlib/string';  puts \"$name\".camel_case"`

files="Gemfile
Gemfile.lock
README.md
apol_gem_name.gemspec
lib/apol_gem_name.rb
lib/apol_gem_name/version.rb
spec/cli_spec.rb"

for file in $files
do
  sed -i.bak "s/apol_gem_name/${name}/g" $file
done

files="apol_gem_name.gemspec
README.md
lib/apol_gem_name.rb
lib/apol_gem_name/version.rb
spec/cli_spec.rb"

for file in $files
do
  sed -i.bak "s/ApolGemName/${module_name}/g" $file
done

mv apol_gem_name.gemspec $name.gemspec
mv lib/apol_gem_name lib/$name
mv lib/apol_gem_name.rb lib/$name.rb

echo "rvm use ruby-1.9.3-p327@$name --create" > .rvmrc

find . | grep \.bak$ | xargs rm

