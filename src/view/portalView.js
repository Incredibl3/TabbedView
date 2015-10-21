import device;

var BG_WIDTH = 576;
var	BG_HEIGHT = 1024;

exports = {
	type: 'bottom',
	defaultTab: 1,
	children: [
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
		  name: 'Games',
		  cls: 'src.view.GameView',
		  image: 'resources/images/bg.png',
		  width: BG_WIDTH,
		  height: BG_HEIGHT - 100,
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
};
