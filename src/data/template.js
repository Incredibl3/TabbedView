import device;

var ITEM_PER_PAGE = 3;
var ITEMVIEW_WIDTH = 546;
var ITEM_HEIGHT = 150;
var LEFT_MARGIN = 10;
var TOP_MARGIN = 20;
var ICON_WIDTH = 110;
var ICON_HEIGHT = 110;
var TEXTVIEW_WIDTH = 250;
var SCROLLVIEW_WIDTH = 576;
var ITEM_SPACING = 10;
var SCROLLVIEW_HEIGHT = (ITEM_HEIGHT + ITEM_SPACING) * ITEM_PER_PAGE;
var TITLE_HEIGHT = 40;
var DESCRIPTION_HEIGHT = 40;

exports = { 
	item_per_page: ITEM_PER_PAGE,
	item_height: ITEM_HEIGHT,
	item_spacing: ITEM_SPACING,
	itemview_width: ITEMVIEW_WIDTH,
	scrollview_width: SCROLLVIEW_WIDTH,
	scrollview_height: SCROLLVIEW_HEIGHT,
	games: [
		{
			title: 'Alley Cat Stack',
			description: 'Stacker game with Cats',
			icon: 'resources/images/templates/alley.png'
		},
		{
			title: 'Kaiju Stack',
			description: 'Stacker game: An attack from alliens',
			icon: 'resources/images/templates/kaiju.png'
		},
		{
			title: 'Penguin Toss',
			description: 'Stacker game with Penguins',
			icon: 'resources/images/templates/penguintoss.png'
		},		
		{
			title: 'Lulu\' Sweet Shoppe',
			description: 'Match-3 game',
			icon: 'resources/images/templates/lulu.png'
		}
	],
	layout: {
		name: 'layout',
		layout: 'linear',
		direction: 'horizontal',
		width: ITEMVIEW_WIDTH,
		height: ITEM_HEIGHT,
		children: [
			{
				name: 'icon',
				cls: 'ui.ImageView',
				y: (ITEM_HEIGHT - 20 - ICON_HEIGHT) / 2,
				left: LEFT_MARGIN,
				width: ICON_WIDTH,
				height: ICON_HEIGHT,
				image: 'resources/images/76.png',
				canHandleEvents: false,
				order: 1
			},
			{
				name: 'textInfo',
				cls: 'ui.View',
				left: LEFT_MARGIN,
				layout: 'linear',
				direction: 'vertical',
				width: TEXTVIEW_WIDTH,
				height: SCROLLVIEW_HEIGHT,
				canHandleEvents: false,
				order: 2,
				children: [
					{
						name: 'title',
						cls: 'ui.TextView',
						color: "#000",
						size: 30,
						fontWeight: 'bold',
						wrap: true,
						horizontalAlign: 'left',
						verticalAlign: 'top',
						width: TEXTVIEW_WIDTH,
						height: TITLE_HEIGHT,
						top: (ITEM_HEIGHT - ICON_HEIGHT) / 2,
						canHandleEvents: false,
						order: 1
					},
					{
						name: 'description',
						cls: 'ui.TextView',
						color: "#000",
						size: 20,
						horizontalAlign: 'left',
						verticalAlign: 'top',
						wrap: false,
						clip: true,
						width: TEXTVIEW_WIDTH,
						height: DESCRIPTION_HEIGHT,
						canHandleEvents: false,
						autoFontSize: false,
						order: 2
					},	
				]
			},
			{
				name: 'button',
				cls: 'ui.widget.ButtonView',
				layout: 'box',
				left: 15,
				y: (ITEM_HEIGHT - 20 - 48) / 2,
				width: 143,
				height: 48,
				images: {
					"up": "resources/images/playbutton.png",
					"down": "resources/images/playbutton.png"
				},
				order: 3
			}
		]
	}
};