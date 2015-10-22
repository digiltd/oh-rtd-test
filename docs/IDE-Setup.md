How to set up a development environment for openHAB

## Introduction

If you are a developer and not a pure user yourself, you might want to setup your Eclipse IDE, so that you can debug and develop openHAB bundles yourself. There are three options for getting the IDE running: yoxos, pure eclipse and vagrant.

## 'Yoxos' Instructions

1. Create a local clone of the openHAB repository by running "git clone https://github.com/openhab/openhab" in a suitable folder.
1. Download and install oracle jdk 1.7
1. Download and install the [Yoxos Installer](https://yoxos.eclipsesource.com/downloadlauncher.html).
1. Download and execute the file [openHAB.yoxos](http://dl.dropbox.com/u/15535378/openHAB.yoxos) (in linux that can be done via command line ./yoxos openHAB.yoxos 
). This will install you an Eclipse IDE with all required features to develop for openHAB. Alternatively, you can install all required plugins on top of an existing Eclipse 4.4 installation using this [update site](http://yoxos.eclipsesource.com/userdata/profile/c5f3985b62c488f0df0dfbc369f9e057) or [download a full distribution from Yoxos](http://yoxos.eclipsesource.com/userdata/profile/c5f3985b62c488f0df0dfbc369f9e057), if you register an account there.
1. Create a new workspace.
1. Choose `File` → `Import` → `General` → `Existing Projects into Workspace`, enter your clone repository directory as the root directory and press "Finish".
1. After the import is done, you have to select the target platform by selecting `Window` → `Preferences` → `Plug-in Development` → `Target Platform` → `openHAB` from the main menu. Ignore compilation problems at this step.
1. Now you need to run code generation for a few parts of openHAB. To do so, go to the project org.openhab.model.codegen and run the prepared launch files. For each .launch file, select `Run As` → `x Generate abc Model` from the context menu. Please follow the order given by the numbers. On the very first code generation, you are asked in the console to download an ANTLR file, answer with "y" and press enter on the console. (See https://groups.google.com/forum/#!topic/openhab/QgABTJAkHOg if you're getting "Could not find or load main class org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher"). If step (3) fails with a CompliationException go Window -> Preferences -> Java -> Compiler and make sure JDK Compliance level is at least 1.6.
1. All your project in the workspace should now correctly compile without errors. If you still see errors, mark all projects and issue a project refresh (not by `F5` but using the context menu `refresh`). If you still see error markers, try a "clean" on the concerned projects. If there are still errors, it could be that you use JDK 1.6 instead of JDK 1.7, or the JDK compliance is set to 1.4 or 1.5 instead of at least 1.6.
1. To launch openHAB from within your IDE, go to Run->Run Configurations->Eclipse Application->openHAB Runtime (resp. openHAB Designer). Switch to "Plug-in Development" perspective first (Windows->Open Perspective->Other->Plug-in Development).

To produce a binary zip yourself from your code, you can simply call `mvn clean install` from the repository root and you will find the results in the folder distribution/target (you will of course need a Maven 3.0 installation as a prerequisite). Create Environment Variable `MAVEN_OPTS` and set it to `-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m` in order to avoid memory problems during the build process.

To run a single test you have to use following command: `mvn -o org.eclipse.tycho:tycho-surefire-plugin:0.18.1:test` which activates the tycho-surefire-specific goal for OSGI unit test using the fragment bundle xxxx.test on xxxx bundle. The maven -o (offline) option accelerates the project dependency resolution by 10-20x since it lets maven search it's local repository. Normally, snapshot-enabled projects are using external repositories to find latest built packages. 

## 'Pure Eclipse' Instructions

1. Create a local clone of the openHAB repository by running "git clone https://github.com/openhab/openhab" in a suitable folder.
1. Download and install oracle jdk 1.7
1. Download and install the [Eclipse for RCP and RAP Developers](https://www.eclipse.org/downloads/packages/eclipse-rcp-and-rap-developers/lunasr2).
1. Create a new workspace.
1. Choose `File` → `Import` → `General` → `Existing Projects into Workspace`, enter your clone repository directory as the root directory and press "Finish".
1. After the import is done, you have to select the target platform by selecting `Window` → `Preferences` → `Plug-in Development` → `Target Platform` → `openHAB` from the main menu. Ignore compilation problems at this step.
1. Download and install [Maven 3](http://artfiles.org/apache.org/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.zip). Set `MAVEN_OPTS` to `-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m` in order to avoid memory problems during the build process.
1. Execute `mvn clean install` from the repository root. You will find the (binary) results in the folder distribution/target. On the very first code generation, you are asked on the console to download an ANTLR file, answer with "y" and press enter on the console. (See https://groups.google.com/forum/#!topic/openhab/QgABTJAkHOg if you're getting "Could not find or load main class org.eclipse.emf.mwe2.launch.runtime.Mwe2Launcher").
1. All your project in the workspace should now correctly compile without errors. If you still see error markers, try a "clean" on the concerned projects. If there are still errors, it could be that you use JDK 1.6 instead of JDK 1.7, or the JDK compliance is set to 1.4 or 1.5 instead of at least 1.6.
1. To launch openHAB from within your IDE, go to Run->Run Configurations->Eclipse Application->openHAB Runtime (resp. openHAB Designer). Switch to "Plug-in Development" perspective first (Windows->Open Perspective->Other->Plug-in Development).

After the first successful local build it might be a good idea to build with maven -o (offline) afterwards. This option accelerates the project dependency resolution by 10-20x since it lets maven search it's local repository. Normally, snapshot-enabled projects are using external repositories to find latest built packages.

Note that the IDE being installed by the above mentioned method _does **not** contain any code generation facilities_ (MWE, Xtext) itself since that setup caused difficulties on certain machines. The code generation is accomplished through the maven build though.

## 'Vagrant' Instructions

Alternatively, you may wish to use [vagrant](http://www.vagrantcloud.com) to get a pre-configured, running IDE. 

1. Install [VirtualBox](https://www.virtualbox.org/) and [vagrant](http://www.vagrantcloud.com) first.  
1. Create a new directory for vagrant and `cd` into it
1. Run `vagrant init rub-a-dub-dub/openhabdev32`
1. Execute `vagrant up` (this will take some time as a ~3GB virtual image needs to be downloaded)
1. Execute `vagrant ssh` to access your machine

To turn off the vagrant machine, run `vagrant halt` in the vagrant directory you created. Run `vagrant suspend` to just suspend the machine. To get rid of the VM and its resources, run `vagrant destroy`. For more information on the setup and use of the IDE with vagrant, look [here](https://vagrantcloud.com/rub-a-dub-dub/openhabdev32).