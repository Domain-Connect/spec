# Domain Connect Specification

Domain Connect specification is published on GitHub and can be displayed under following link
* [Specification](Domain%20Connect%20Spec%20Draft.adoc)

## Lifecycle of the specification

* New version of the specification is published by new commits on master branch of this repository.
* New publication which change only the *Revision* number SHALL not break any of existing functionalities or integrations.
  * Each new revision shall be tagged, using `git` command for example: `git tag -a rev.58 -m "Rev. 58"` or GitHub `Releases` feature
* Update to *Version* number means a breaking change and as such shall by all means be avoided.

## Issues and questions to the specification

Any issues, questions or feature requests to the specification can be raised by opening GitHub issue on this project.
All the discussion will be then held within the ticket.

## Contribution

Anyone is encouraged to contribute to the specification and to propose changes or new functionalities.
The desired way of working is by forking the repository to a private account, make necessary changes and then issue a Pull Request back to the master.
The change will be then taken under Review.

## Building the IETF draft

Using VSCode with Dev Container extension, launch VSCode with the configuration provided in .devcontainer

Execute:
`metanorma -t ietf -x txt,html draft-kowalik-domainconnect-00.adoc`