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
import src.config as config;
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
				typeOpts = config.layout.bottom;
				break;
			case 'left':
				typeOpts = config.layout.bottom;
				break;
			case 'right':
				typeOpts = config.layout.bottom;
				break;			
		};
		
		typeOpts = merge(typeOpts, { 
			superview: opts.superview
		});
		this._typeOpts = typeOpts;	// Store opts for future use
		this.rootView = opts.rootView || opts.parent || opts.superview;

		this.view = new View(typeOpts);
		this.customView = new View(merge({superview: this.view}, typeOpts.customView));
		this.numOfTabs = uiInflater.addChildren(opts.children, this.customView);
		
		var defaultTab = opts.defaults || 0;
		this.tabMap = {};
		this.tabView = new View(merge({superview: this.view}, typeOpts.tabView));
		this.customView.getSubviews().forEach(bind(this, function(view, i) {
			var tabElement = new TabElement({
				superview: this.tabView,
				width: BG_WIDTH / this.numOfTabs,
				height: this._typeOpts.tabViewHeight,
				backgroundColor: "#888", //blue,
				name: view.name
			});

			this.tabMap[view.name] = tabElement;

			if (i == defaultTab) {
				console.log("defaults");
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
				console.log("Select tab: " + tabName);
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
		console.log("the name is " + this.name);

		this.isActive = false;
		this.textView = new TextView({
			superview: this,
			text: this.name,
			color: "#FFF",
			size: 20,
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
