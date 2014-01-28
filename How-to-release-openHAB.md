Follow these steps if you want to release a new version of openHAB. Later we plan to leverage the Maven Release Plugin to facilitate these steps.

1. Pull the latest state from the repository
2. Open a command-line and go to the `openHAB` directory
3. Set project version to release version with the Tycho Versions plugin

    mvn -P prepare-release initialize -DnewVersion=1.x.0
4. Manually change `org.openhab.designer.product/category.xml` file. Replace `1.x.0.qualifier` by `1.x.0`
5. Execute a Maven build

    mvn -P deploy clean install -Dp2.repo.serverid=cloudbees-public-release-repo -Dp2.repo.url=dav:https://repository-openhab.forge.cloudbees.com/release -Dp2.repo.dir=p2 -Dmaven.repo.id=cloudbees-public-release-repo -Dmaven.repo.url=dav:https://repository-openhab.forge.cloudbees.com/release/maven
6. Commit the changed files

    git commit -a -m "prepare for 1.x.0 release"
7. Create a release tag with pattern `v<version>`

    git tag v1.x.0
8. Increment to next development version

    mvn -P prepare-snapshot initialize -DnewVersion=1.y.0
9. Manually change `org.openhab.designer.product/category.xml` file. Replace `1.y.0` by `1.y.0.qualifier`
10. Execute a Maven build with goals clean verify to assure that everything builds

    mvn clean verify
11. Commit the changes

    git commit -a -m "increment to next development version 1.y.0"
12. Go one directory up to the root of the repository

    cd ..
13. Push the changes including the tag to the server

    git --tags push origin master
    git push origin master
14. Switch to the root directoy of openHAB

to be continued …