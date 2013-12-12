# Building Citation Client

## Setting up the build environment

First you need the ruby in NetVersaLLC/ruby187 installed in C:\Ruby187. Then select this ruby via pik.

A build is completed by changing into the Citation directory. Most scripts have thsi hard-coded as C:\Users\jonathan\dev\Citation. This is the repo at NetVersaLLC/Citation.

You will also need NetVersaLLC/watir-webdriver and NetVersaLLC/selenium cloned into C:\Users\jonathan\dev. First cd to each of these and do:

git pull origin master
and
git pull origin upstream

This will integrate the latest code from each of the githubs of the public projects.

Next you need to run "selenium\copy_gem_to_ruby187.rb_"
This will copy the correct files to the Citation repo, and C:\Ruby187.

## Building the Software

Change into the Citation directory. Now run build.rb to build the client. Installers go into labels and are automatically synced.
