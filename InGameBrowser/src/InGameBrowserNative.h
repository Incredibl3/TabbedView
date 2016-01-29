//
//  Created by Mihai Dan Popa on 9/26/12.
//  Copyright (c) 2012 Gameloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "InGameBrowser.h"

@interface InGameBrowserNative : NSObject<UIWebViewDelegate>{
    
    UIView*                     _IGBView;
    UINavigationBar*            _navBar;
    UIBarButtonItem*            _navBarBack;
    
    UIToolbar*                  _toolbar;
	UIBarButtonItem*            _reloadButton;
	UIBarButtonItem*            _loadingButton;
	UIBarButtonItem*            _forwardButton;
	UIBarButtonItem*            _backButton;
	UIBarButtonItem*            _flexibleSpace;
    UIBarButtonItem*            _fixedSpace;
    
//    UIActivityIndicatorView*    _activityIndicator;
    UIActivityIndicatorView*    _activityIndicatorRedirect;
    UIWebView*                  _IGBWebView;

    NSMutableData*              _receivedData;
    NSURLConnection*            _redirectConnection;    
    
    NSURLConnection*            _checkNewsNumberConnection;
    NSMutableData*              _receivedDataNewsNumber;
    
    NSURLConnection*            _checkNewsNumberConnectionSave;
    NSMutableData*              _receivedDataNewsNumberSave;
    
    int                         _lastUnreadNewsIndex;
    int                         _unreadNewsNumber;
    InGameBrowser::TUnreadNewsChangedCallback  unreadNewsChangedCallback;
        
    BOOL            _isInIGBrowser;
	BOOL            _newsWereDisplayed;        
    
    CGFloat         _screenWidth;
    CGFloat         _screenHeight;
    NSString*		urlAddressIGB;
    int             _languageIndex;
    NSString*       _gameCode;
    NSString*       _gameVersion;
    NSString*       _anonymousAccount;
    NSString*       _facebookID;
    NSString*       _gliveAccount;
    NSString*       _gameCenterUID;
    
    NSString*       _baseURL;
    NSString*       _clientID;
    unsigned int    _userAge;
	InGameBrowser::UserGender _userGender;
    int             _banType;
    
    UIView*         _parentView;
    NSTimer*        _IGBTimer;
}

@property (nonatomic, readonly) BOOL isInIGBrowser;

//parent view of the In-game Browser. Usually gameView
@property (nonatomic, retain) UIView*   parentView;

//set one or more of the following
@property (nonatomic, retain) NSString* gameCode;
@property (nonatomic, retain) NSString* gameVersion;
@property (nonatomic, retain) NSString* anonymousAccount;
@property (nonatomic, retain) NSString* facebookID;
@property (nonatomic, retain) NSString* gliveAccount;
@property (nonatomic, retain) NSString* gameCenterUID;
@property (nonatomic, retain) NSString* baseURL;
@property (nonatomic, retain) NSString* clientID;
@property (nonatomic) unsigned int userAge;
@property (nonatomic) InGameBrowser::UserGender userGender;

@property (nonatomic) int unreadNewsNumber;

-(void)setGameLanguage:(NSString*)language;
-(void)setBaseURL:(NSString*)baseURL;
-(void)setUserAge:(unsigned int)userAge;
-(void)setUserGender:(InGameBrowser::UserGender)userGender;

-(void)showCustomerCare;
-(void)showCustomerCareWithBANType:(int)banType;
-(void)showNews;
-(void)showForum;
-(void)showTermsOfUse;
-(void)showPrivacyPolicy;
-(void)showEULA;
-(void)showFacebookShare:(BOOL)directLink;
-(void)showFacebookPage:(BOOL)directLink;
-(void)openCustomLink:(NSString*)customLinkString withPostString:(NSString*)postString;
-(void)launchBrowserGameUpdate:(BOOL)directLink;
-(void)launchBrowserGameReview:(BOOL)directLink;

-(void)getFacebookShareLink:(BOOL)directLink withCallback:(void (*)(const char*))facebookShareLinkCallback;

+ (InGameBrowserNative *)sharedInGameBrowserNative;
-(void)quitIGB;

-(void)refreshUnreadNewsNumber;
-(void)setUnreadNewsChangedCallback:(InGameBrowser::TUnreadNewsChangedCallback) pCallback;

NSString* macaddressIGB();
@end
