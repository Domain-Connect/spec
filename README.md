# Domain Connect Specification

Domain Connect specification is published on GitHub and can be displayed under following link
* [IETF Draft](https://domain-connect.github.io/spec/) - this is Editor's copy of IETF draft.
  * The last published version is [here](https://datatracker.ietf.org/doc/draft-ietf-dconn-domainconnect/)

* Editors working branch [draft-ietf-dconn-domainconnect-XX](https://github.com/Domain-Connect/spec/tree/ietf/draft-ietf-dconn-domainconnect-XX)
* Release branch [ietf-submission](https://github.com/Domain-Connect/spec/tree/feature/ietf-submission)

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
`./generate.sh draft-kowalik-domainconnect-02`
