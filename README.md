# {PROJECT NAME}

## Documents

This is an Obsidian Vault with detailed documents.

### Setup

[Obsidian Installation](https://help.obsidian.md/install)

#### Windows

run `open-documents.bat` to easily access the Project Documents and allow for in app management.

#### Other `TODO`

`open-documents.bat` does the following:
1. Renames `./PROJECT-TEMPLATE documents` to `./{Project folder's current name} documents` to allow Obsidian's Vault Manager to manage the Documents with a unique name
2. Modifies the Obsidian config called `obsidian.json` to:
    1. Modify the Vaults to include the project
    2. Enforce one entry per Vault
    3. Enforce open flag to the current Project Documents
3. Calls Obsidian at the path recorded in the config

## Development
Please review ```./development``` for source/build.
