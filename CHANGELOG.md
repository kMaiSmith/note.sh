# note.sh Changelog

## 0.1.2 - Automated release process

Beef up the auomation workflows to fully validate the changes, and then publish
  releases to Gitea and GitHub

 - Change CHANGELOG to CHANGELOG.md
   - Expect versions to get ## Headings with release titles
   - CHANGELOG.md bundled with archive

## 0.1.1 - Initial published released

Minor fixes to address intallations

 - can symlink to the note.sh to give it custom names, path

## 0.1.0

Initial release of note.sh

 - Initial build, note.sh can perform actions
 - Actions are defined as .action.sh files in lib/notesh/actions/
 - Initial actions:
   - init: initialize a new folder for notes
   - shell: enter a shell to perform other notes actions
   - edit: edit a note
   - today: view todays note
   - help: show usage documentation
 - notes are bundled into folders, each run of note.sh uses a NOTE_ROOT
 - user configurations are stored as config.sh the notes NOTE_ROOT/.notesh/
    or ~/.local/share/notesh/