#sshuttle --dns -l 0.0.0.0 -r azureuser@pa-registry.cloudapp.net 0.0.0.0/0
sshuttle -l 0.0.0.0 -r $1 0.0.0.0/0
