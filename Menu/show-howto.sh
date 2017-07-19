#!/bin/bash

# provide default
OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}

cat <<EOT
Howto
=====

Quickstart for experts
----------------------

Prepare:

   docker pull t3docs/render-documentation
   source <(docker run --rm t3docs/renderdocumentation show-shell-commands)

Render:
   cd PROJECT/Documentation
   cd ..
   dockrun_${OUR_IMAGE_SHORT} makehtml

Render:
   cd PROJECT2
   dockrun_${OUR_IMAGE_SHORT} makehtml


For everybody: Getting started
------------------------------

Verify your Docker is working:

   docker run --rm hello-world


Get a project with documentation:

   # create directory
   mkdir -p ~/Repositories

   # fetch a sample project
   git clone https://github.com/T3DocumentationStarter/Public-Info-000 \\
             ~/Repositories/PROJECT

   # go to the root folder of the PROJECT
   cd ~/Repositories/PROJECT


Get the Docker image:

   By download:

      docker pull ${OUR_IMAGE}

   Or build it yourself:

      git clone https://github.com/t3docs/docker-render-documentation \\
                ~/Repositories/t3docs/docker-render-documentation

      cd \~/Repositories/t3docs/docker-render-documentation
      docker build -t ${OUR_IMAGE} .


Run the Docker image:

   docker run --rm ${OUR_IMAGE}
   docker run --rm ${OUR_IMAGE} --help
   docker run --rm ${OUR_IMAGE} show-faq
   ...


Render your documentation:

   cd ~/Repositories/PROJECT
   mkdir Documentation-GENERATED-temp 2>/dev/null
   docker run --rm \\
      -v "\$PWD":/PROJECT/:ro \\
      -v "\$PWD"/Documentation-GENERATED-temp/:/RESULT/ \\
      --user=\$(stat \$PWD --format="%u:%g") \\
      $OUR_IMAGE makehtml


Create handy shortcuts for the commandline:

   In several steps:

      docker run --rm ${OUR_IMAGE} show-shell-commands > temp
      source temp
      rm temp

   In just one step:

      # attention: no blanks between '<('
      source <(docker run --rm ${OUR_IMAGE} show-shell-commands)

   Now THIS terminal window has a new command (=function) on the commandline:

      dockrun_${OUR_IMAGE_SHORT}
      dockrun_${OUR_IMAGE_SHORT} --help
      ...

Use the new command to render the documentation:

   cd ~/Repositories/PROJECT
   dockrun_${OUR_IMAGE_SHORT} makehtml

Use the new command in general:

   dockrun_$OUR_IMAGE_SHORT
   dockrun_$OUR_IMAGE_SHORT --help
   dockrun_$OUR_IMAGE_SHORT show-faw
   dockrun_$OUR_IMAGE_SHORT show-howto
   dockrun_$OUR_IMAGE_SHORT tct --help
   ...

If you did create the shortcuts there should be another one as well.
It takes you to the shell of your container:

   dockbash_t3rd

This is a shortcut for the long form:

   mkdir Documentation-GENERATED-temp 2>/dev/null
   docker run -it --rm \\
      --entrypoint /bin/bash \\
      -v "\$PWD":/PROJECT/:ro \\
      -v "\$PWD"/Documentation-GENERATED-temp/:/RESULT/ \\
      --user=\$(stat \$PWD --format="%u:%g") \\
      $OUR_IMAGE


For developers
--------------

Required and possible volume mappings:

    Host      Container     :ro  Type      Comment
    ========= ============= ===  ========= =======
    PROJECT/  /PROJECT/:ro  yes  required  Read only. The project that has PROJECT/Documentation/
    1)        /RESULT/      no   required  For the result of the rendering process.
    Makedir/  /ALL/Makedir  no   optional  To supply a specific Makedir/
    Rundir/   /ALL/Rundir   no   optional  To supply a specific tctconfig.cfg
    tmp/      /tmp/         no   optional  To find out about the created tmp data.

    1) = PROJECT/Documentation-GENERATED-temp/

Complete standalone example:

   # fetch a suitable project that has folders ./tmp, ./Rundir, ./Makedir
   git clone        https://github.com/t3docs/docker-render-documentation \\
             ~/Repositories/github.com/t3docs/docker-render-documentation

   # go to the project
   cd ~/Repositories/github.com/t3docs/docker-render-documentation

   # get the docker image (= our executable)
   docker pull t3docs/render-documentation

   # render documentation
   # there is shortcut 'devdockrun_${OUR_IMAGE_SHORT}' for this as well
   mkdir Documentation-GENERATED-temp 2>/dev/null
   docker run --rm \\
      --user=\$(stat \$PWD --format="%u:%g") \\
      -v "\$PWD":/PROJECT/:ro \\
      -v "\$PWD"/Documentation-GENERATED-temp/:/RESULT/ \\
      -v "\$PWD"/Makedir/:/ALL/Makedir/ \\
      -v "\$PWD"/Rundir/:/ALL/Rundir/ \\
      -v "\$PWD"/tmp/:/tmp/ \\
      $OUR_IMAGE makehtml

   # enter the shell
   # there is shortcut 'devdockbash_${OUR_IMAGE_SHORT}' for this as well
   mkdir Documentation-GENERATED-temp 2>/dev/null
   docker run -it --rm \\
      --entrypoint /bin/bash \\
      --user=\$(stat \$PWD --format="%u:%g") \\
      -v "\$PWD":/PROJECT/:ro \\
      -v "\$PWD"/Documentation-GENERATED-temp/:/RESULT/ \\
      -v "\$PWD"/tmp/:/tmp/ \\
      -v "\$PWD"/Rundir/:/ALL/Rundir/ \\
      -v "\$PWD"/Makedir/:/ALL/Makedir/ \\
      $OUR_IMAGE

End of document.
EOT