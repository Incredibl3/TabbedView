/**
 * @license
 * No license
 */

/**
 * @class TabbedView;
 * Implements a view which can switch out randomly one of several child views to display at the front, 
 *
 */

import ui.View as View;
import ui.TextView as TextView;
import src.lib.uiInflater as uiInflater;
import src.lib.config as config;
import animate;

/**
 * @extends ui.View
 */

var BG_WIDTH = 576;
var BG_HEIGHT = 1024;
var global;

var TabbedView = exports = Class(function () {
	this.init = function (opts) {
		global = this;
		var typeOpts = config.layout.bottom;
		switch (opts.type) {
			case 'bottom':
				typeOpts = config.layout.bottom;
				break;
			case 'top':
				typeOpts = config.layout.top;
				break;
			case 'left':
				typeOpts = config.layout.left;
				break;
			case 'right':
				typeOpts = config.layout.right;
				break;			
		};
		
		this.rootView = opts.rootView || opts.parent || opts.superview;
		console.log("rootView: " + this.rootView.style.y);

		var tab_height = opts.tabViewHeight || typeOpts.tabViewHeight;
		console.log("tabViewHeight: " + tab_height);

		// console.log("typeOpts: " + JSON.stringify(typeOpts));
		typeOpts = merge(typeOpts, { 
			superview: opts.superview,
			y: -this.rootView.style.y,
			height: BG_HEIGHT + this.rootView.style.y
		});
		this._typeOpts = typeOpts;	// Store opts for future use
		this.view = new View(typeOpts);
		this.customView = new View(merge({
			superview: this.view,
			height: BG_HEIGHT + this.rootView.style.y - tab_height
		}, typeOpts.customView));
		opts.children.forEach(bind(this, function(child, i) {
			console.log("child before: " + JSON.stringify(child));
			child.height = child.height || this.customView.style.height;
			console.log("child after: " + JSON.stringify(child));
		}));
		this.numOfTabs = uiInflater.addChildren(opts.children, this.customView);
		
		var defaultTab = opts.defaults || 0;
		this.tabMap = {};
		this.tabView = new View(merge({superview: this.view, height: tab_height}, typeOpts.tabView));
		this.customView.getSubviews().forEach(bind(this, function(view, i) {
			var tabElement = new TabElement({
				superview: this.tabView,
				layout: 'box',
				width: BG_WIDTH / this.numOfTabs,
				height: tab_height,
				backgroundColor: "#888", //blue,
				name: view.name
			});

			this.tabMap[view.name] = tabElement;

			if (i == defaultTab) {
				tabElement.setActive(true);
				this.setCurrentView(view);
			} else {
				view.style.visible = false;
			}
		}));
	};

	this.getCurrentView = function() {
		return this.currentView;
	};

	this.setCurrentView = function(view) {
		if (this.currentView) {
			this.currentView.style.visible = false;
			this.tabMap[this.currentView.name].style.backgroundColor = "#888";
		}

		this.currentView = view;
		this.currentView.style.visible = true;
		this.tabMap[this.currentView.name].style.backgroundColor = "#800";
	};

	this.onTabSelected = function(tabName) {
		this.customView.getSubviews().forEach(bind(this, function(view, i) {
			if (view.name == tabName) {
				this.setCurrentView(view);
			}
		}));
	}
});

// the Tab Element Class
var TabElement = exports.TabElement = Class(View, function () {
	var sup = View.prototype;
	var name = 'No name';

	this.init = function (opts) {
		sup.init.call(this, opts);
		this.name = opts.name ? opts.name : name;

		this.isActive = false;
		this.textView = new TextView({
			superview: this,
			text: this.name,
			color: "#FFF",
			size: 40,
			centerY: true,
			width: this.style.width,
			height: this.style.height / 2,
			autoFontSize: false,
			wrap: true
		});

		this.on('InputSelect', bind(this, function() {
			global.onTabSelected(this.name);
		}));
	};

	this.setActive = function(active) {
		this.isActive = active;
	}
});
