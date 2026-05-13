import QtQuick
import Quickshell
import Quickshell.Io

pragma Singleton

Singleton {
  id: root

  readonly property var fallbackColors: ({
    "colors": {
      "color0": "#061134",
      "color1": "#40850F",
      "color2": "#4C9F05",
      "color3": "#64D301",
      "color4": "#627289",
      "color5": "#6F99B2",
      "color6": "#9BA1AD",
      "color7": "#d0d5da",
      "color8": "#919598",
      "color9": "#40850F",
      "color10": "#4C9F05",
      "color11": "#64D301",
      "color12": "#627289",
      "color13": "#6F99B2",
      "color14": "#9BA1AD",
      "color15": "#d0d5da"
    }
  })

  readonly property var colors: colorManager.colorsLoaded ? colorManager.currentColors : fallbackColors

  QtObject {
    id: colorManager

    property var currentColors: ({})
    property bool colorsLoaded: false
    
    property FileView colorFile: FileView {
      path: Qt.resolvedUrl(Globals.config + "/colors.json")
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

  signal colorReloadRequested

  onColorReloadRequested: {
    colorManager.reloadColors();
  }

  function reloadColors() {
    colorManager.reloadColors();
  }

  Component.onCompleted: {
    colorManager.reloadColors();
  }
}