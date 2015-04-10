
## Introduction

As for almost all open-source projects, contributions to the project are always welcome! However if you are interested in doing a contribution - be it a simple bug report or a big chunk of code for a new feature - it is good practise to adhere to the following workflow:

1. ask the [Google Group](https://groups.google.com/forum/#!forum/openhab) for a certain bug, behaviour, idea or missing feature
1. discuss and refine the Requirement/Bug (if any) on the Group
1. create an Issue in the [Github Issuetracker](https://github.com/openhab/openhab/issues) with reference to the discussion on the Group
1. keep track of the created Issue (even if it doesn't apply anymore, etc.)

The remainder of this page will give you the details of how to contribute more specifically:

## Best Practices for Contributors

The simplest way of contributing is probably to report bugs. You can do so using the [Issue Tracker](https://github.com/openhab/openhab/issues?state=open). 

If you are in doubt whether it is a bug or not, you can also first refer to [the forum](http://groups.google.com/group/openhab) instead of entering a bug report.

The same is true if you intend to implement/contribute a new feature. Please always first discuss your idea in the group as this will ensure a clear project direction and avoid the situation that different people unknowingly work on the same feature.

**Important:** Please note that while openHAB 1.x is the major version to use at the moment, the evolution of the core runtime is by now taking place at the [Eclipse SmartHome](https://www.eclipse.org/smarthome/) project, which builds the foundation for [openHAB 2.x](https://github.com/openhab/openhab2). You can find some background information about that in [this blogpost](http://kaikreuzer.blogspot.de/2014/06/openhab-20-and-eclipse-smarthome.html). Out of this reason, we are very reluctant to accept any pull requests for "core" functionality - if you plan such contributions, better discuss on the mailing list if it makes sense to do this in Eclipse SmartHome.
Pull requests for any kind of add-on (binding, action, etc.) are not concerned by this, as we will do our best that they will work on openHAB 2 without modification.

## Code Handling

To make code changes to the openHAB code base yourself, all you have to do is to create a local clone of the repository (git clone https://github.com/openhab/openhab/). See [IDE Setup](IDE-Setup) on how to set up a development environment and read [How to implement a binding](How-To-Implement-A-Binding) if you plan to implement a new binding.

If you want to contribute your code or just want to share it with others, you can [create a fork of the official repository](https://github.com/openhab/openhab/fork) at any time, for which you will have full access so that your local changesets can be pushed to it.

Once your code is ready and accepted (see code style section below), it is then easy for the project owners to pull your changesets into the official repository - all you have to do is to [create a pull request](https://help.github.com/articles/creating-a-pull-request).

**Please note:** Your pull request should contain only one single commit before merging. You can achieve that by [squashing your commits into one](https://github.com/ginatrapani/todo.txt-android/wiki/Squash-All-Commits-Related-to-a-Single-Issue-into-a-Single-Commit).

## Licensing

As openHAB is licensed under the Eclipse Public License (EPL), your code should include the [standard openHAB license headers](https://github.com/openhab/openhab/blob/master/src/etc/header.txt) as well. To automatically add it to your code, you can run `mvn license:format`.

By contributing code to openHAB, we therefore implicitly assume your approval to make it available under the EPL and that you have the right to give us the approval (i.e. the code does not contain any intellectual property that belongs to somebody else).
By attaching code to the issue tracker or posting code in the discussion groups, the contributor implicitly grants rights to use the code under the above mentioned terms and conditions. 

## Code Style & Conventions

To ensure code quality in our official repository, the project owners do code reviews before merging contributions into the main repository. There are some rules that every contribution should follow:

- [Java naming conventions](http://java.about.com/od/javasyntax/a/nameconventions.htm) should be used.
- Code formatting should be done according to the openHAB code formatter (preconfigured in the openHAB Yoxos profile)
- Every Java file should have the standard [license header](https://github.com/openhab/openhab/blob/master/src/etc/header.txt)
- Every class, interface and enumeration should have JavaDoc describing its purpose and usage. @author and @since tags should be given here.
- Every constant, field and method with default, protected or public visibility should have JavaDoc as well (optional, but encouraged for private visibility as well)
- ImportPackage should be used in the manifest rather than RequireBundle
 