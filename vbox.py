#!/usr/bin/python

import sys
import subprocess

# Variables.
command = 'VBoxManage list runningvms'
notification_command = 'kdialog --passivepopup "'
notification_show_time = '" 5'
vm_name = ''


# Check if the number of args is correct.
if len(sys.argv) != 2:
    sys.exit(0)
else: # Assign the VM that is going to be launched.
    vm_name = sys.argv[1]

# We list all the running virtual machines.
list_vms = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
out, err = list_vms.communicate()

if err:
    command = notification_command + 'An error ocurred with VBoxManage' + \
        notification_show_time

    show_error = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
elif out:
    command = notification_command + 'Virtual machines already running' + \
        notification_show_time

    show_error = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
else:
    command = 'VBoxManage startvm gui ' + vm_name
    launch_vm = subprocess.Popen(command.split(), stdout=subprocess.PIPE)
