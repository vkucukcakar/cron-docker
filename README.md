# vkucukcakar/cron

cron Docker image for time-based job scheduling

* Schedules jobs to run periodically.
* Put/mount your executable files into "/etc/cron.hourly/", "/etc/cron.daily/", "/etc/cron.monthly/", "/etc/cron.weekly/" to schedule with cron.
* Do not use *.sh or any other file extensions (Debian ignores executables with extensions in cron.* directories).
* Put/mount your custom cron files into "/etc/cron.d/" for arbitrary scheduling.
* Mount executables to any location you want. Enable auto configure to give execute permission to files.
* Executable output can be redirected back to Docker logs by using '/var/log/cron.log' or '/proc/1/fd/1'
  Error logs can be redirected back to Docker logs by mixing with stdout or by using '/var/log/cron-error.log' or '/proc/1/fd/2'
  e.g.: echo 'Hello World' >>/var/log/cron.log 2>&1"
* Based on vkucukcakar/runit image for service supervision and zombie reaping
* Alpine and Debian based images

## Supported tags

* alpine, latest
* debian

## Environment variables supported

* AUTO_CONFIGURE=[enable|disable]

* EXECUTABLES=[space separated filenames to give execute permission]

## Examples

There  is an example cron file bundled which can be downloaded for test. You can skip this step if you planned to use your own cron script. You can mount your own script with an absolute path instead of example ($PWD/cron-docker/example/cron.hourly/example).

	$ git clone https://github.com/vkucukcakar/cron-docker.git

### Example (Alpine Linux based image)

	$ docker run --name some-cron -v $PWD/cron/alpine/example/periodic/hourly/myscript:/etc/periodic/hourly/myscript -e AUTO_CONFIGURE=enable -e EXECUTABLES="/etc/periodic/hourly/myscript" -d vkucukcakar/cron:alpine

### Example (Debian based image)

	$ docker run --name some-cron -v $PWD/cron/debian/example/cron.hourly/myscript:/etc/cron.hourly/myscript -e AUTO_CONFIGURE=enable -e EXECUTABLES="/etc/cron.hourly/myscript" -d vkucukcakar/cron:debian
	