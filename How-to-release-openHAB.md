Follow these steps if you want to release a new version of openHAB. Later we plan to leverage the Maven Release Plugin to facilitate these steps.

1. Pull the latest state from the repository into a fresh and empty directory

        git clone git@github.com:openhab/openhab.git
1. Open a command-line and go to the `openhab` directory
1. Set project version to release version with the Tycho Versions plugin

        mvn -P prepare-release initialize -DnewVersion=1.x.0
1. Manually change `org.openhab.designer.product/category.xml` file. Replace `1.x.0.qualifier` by `1.x.0`
1. Execute a Maven build

        mvn -P deploy clean deploy -Drepo.id=cloudbees-public-release-repo -Drepo.url=dav:https://repository-openhab.forge.cloudbees.com/release/1.x.0 -Dp2.repo.dir=p2 -Dapt.repo.dir=apt-repo
1. Commit the changed files

        git commit -a -m "prepare for 1.x.0 release"
1. Create a release tag with pattern `v<version>`

        git tag v1.x.0
1. Increment to next development version

        mvn -P prepare-snapshot initialize -DnewVersion=1.y.0
1. Manually change `org.openhab.designer.product/category.xml` file. Replace `1.y.0` by `1.y.0.qualifier`
1. Execute a Maven build with goals clean verify to assure that everything builds

        mvn clean verify
1. Commit the changes

        git commit -a -m "increment to next development version 1.y.0"
1. Go one directory up to the root of the repository

        cd ..
1. Push the changes including the tag to the server

        git --tags push origin master
        git push origin master
1. Switch to the root directoy of openHAB

to be continued …