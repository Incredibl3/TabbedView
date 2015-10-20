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
import src.lib.uiInflater as uiInflater;
import config as config;
import animate;

/**
 * @extends ui.View
 */
var TabbedView = exports = Class(function () {
	this.init = function (opts) {
		var typeOpts = config.bottom;
		switch (opts.type) {
			case 'bottom':
				typeOpts = config.bottom;
				break;
			case 'top':
				typeOpts = config.bottom;
				break;
			case 'left':
				typeOpts = config.bottom;
				break;
			case 'right':
				typeOpts = config.bottom;
				break;			
		};
		
		typeOpts = merge(typeOpts, { 
			superview: opts.superview
		});
		this.rootView = opts.rootView || opts.parent || opts.superview;
		// layer views: recycled and initialized from config on reset
		this.viewPool = new ViewPool({
		  ctor: opts.viewCtor || TabbedView
		});		

		this.viewMap = {};
		
		this.view = new View(typeOpts);
		this.customView = new View(typeOpts.customView);
		this.numOfTabs = uiInflater.addChildren(opts.children, this.customView);
		
		this.tabView = new View(typeOpts.tabView);
		this.customView.foreach
	};

	this.getCurrentView = function () {
		if (!this.stack.length) { return null; }
		return this.stack[this.stack.length - 1];
	};

	/**
	* reset: prepares the tabbed view for use based on provided config
	* ~ see README.md for details on config parameter
	*/
	this.reset = function (config) {
		this.releaseViews();
		this.initializeViews(config);	
	};
	
	/**
	* releaseViews: release all views to their respective pools
	*/
	this.releaseViews = function () {
		// this.layerMap = {};
		// this.layerPool.forEachActiveView(function (layer, i) {
		  // layer.pieces.length = 0;
		  // layer.removeFromSuperview();
		  // layer.piecePool.releaseAllViews();
		  // this.layerPool.releaseView(layer);
		// }, this);
	};
	
	/**
	* initializeViews: prepare views based on config for a fresh tabbed panel
	* ~ see README.md for details on config parameter
	*/
	this.initializeViews = function (config) {
		this.initializeLayout(config.tabInfo);
	
		for (var i = 0, len = config.children.length; i < len; i++) {
			var viewOpts = merge({ parent: this.rootView }, this._opts);
			var view = this.viewPool.obtainView(viewOpts);
			view.reset(config[i], i);
			// populate initial layers to fill the screen
			this.viewMap[layer.id] = layer;
		}
	};

	/**
	* initializeLayout: prepare layout for the Tabbed panel
	* To-Do: create config to allow customized tabbed control position, for now put it at the bottom
	* ~ see README.md for details on config parameter
	* 		~ numOfTabs: the total tabs
	*		~ type: refer to the layout declared in config.js
	*/
	this.initializeLayout = function (opts) {
		// top, right, left, bottom 
		var typeOpts = config.bottom;
		switch (opts.type) {
			case 'bottom':
				typeOpts = config.bottom;
				break;
			case 'top':
				typeOpts = config.bottom;
				break;
			case 'left':
				typeOpts = config.bottom;
				break;
			case 'right':
				typeOpts = config.bottom;
				break;			
		};
		
		
	};
});

// the Parallax Layer Class
var TabbedView = exports.TabbedView = Class(View, function () {
	var sup = View.prototype;
	var _uid = 0;
	
	this.init = function (opts) {
		sup.init.call(this, opts);
	};
	
	this.reset = function (config, index) {
		var superview = this.getSuperview();
	}
 )};
