import device;

var BG_WIDTH = 576;
var BG_HEIGHT = 1024;
var TAB_VERTICAL_HEIGHT = 100;

//Reference aspect ratio as long/short
var delta = 0.01;
var _16x9 = 16/9;
var _3x2 = 3/2;
var _4x3 = 4/3;
var ASPECT_RATIO = device.screen.height / device.screen.width;
logger.log ("aspect ratio ", ASPECT_RATIO);

//Default is 16:9//3:2
if(ASPECT_RATIO < (_16x9-delta) ) {
	logger.log ("aspect ratio less than 16:9");
}

//4:3
if(ASPECT_RATIO < (_3x2-delta) ){
	logger.log ("aspect ratio less than 3:2");
}

exports = {
	bg_width: BG_WIDTH,
	bg_height: BG_HEIGHT,
	layout: {
		bottom : {
			tabViewHeight: TAB_VERTICAL_HEIGHT,
			layout: 'linear',
			direction: 'vertical',
			customView : {
				width: BG_WIDTH,
				height: BG_HEIGHT - TAB_VERTICAL_HEIGHT,
				centerX: true,
				centerY: true,
				order: 1				
			},
			tabView: {
				layout: 'linear',
				direction: 'horizontal',
				width: BG_WIDTH,
				height: TAB_VERTICAL_HEIGHT,
				zIndex: 9999,
				inLayout: false,
				image: 'resources/images/tabpanel.png'
			}
		}
	}
};