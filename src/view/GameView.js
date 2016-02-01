import device;
import ui.View as View;
import ui.ImageView as ImageView;
import ui.ScrollView as ScrollView;
import src.lib.uiInflater as uiInflater;
import src.data.template as template;
import util.ajax as ajax;
import nativeframework.webview as webview;

var ITEM_PER_PAGE = template.item_per_page;
var ITEMVIEW_WIDTH = template.itemview_width;
var SCROLLVIEW_WIDTH = template.scrollview_width;
var SCROLLVIEW_HEIGHT = template.scrollview_height - 1;
var ITEM_HEIGHT = template.item_height;
var ITEM_SPACING = template.item_spacing;
var BG_WIDTH = 576;

var rootview;
exports = Class(ImageView, function(supr) {	
	this.init = function(opts) {
		rootview = this;
		supr(this, 'init', [opts]);

		this.games = {};
		this.buildView();
	};

	this.buildView = function() {
		this.adsBanner = new ImageView({
			superview: this, 
			x: 0,
			y: 0,
			width: 576,
			height: 186,
			image: 'resources/images/adbanner.png'
		})

		this.gameList = new ScrollView({
			superview: this,
			x: 0,
			y: 200,
			width: SCROLLVIEW_WIDTH,
			height: SCROLLVIEW_HEIGHT,
			scrollX: false,
			scrollBounds: {
				minY: 0,
				maxY: ITEM_HEIGHT * 5
			}
		});

		ajax.get({
		  url: 'http://128.199.109.41:3100/apps/lists',
		  headers: {'Content-Type': 'text/plain'},
		  type: 'json'
		}, bind(this, function (err, response) {
		  if (err) {
		    console.error('someting went wrong');
		  } else {
		    this.extractInfo(response);
		  }
		}));
	};

	this.extractInfo = function(opts) {
		this.gameList.updateOpts({
			scrollBounds: {
				minY: 0,
				maxY: ITEM_HEIGHT * opts.length
			}
		});

		opts.forEach(bind(this, function(child, i) {
			var item_layout = template.layout.children;
			var title = '';
			var description = '';
			var icon = '';
			item_layout.forEach(function(layoutchild, ii) {
				if (layoutchild.name == 'icon') {
					icon = child.icon;
				}

				if (layoutchild.name == 'textInfo') {
					if (layoutchild.children) {
						layoutchild.children.forEach(function(textchild, iii) {
							if (textchild.name == 'title') {
								title = child.title;
							} else if (textchild.name == 'description') {
								description = child.description;
							}
						})
					}
				}
			});

			var gameItem = this.buildGameItem(child, i);
			uiInflater.addChildren(item_layout, gameItem);
			gameItem['textInfo'].getSubviews().forEach(function(view, i) {
				if (view.name == 'title') {
					view.setText(title);
				} else if (view.name == 'description') {
					view.setText(description);
				}
			});
			gameItem['icon'].setImage(icon);
			gameItem['button'].onClick = function() {
				console.log("Click on button: " + gameItem.location);
				if (child.orientation)
					webview.openURL({url: child.location, orientation: child.orientation});
				else
					webview.openURL({url: child.location, orientation: "portrait"});
			}
			this.games[i] = gameItem;
		}));
	};

	this.buildGameItem = function(opts, i) {
		var gameItem = new GameItem(merge({
			superview: this.gameList,
			x: (SCROLLVIEW_WIDTH - ITEMVIEW_WIDTH) / 2,
			y: i * (ITEM_HEIGHT + ITEM_SPACING),
			image: 'resources/images/item_bg.png',
			location: opts.location
		}, template.layout));

		return gameItem;
	};
});

var GameItem = exports.gameItem = Class(ImageView, function(supr) {
	var location;

	this.init = function(opts) {
		supr(this, 'init', [opts]);

		this.location = opts.location;
		this.buildView(opts);
	};

	this.buildView = function(opts) {

	};
});