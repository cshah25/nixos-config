import QtQuick
import "." as System
import ".." as Settings
import "../.." as Shell

Settings.Modal {
  id: root
  objectName: "systemPanel"
  title: "System"; bodyTop: 92
  contentHeight: fields.height + 30
  onBackRequested: Settings.State.back()
  Keys.onEscapePressed: Settings.State.back()
  Column {
    id: fields
    x: 30; width: root.width - 60; spacing: 8
    Settings.Field {
      objectName: "systemLock"
      width: parent.width; navigation: true
      title: "Lock & sleep"; value: System.Idle.label(System.Idle.current.lock)
      onClicked: Settings.State.openPage("lock")
    }
  }
}
