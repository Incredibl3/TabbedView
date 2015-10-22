import device;
import ui.View as View;
import ui.TextView as TextView;
import src.view.portalView as portalView;
import src.lib.TabbedView as TabbedView;

var BG_WIDTH = 576;
var BG_HEIGHT = 1024;
var type = portalView.type;

exports = Class(GC.Application, function () {

  this.initUI = function () {
    this.setScreenDimensions(BG_WIDTH > BG_HEIGHT);

    // blocks player input to avoid traversing game elements' view hierarchy
    this.bgLayer = new View({
      parent: this.view,
      y: this.view.style.height - BG_HEIGHT,
      width: BG_WIDTH,
      height: BG_HEIGHT
    });

    this.tabbedView = new TabbedView(merge({superview: this.bgLayer, tabViewHeight: 50}, portalView));
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
