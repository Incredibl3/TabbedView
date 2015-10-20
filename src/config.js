import device;

var BG_WIDTH = 576;
var BG_HEIGHT = 1024;
var TAB_VERTICAL_HEIGHT = 100;

exports = {
	layout: [
		bottom : {
			layout: 'linear',
			direction: 'vertical',
			layoutWidth: '100%',
			layoutHeight: '100%',
			customView : {
				width: BG_WIDTH,
				height: BG_HEIGHT - TAB_VERTICAL_HEIGHT,
				centerX: true,
				centerY: true,					
			},
			tabView: {
				layout: 'linear',
				direction: 'horizontal',
				width: BG_WIDTH,
				height: TAB_VERTICAL_HEIGHT,
				zIndex: 9999
			}
		}
	] 
};