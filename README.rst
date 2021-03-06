===========================
docker-render-documentation
===========================

.. default-role:: code
.. highlight:: shell

This is the official recipe to build the Docker image
't3docs/render-documentation'.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Branch:          master
:Docker image:    t3docs/render-documentation,
                  https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/
:See also:        Toolchain 'RenderDocumentation'
                  https://github.com/marble/Toolchain_RenderDocumentation
:Date:            2018-07-04
:Version:         Docker image version 'latest'='v1.6.11-full', from
                  repository branch 'master'
:Capabilites:     html, singlehtml, package, latex, pdf;
                  can read and convert ./doc/manual.sxw


Help / Contact us
=================

See `Help & Support <https://docs.typo3.org/typo3cms/HowToDocument/HowToGetHelp.html>`
in "Writing Documentation" for how to get help or how to contact the documentation team.

If you are looking for general help for TYPO3, please see https://typo3.org/help.

Contribute
==========

For more information see `CONTRIBUTING.rst
<https://github.com/t3docs/docker-render-documentation/blob/master/CONTRIBUTING.rst>`__


Setup
=====

1. `Install Docker <https://docs.docker.com/engine/installation/>`__

2. Verify Docker is working::

      docker run --rm hello-world

   You should see::

      Hello from Docker.
      This message shows that ...

3. Download the Docker image::

      docker pull t3docs/render-documentation


4. Verify::

      docker run --rm t3docs/render-documentation

   You should see::

      t3rdf - TYPO3 render documentation full (v1.6.11-full)
      For help:
         docker run --rm t3docs/render-documentation --help
         dockrun_t3rdf --help

      ... did you mean 'dockrun_t3rdf makehtml'?

5. Go to your documentation project

   For example, clone an existing manual::

      git clone https://github.com/TYPO3-Documentation/TYPO3CMS-Tutorial-GettingStarted.git
      cd TYPO3CMS-Tutorial-GettingStarted

   Whatever documentation project you use, you should be in the parent directory
   of the Documentation directory when you run the following commands.


Quickstart on Linux
===================


1. Define some shell commands::

      # just show
      docker run --rm t3docs/render-documentation show-shell-commands

      # actually define - no blanks between '<('
      source <(docker run --rm t3docs/render-documentation show-shell-commands)

      # In case line `source <(...)` doesn't work on your OS use these three lines::

         docker run --rm t3docs/render-documentation show-shell-commands > tempfile.sh
         source tempfile.sh
         rm tempfile.sh

      # Verify that command dockrun_t3rdf is now available::

         dockrun_t3rdf --help



2. Do the rendering::

      dockrun_t3rdf makehtml           # only html

3. Find the results::

      # html
      Documentation-GENERATED-temp/Result/project/0.0.0/Index.html

   
   You can find the buildinfo (containing errors and warnings) here::

      # build information
      Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/

      # Sphinx warnings and errors - should be empty!
      Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt


4. Optional: Open the results in the default browser::

      xdg-open "Documentation-GENERATED-temp/Result/project/0.0.0/Index.html"

Quickstart on Mac
=================

The instructions for Linux should basically run on Mac. Replace xdg-open with
open::

   source <(docker run --rm t3docs/render-documentation show-shell-commands)
   dockrun_t3rdf makehtml
   open "Documentation-GENERATED-temp/Result/project/0.0.0/Index.html"


Alternatively, run with Docker Compose (see below).

Quickstart on Windows
=====================

For Windows, we recommend to use Docker Compose. See next section.

The workflow described under Workflow for Linux may also work.

To open the generated file in the browser:

In standard Windows Cmd terminal::

   start "Documentation-GENERATED-temp\Result\project\0.0.0\Index.html"

In a terminal, that supports '/' in paths, e.g. PowerShell, Bash Shell, Cygwin::

      start "Documentation-GENERATED-temp/Result/project/0.0.0/Index.html"


Quickstart with Docker Compose
==============================

1. Create a file docker-compose.yml:

   .. code-block:: yaml

      version: '2'
      services:
         html:
            image: t3docs/render-documentation:latest
            volumes:
            - ./:/PROJECT:ro
            - ./Documentation-GENERATED-temp:/RESULT
            command: makehtml
            environment:
            - HOST_CWD=$PWD


2. Run Docker Compose::

      docker-compose run --rm html


Advanced
========

Run control
-----------
Select just HTML rendering and add more selectively::

   dockrun_t3rdf makehtml \                 # html is always being built
         -c make_singlehtml 1 \             # enable singlehtml
         -c make_package    1 \             # enable standalone package
         -c make_latex      1 \             # enable latex + pdf
         -c make_pdf        1               # enable pdf - on by default

Or select ALL and turn off what you don't need::

   dockrun_t3rdf makeall \                  # html is always being built
         -c make_singlehtml 0 \             # disable singlehtml
         -c make_package 0 \                # disable standalone package
         -c make_pdf 0 \                    # disable pdf
         -c make_latex 0                    # disable latex + pdf

Specifying folders
------------------
Read through the output of `docker run --rm
t3docs/render-documentation show-shell-commands` to learn about the details.

**ATTENTION:** Use absolute paths. Do not use '/' at the end.

You can render a project that's located somewhere else. Set the environment
variable `T3DOCS_PROJECT` accordingly::

   T3DOCS_PROJECT=/abs/path/to/project
   dockrun_t3rdf makehtml

or::

   T3DOCS_PROJECT=/abs/path/to/project  dockrun_t3rdf makehtml

Specify a result folder to send the result somewhere else. The final output
folder `$T3DOCS_RESULT/Documentation-GENERATED-temp` will be created::

   T3DOCS_RESULT=/abs/path/to/result
   dockrun_t3rdf makehtml

Specify a path to a temp folder if you want to expose all those many
intermediate temp files for inspection. `$T3DOCS_RESULT/tmp-GENERATED-temp`
will be used::

   T3DOCS_TMP=/tmp
   dockrun_t3rdf makehtml


Rename to default tag 'latest'
------------------------------
If you omit the tag it defaults to 'latest'. So you may want to rename the
downloaded image to 'latest' if what you downloaded was not 'latest'::

   # remove
   docker rmi t3docs/render-documentation:latest
   # pull
   docker pull t3docs/render-documentation:v1.6.11-full
   # rename
   docker tag t3docs/render-documentation:v1.6.11-full \
              t3docs/render-documentation:latest
   # use the generic name without tag, for example in ~/.bashrc
   source <(docker run --rm t3docs/render-documentation show-shell-commands)


Caching
=======

Caching information will be generated automatically and stored in
`$T3DOCS_RESULT/Cache`. Simply leave that folder untouched to make use of
the caching mechanism. With caching, for example, a `makehtml` for the TYPO3
core ChangeLog may take only 15 seconds instead of 20 minutes.

The cache information is built while `html` processing. Other writers like
`singlehtml` make use of that same caching information and are working rather
fast. Therefore in general it should not be necessary to turn them off.


Caching for ./Documentation files of a repository
=================================================

The caching mechanism considers a file to be changed when the file modification
time (mtime) has changed. Revision control systems like Git usually don't
preserve file modification times.

**Tip:** You may want to look at the https://github.com/MestreLion/git-tools
Add the script `git-restore-mtime` to your path. Then, for example, do::

   # go to repo
   cd ~Repositories/git.typo3.org/Packages/TYPO3.CMS.git
   git-restore-mtime

It only takes a few seconds to set the mtime of more than 12.500 files to a
constant and meaningful value. Each file's mtime will be set to the value of
the most recent commit that changed that file.

Repeat the `git-restore-mtime` procedure after Git operations like branch
switches and checking out files.

NEW since version version 1.6.10: If you start the container via the `dockrun_...`
command `git-restore-mtime` will be run automatically if it is an executable
and can be found.


What to ignore in GIT
=====================

**Advice:** Add a line to your *global* GIT ignore file::

   echo "*GENERATED*" >>~/.gitignore_global


Finally
=======

Enjoy!
