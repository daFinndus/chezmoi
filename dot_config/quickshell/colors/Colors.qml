import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton

Singleton {
  id: root

  readonly property var colors: colorManager.currentColors
  readonly property var grays: grayManager.currentGrays

  QtObject {
    id: colorManager

    property var currentColors: ({})
    property bool colorsLoaded: false
    
    property FileView colorFile: FileView {
      path: Qt.resolvedUrl("./colors.json")
      preload: true

      // The next 3 options are necessary to make it interactive
      watchChanges: true
      onFileChanged: {
        colorManager.reloadColors();
      }
      onLoaded: {
        colorManager.reloadColors();
      }
    }
    
    function reloadColors() {
      colorFile.reload();

      try {
        var text = colorFile.text;
        if (!text) {
          return;
        }

        currentColors = JSON.parse(text);
        colorsLoaded = true;
      } catch (e) {
        colorsLoaded = false;
      }
    }
  }

  QtObject {
    id: grayManager

    property var currentGrays: ({})
    property bool graysLoaded: false

    property FileView grayFile: FileView {
      path: Qt.resolvedUrl("./grays.json")
      preload: true

      // The next 3 options are necessary to make it interactive
      watchChanges: true
      onFileChanged: {
        grayManager.reloadColors();
      }
      onLoaded: {
        grayManager.reloadColors();
      }
    }
    
    function reloadColors() {
      grayFile.reload();

      try {
        var text = grayFile.text;
        if (!text) {
          return;
        }

        currentGrays = JSON.parse(text);
        graysLoaded = true;
      } catch (e) {
        graysLoaded = false;
      }
    }
  }

  signal colorReloadRequested

  onColorReloadRequested: {
    colorManager.reloadColors();
  }

  function reloadColors() {
    colorManager.reloadColors();
  }

  signal grayReloadRequested

  onGrayReloadRequested: {
    grayManager.reloadColors();
  }

  function reloadGrays() {
    grayManager.reloadColors();
  }

  Component.onCompleted: {
    grayManager.reloadColors();
  }
}
