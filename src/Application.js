import device;
import ui.TextView as TextView;
import src.TabbedView as TabbedView;

var BG_WIDTH = 576;
var BG_HEIGHT = 1024;
exports = Class(GC.Application, function () {

  this.initUI = function () {
    this.setScreenDimensions(BG_WIDTH > BG_HEIGHT);

    this.tabbedView = new TabbedView({
      type : 'bottom',
      superview: this.view,
      children : [
        {
          name: 'textview1',
          cls: 'ui.TextView',
          text: "Click to dismiss!\nThis is the front view.",
          backgroundColor: "#00F", //blue,
          color: "#FFF",
          size: 20,
          width: BG_WIDTH,
          height: BG_HEIGHT - 100,
          autoFontSize: false,
          wrap: true
        },
        {
          name: 'textview2',
          cls: 'ui.TextView',
          text: "Click to dismiss!\nThis is the middle view.",
          backgroundColor: "#080", //green
          color: "#FFF",
          size: 20,
          width: BG_WIDTH,
          height: BG_HEIGHT - 100,
          autoFontSize: false,
          wrap: true
        },
        {
          name: 'textview3',
          cls: 'ui.TextView',
          text: "Click to dismiss!\nThis is the back view.",
          backgroundColor: "#F00", //red
          color: "#FFF",
          size: 20,
          width: BG_WIDTH,
          height: BG_HEIGHT - 100,
          autoFontSize: false,
          wrap: true
        }        
      ]
    });

  };

  this.launchUI = function () {

  };

  /**
   * setScreenDimensions
   * ~ normalizes the game's root view to fit any device screen
   */
  this.setScreenDimensions = function(horz) {
    var ds = device.screen;
    var vs = this.view.style;
    vs.width = horz ? ds.width * (BG_HEIGHT / ds.height) : BG_WIDTH;
    vs.height = horz ? BG_HEIGHT : ds.height * (BG_WIDTH / ds.width);
    vs.scale = horz ? ds.height / BG_HEIGHT : ds.width / BG_WIDTH;
  };

});
