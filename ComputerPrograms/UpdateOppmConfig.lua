--update local repo
os.execute("gitrepo lewibt01/OpenComputersScripts/")

--copy the config over
os.execute("cp /tmp/lewibt01/OpenComputersScripts/oppm.cfg /etc/oppm.cfg")
