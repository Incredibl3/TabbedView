import device;
import ui.View as View;
import ui.ImageView as ImageView;
import ui.ScrollView as ScrollView;
import src.lib.uiInflater as uiInflater;
import src.data.template as template;

var ITEM_PER_PAGE = template.item_per_page;
var SCROLLVIEW_WIDTH = template.scrollview_width;
var SCROLLVIEW_HEIGHT = template.scrollview_height;
var ITEM_HEIGHT = template.item_height;
var ITEM_SPACING = template.item_spacing;

exports = Class(ImageView, function(supr) {	
	this.init = function(opts) {
		supr(this, 'init', [opts]);

		this.games = {};
		this.buildView();
	};

	this.buildView = function() {
		this.gameList = new ScrollView({
			superview: this,
			x: 0,
			y: 200,
			width: SCROLLVIEW_WIDTH,
			height: SCROLLVIEW_HEIGHT,
			scrollX: false,
			scrollBounds: {
				minY: 0,
				maxY: ITEM_HEIGHT * 4
			}
		});

		this.extractInfo(template.games);
	};

	// Todo in the future: opts is get from server
	this.extractInfo = function(opts) {
		template.games.forEach(bind(this, function(child, i) {
			// child:
			// {
			// 	title: 'Alley Cat Stack',
			// 	description: 'Stacker game with Cats',
			// 	icon: 'resources/images/templates/alley.png'
			// },

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
				console.log("child name " + view.name);
				if (view.name == 'title') {
					console.log('text: ' + title);
					view.setText(title);
				} else if (view.name == 'description') {
					console.log('description: ' + description);
					view.setText(description);
				}
			});
			gameItem['icon'].setImage(icon);
			this.games[i] = gameItem;
		}));
	};

	this.buildGameItem = function(opts, i) {
		var gameItem = new GameItem(merge({
			superview: this.gameList,
			x: 0,
			y: i * (ITEM_HEIGHT + ITEM_SPACING),
			backgroundColor: '#FFF',
		}, template.layout));

		return gameItem;
	};
});

var GameItem = exports.gameItem = Class(View, function(supr) {
	this.init = function(opts) {
		supr(this, 'init', [opts]);

		this.buildView(opts);
	};

	this.buildView = function(opts) {

	};
});