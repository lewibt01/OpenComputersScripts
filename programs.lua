{
  --default installation path
  path="/usr",
  --Additional repositories and packages go here, for correct package syntax, check https://github.com/OpenPrograms/Vexatos-Programs/blob/master/oppm/etc/example-config.cfg
  repos={
    ["lewibt01/OpenComputersScripts"] = {
      ["nanomachine-control"] = {
        files = {
          ["master/TabletPrograms/NanomachineControl.lua"] = "/"
        },
        dependencies={},
        name = "NanomachineControl",
        descriptions = "Allows manual control of nanomachines within wifi range.",
        authors = "birdini",
        note = "No additional notes here.",
        hidden = true,
        repo = "tree/master/TabletPrograms"
      }
    }
  }
}

