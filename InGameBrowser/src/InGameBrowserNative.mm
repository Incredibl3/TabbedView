//
//
//  Created by Mihai Dan Popa on 9/26/12.
//  Copyright (c) 2012 Gameloft. All rights reserved.
//

#import "InGameBrowserNative.h"
#import "../../InGameBrowser_config/InGameBrowserConfig.h"
#import "SynthesizeSingletonIGBGameloft.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonCryptor.h>
#import <AdSupport/ASIdentifierManager.h>
#include <cassert>
#include <atomic>
#include "IOSNative/Constants.h"

#pragma mark - IGB resources constants

NSString *TXT_LANGUAGE_LIST_IGB[] = {
	@"EN",
	@"FR",
	@"DE",
	@"IT",
	@"SP",
	@"JP",
	@"KR",
	@"CN",
	@"BR",
	@"RU",
    @"TR",
	@"AR",
    @"TH",
	@"ID",
	@"VI",
	@"ZT" 
};

NSString *TXT_NET_ERROR_IGB[] =
{
    @"No internet connection available. Please make sure your device is connected to the internet.",
    @"Aucune connexion Internet disponible. Veuillez vous assurer que votre appareil est connecté à Internet",
    @"Keine Internetverbindung verfügbar. Versichere dich bitte, dass dein Gerät mit dem Internet verbunden ist.",
    @"Nessuna connessione disponibile. Assicurati che il dispositivo sia connesso a internet.",//Connessione internet non disponibile. Assicurati che il tuo dispositivo sia connesso a internet.",
    @"No hay ninguna conexión a internet disponible. Por favor, asegúrate de que tu dispositivo esté conectado a internet.",
    @"インターネット接続を利用できません\nデバイスがインターネットに接続されているかご確認ください",
    @"인터넷에 연결할 수 없습니다. 장치가 인터넷에 연결되어 있는지 확인하세요.",//인터넷에 연결되어 있지 않습니다. 장치가 인터넷에 연결되어 있는지 확인하세요.",
    @"无可用网络连接。请确保您的设备已连入网络。",//无网络连接。请确认您的设备已经连入网络。", //CN
    @"Conexão indisponível. Certifique-se de que seu aparelho esteja conectado à internet.",//Não há conexão disponível. Certifique-se de que seu aparelho está conectado à internet.", //BR
    @"Нет соединения с Интернетом. Пожалуйста, удостоверьтесь, что ваше устройство подключено к Интернету.",//Невозможно соединиться с сервером. Сеть не найдена. Пожалуйста, попробуйте позже.", //RU
    @"İnternet bağlantısı yok. Lütfen cihazının internete bağlı olduğundan emin ol.", //TR
	@"لا يوجد اتصال بالإنترنت. يُرجى التحقق من أن جهازك متصل بالإنترنت.",//AR
	@"ไม่พบ|การเชื่อมต่อ|อินเทอร์เน็ต |กรุณา|ตรวจสอบ|ว่า|เครื่อง|ของคุณ|ได้|เชื่อมต่อ|กับ|อินเทอร์เน็ต",//TH
	@"Koneksi Internet saat ini tidak tersedia. Pastikan perangkatmu sudah terhubung dengan Internet.",//ID
	@"Không có kết nối Internet. Xin đảm bảo thiết bị của bạn đã kết nối Internet.",//VI
	@"無可用網路連接，請確定您的設備已聯網。"//ZT
    
};

NSString *TXT_OK_IGP_IGB[] =
{
    @"OK",
    @"OK",
    @"OK",
    @"OK",
    @"Acep.",
    @"OK",
    @"OK",
    @"OK",
    @"OK",
    @"OK",
    @"OK",
	@"موافق",//AR
	@"ตกลง",//TH
	@"OK",//ID
	@"OK",//VI
	@"OK",//ZT
};

NSString *TXT_BACK_IGB[] =
{
    @"Close",
    @"Fermer",
    @"Schließen",
    @"Chiudi",
    @"Cerrar",
    @"閉じる",
    @"닫기",
    @"关闭",
    @"Fechar",
    @"Закрыть",
    @"Kapat",
	@"إغلاق",//AR
	@"ปิด",//TH
	@"Tutup",//ID
	@"Đóng",//VI
	@"關閉",//ZT
};

#pragma mark - IGB interface constants

#define K_LINK_SUPPORT @"%@redir/ingamebrowser.php?ctg=SUPPORT"
#define K_LINK_BANNED @"%@redir/ingamebrowser.php?ctg=BANNED"
#define K_LINK_POST_BASE @"data=%@&enc=2"
#define K_LINK_IGB_PARAMS @"from=FROM&op=IPHO&country=COUNTRY&lg=LANG&udid=UDIDPHONE&game_ver=VERSION&d=DEVICE&f=FIRMWARE&jb=JAILBRAKE&anonymous=ANONYMOUS_ACCOUNT&fbid=FACEBOOK_ID&gliveusername=GLIVE_USERNAME&gcid=GAMECENTER_UID&idfa=D_IDFA&idfv=D_IDFV&clientid=CLIENT_ID&user_age=CURRENT_USER_AGE"

#define K_LINK_BASE @"%@redir/?"

#define K_LINK_PARAMS @"from=FROM&op=IPHO&ctg=%@&game_ver=VERSION&lg=LANG&country=COUNTRY&d=DEVICE&f=FIRMWARE&udid=UDIDPHONE&idfa=D_IDFA&idfv=D_IDFV&clientid=CLIENT_ID&user_age=CURRENT_USER_AGE"
#define K_GAME_PARAM @"&game=%@"
#define K_GAME_PARAM_WITH_PP @"&game=%@&pp=1"

#define K_LINK_CHECK_UNREAD_NEWS_NUMBER @"%@redir/ingamenews.php?action=checkNews&last-id=%d"
#define K_LINK_SAVE_NEWS_ID @"%@redir/ingamenews.php?action=saveNews&last-id=%d"
#define K_LINK_DISPLAY_NEWS @"%@redir/ingamenews.php?action=displayNews"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation InGameBrowserNative
{
	NSURLConnection*  directLinkConnection;
	NSMutableData*    directLinkData;
	std::atomic<bool> insideDirectLinkQuery;
	void (*_facebookShareLinkCallback)(const char*);
}

SYNTHESIZE_SINGLETON_FOR_CLASS(InGameBrowserNative)
@synthesize isInIGBrowser = _isInIGBrowser;
@synthesize gameCode = _gameCode;
@synthesize gameVersion = _gameVersion;
@synthesize anonymousAccount = _anonymousAccount;
@synthesize facebookID = _facebookID;
@synthesize gliveAccount = _gliveAccount;
@synthesize gameCenterUID = _gameCenterUID;
@synthesize clientID = _clientID;
@synthesize userAge = _userAge;
@synthesize userGender = _userGender;
@synthesize unreadNewsNumber = _unreadNewsNumber;
@synthesize baseURL = _baseURL;

- (id) init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(orientationChanged)
												 name:UIApplicationDidChangeStatusBarFrameNotification
											   object:nil];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        _screenWidth    = screenSize.width;
        _screenHeight   = screenSize.height;
				
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {			
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

            if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight))
            {
                _screenWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
                _screenHeight = screenSize.width > screenSize.height ? screenSize.width : screenSize.height;
            }
        }
		
        _IGBTimer = nil;
        _anonymousAccount = @"";
        _facebookID = @"";
        _gliveAccount = @"";
        _gameCenterUID = @"";
        _newsWereDisplayed = NO;
        _banType = -1;
				
        _gameVersion = @"";
        _clientID = @"";
        _baseURL = @"http://ingameads.gameloft.com/";
        _userAge = 0;
		_userGender = InGameBrowser::GENDER_UNKNOWN;
        
        _facebookShareLinkCallback = nil;
        
        _reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                      target:self
                                                                      action:@selector(reload)];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        {
            [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        }
        
        [activityView startAnimating];
        _loadingButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
        [activityView release];
        
        _forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                       target:self
                                                                       action:@selector(goForward)];
        _forwardButton.enabled = NO;
        
        _backButton = [self backButton];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
        //												  target:self
        //												  action:@selector(goBack)];
        [_backButton retain];
        _backButton.enabled = NO;
        
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        _fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
		
        insideDirectLinkQuery = NO;
        directLinkConnection = nil;
        directLinkData = nil;
        
        unreadNewsChangedCallback = nil;
        _checkNewsNumberConnection = nil;
        _receivedDataNewsNumber = nil;
        _checkNewsNumberConnectionSave = nil;
        _receivedDataNewsNumberSave = nil;
        _lastUnreadNewsIndex = -1;
        _unreadNewsNumber = -1;
    }
    return self;
}

#pragma mark - IGB create/ update orientation/ exit
-(void)setGameLanguage:(NSString*)language
{
    	int index = -1;
    	for (int i = 0; i < (sizeof(TXT_LANGUAGE_LIST_IGB) / sizeof(NSString*)); i++)
        {
            if ([TXT_LANGUAGE_LIST_IGB[i] caseInsensitiveCompare:language] == NSOrderedSame)
            {
                 index = i;
                 break;
            }
        }
    	assert((index != -1) && "Invalid language passed to IGB.");
    	_languageIndex = index == -1 ? 0 : index;
}

-(void) showCustomerCare
{	
    NSString *link = [NSString stringWithFormat:K_LINK_SUPPORT, _baseURL];
    [self getIGBLink];	
    [self openCustomLink:link withPostString:urlAddressIGB];
}

-(void) showNews
{
    _newsWereDisplayed = YES; 
     NSString* link = [NSString stringWithFormat:K_LINK_DISPLAY_NEWS, _baseURL];
    [self getIGBLink];
    [self openCustomLink:link withPostString:urlAddressIGB];
}

-(void) showCustomerCareWithBANType:(int)banType
{
    _banType = banType;
    NSString *link = [NSString stringWithFormat:K_LINK_BANNED, _baseURL];
    [self getIGBLink];
    [self openCustomLink:link withPostString:urlAddressIGB];
}

-(void) showForum
{
    [self getLink:@"FORUM" withAdditionalParams:nil];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) showTermsOfUse
{
    [self getLink:@"TERMS" withAdditionalParams:nil];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) showPrivacyPolicy
{
    [self getLink:@"PRIVACY" withAdditionalParams:nil];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) showEULA
{
    [self getLink:@"EULA" withAdditionalParams:nil];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) showFacebookShare:(BOOL)directLink
{
    if (directLink)
    {
       [self getFacebookLink:@"share" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM_WITH_PP, _gameCode]];	
       [self startDirectLink:nil];
       return;
    }

    [self getFacebookLink:@"share" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM, _gameCode]];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) showFacebookPage:(BOOL)directLink
{
    if (directLink)
    {
       [self getFacebookLink:@"page" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM_WITH_PP, _gameCode]];	
       [self startDirectLink:nil];
       return;
    }

    [self getFacebookLink:@"page" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM, _gameCode]];
    [self openCustomLink:urlAddressIGB withPostString:nil];
}

-(void) launchBrowserGameUpdate:(BOOL)directLink
{
    if (directLink)
    {
       [self getLink:@"UPDATE" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM_WITH_PP, _gameCode]];
       [self startDirectLink:nil];
       return;
    }

    [self getLink:@"UPDATE" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM, _gameCode]];
    NSString* linkCopy = [urlAddressIGB copy];
    [urlAddressIGB release];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkCopy]]; 
        [linkCopy release];
    });
}

-(void) launchBrowserGameReview:(BOOL)directLink
{
    if (directLink)
    {
       [self getLink:@"GAME_REVIEW" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM_WITH_PP, _gameCode]];
       [self startDirectLink:nil];
       return;
    }

    [self getLink:@"GAME_REVIEW" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM, _gameCode]];
    NSString* linkCopy = [urlAddressIGB copy];
    [urlAddressIGB release];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkCopy]]; 
        [linkCopy release];
    });
}


-(void)getFacebookShareLink:(BOOL)directLink withCallback:(void (*)(const char*))facebookShareLinkCallback
{
    if (directLink)
    {
        [self getFacebookLink:@"share" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM_WITH_PP, _gameCode]];
        [self startDirectLink:facebookShareLinkCallback];
        return;
    }
    
    [self getFacebookLink:@"share" withAdditionalParams:[NSString stringWithFormat:K_GAME_PARAM, _gameCode]];
    (*facebookShareLinkCallback)([urlAddressIGB UTF8String]);
}

-(void) startDirectLink:(void(*)(const char*))facebookShareLinkCallback
{
	if (insideDirectLinkQuery)
	{
		NSLog(@"Already querying the server for the direct link");
		return;
	}
    
	_facebookShareLinkCallback = facebookShareLinkCallback;

	insideDirectLinkQuery = YES;
    
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlAddressIGB]];
	directLinkData = nil;
	directLinkConnection = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self startImmediately:YES];
}

-(void) openCustomLink:(NSString*)customLinkString withPostString:(NSString*)postString
{    
    if (_isInIGBrowser)
        return;

	_IGBView = [[UIView alloc] init];
    _IGBWebView = [[UIWebView alloc] init];
    _navBar = [[UINavigationBar alloc] init];
    _navBarBack = [[UIBarButtonItem alloc] initWithTitle:TXT_BACK_IGB[_languageIndex] style:UIBarButtonItemStyleDone target:self action:@selector(quitIGB)];
    _isInIGBrowser = YES;
    
    [_IGBView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [_IGBView setOpaque:YES];    
	
	_IGBView.layer.zPosition = VIEW_ZPOSITION_NEAR;
        
	NSURL *url = [NSURL URLWithString:customLinkString];
	NSLog(@"url = %@", url);	
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	
	if (postString != nil)
	{
		[requestObj setHTTPMethod:@"POST"];
		[requestObj setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
    [_IGBWebView setBackgroundColor:[UIColor clearColor]];
    [_IGBWebView setOpaque:NO];
    [_IGBWebView loadRequest:requestObj];
    
	[_IGBWebView setDelegate:self];
    
    for (id subview in _IGBWebView.subviews)
        if ([[subview class] isSubclassOfClass:[UIScrollView class]])
            [((UIScrollView*)subview) setBounces:NO];
    
    [_IGBView addSubview:_IGBWebView];

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@""];
    item.leftBarButtonItem = _navBarBack;
    [_navBar pushNavigationItem:item animated:NO];
    [item release];
    [_navBarBack release];
    [_IGBView addSubview:_navBar];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _screenWidth - 44, _screenHeight, 44)];
    [_toolbar setFrame:CGRectMake(0, _screenWidth - 44, _screenHeight, 44)];

	_forwardButton.enabled = NO;
    _backButton.enabled = NO;
	
	// Flexible space	
    _fixedSpace.width = 40.0f;
	
	// Assign buttons to toolbar
	_toolbar.items = [NSArray arrayWithObjects:_backButton, _fixedSpace,_forwardButton, _flexibleSpace, _reloadButton, nil];
    
    [_IGBView addSubview:_toolbar];
    [_parentView addSubview:_IGBView];
        
    [self orientationChanged];
}

#pragma mark - IGB link creation

-(void) getIGBLink
{
	urlAddressIGB = K_LINK_IGB_PARAMS;
    
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"FROM"  withString:_gameCode];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"VERSION" withString:_gameVersion];
	
	NSString* localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	if (localeIdentifier == nil)
	{
		localeIdentifier = @"XX";	//wrong country
	}

	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"LANG"  withString:TXT_LANGUAGE_LIST_IGB[_languageIndex]];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"COUNTRY"  withString:localeIdentifier];
    
    if(system(NULL))
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"JAILBRAKE"  withString:@"1"];
    }
    else
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"JAILBRAKE"  withString:@"0"];
    }
    
    NSString* idfa = @"00000000-0000-0000-0000-000000000000";
    NSString* idfv = @"00000000-0000-0000-0000-000000000000";

    if(NSClassFromString(@"ASIdentifierManager"))
    {
        if([ASIdentifierManager sharedManager].advertisingTrackingEnabled)
			idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"D_IDFA" withString:idfa];
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"D_IDFV" withString:idfv];
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"CLIENT_ID" withString:_clientID];	
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"CURRENT_USER_AGE" withString:[NSString stringWithFormat:@"%d", _userAge]];	

    if(_anonymousAccount && [_anonymousAccount length] >0)
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"ANONYMOUS_ACCOUNT"  withString:_anonymousAccount];
    }
    if(_facebookID && [_facebookID length] >0)
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"FACEBOOK_ID"  withString:_facebookID];
    }
    if(_gliveAccount && [_gliveAccount length] >0)
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"GLIVE_USERNAME"  withString:_gliveAccount];
    }
    if(_gameCenterUID && [_gameCenterUID length] >0)
    {
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"GAMECENTER_UID"  withString:_gameCenterUID];
    }
	    
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"DEVICE"  withString: platform];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"FIRMWARE"  withString:[[UIDevice currentDevice] systemVersion]];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"UDIDPHONE"  withString:macaddressIGB()];
    
    switch (_userGender)
    {
        case InGameBrowser::GENDER_MALE:
            urlAddressIGB = [urlAddressIGB stringByAppendingString:@"&gender=male"];
        break;
	
        case InGameBrowser::GENDER_FEMALE:
            urlAddressIGB = [urlAddressIGB stringByAppendingString:@"&gender=female"];
        break;
    }	
	
    if(_banType>=0)
        urlAddressIGB = [urlAddressIGB stringByAppendingString:[NSString stringWithFormat:@"&extra_14=%d", _banType]];
	
	urlAddressIGB = [[NSString alloc] initWithFormat:@"%@", [self encryptParams]];
}

#pragma mark - Link creation

-(void) getLink: (NSString*)category withAdditionalParams:(NSString*)additionalParams
{
    NSString* link = [NSString stringWithFormat:K_LINK_BASE, _baseURL];	
    urlAddressIGB = [NSString stringWithFormat:K_LINK_PARAMS, category];
    [self replaceLinkParams];

    switch (_userGender)
    {
        case InGameBrowser::GENDER_MALE:
            urlAddressIGB = [urlAddressIGB stringByAppendingString:@"&gender=male"];
        break;
	
        case InGameBrowser::GENDER_FEMALE:
            urlAddressIGB = [urlAddressIGB stringByAppendingString:@"&gender=female"];
        break;
    }	
    
    if (additionalParams != nil)
        urlAddressIGB = [NSString stringWithFormat:@"%@%@", urlAddressIGB, additionalParams];
    
    urlAddressIGB = [[NSString alloc] initWithFormat:@"%@%@", link, [self encryptParams]];
}

-(void) getFacebookLink:(NSString*)linkType withAdditionalParams:(NSString*)additionalParams
{
    NSString* link = [NSString stringWithFormat:K_LINK_BASE, _baseURL];	 

    if ([linkType isEqualToString:@"page"])
    {
        urlAddressIGB = [NSString stringWithFormat:K_LINK_PARAMS, @"facebook"];
        urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"&ctg="  withString:@"&t="];
    }
    else
        urlAddressIGB = [NSString stringWithFormat:K_LINK_PARAMS, @"FBOOK"];
	
    [self replaceLinkParams];
    
    if (additionalParams != nil)
        urlAddressIGB = [NSString stringWithFormat:@"%@%@", urlAddressIGB, additionalParams];
    
    urlAddressIGB = [[NSString alloc] initWithFormat:@"%@%@", link, [self encryptParams]];
}

-(void) replaceLinkParams
{
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"FROM"  withString:_gameCode];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"VERSION" withString:_gameVersion];

	NSString* localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	if (localeIdentifier == nil)
	{
		localeIdentifier = @"XX";	//wrong country
	}
    
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"LANG"  withString:TXT_LANGUAGE_LIST_IGB[_languageIndex]];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"COUNTRY"  withString:localeIdentifier];
    
    NSString* idfa = @"00000000-0000-0000-0000-000000000000";
    NSString* idfv = @"00000000-0000-0000-0000-000000000000";
    if(NSClassFromString(@"ASIdentifierManager"))
    {
        if([ASIdentifierManager sharedManager].advertisingTrackingEnabled)
			idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"D_IDFA" withString:idfa];
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"D_IDFV" withString:idfv];
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"CLIENT_ID" withString:_clientID];
    urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"CURRENT_USER_AGE" withString:[NSString stringWithFormat:@"%d", _userAge]];		
       
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"DEVICE"  withString: platform];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"FIRMWARE"  withString:[[UIDevice currentDevice] systemVersion]];
	urlAddressIGB = [urlAddressIGB stringByReplacingOccurrencesOfString:@"UDIDPHONE"  withString:macaddressIGB()];
	        
	NSLog(@"%@\n", urlAddressIGB);
}


-(NSString*)encryptParams
{
    NSString* key = @"qPKBGA==";
	NSData *plain = [urlAddressIGB dataUsingEncoding:NSASCIIStringEncoding];
	NSData *cipher = [InGameBrowserNative EncryptAES_IGB:key:plain];	
	
	return [NSString stringWithFormat:K_LINK_POST_BASE, [InGameBrowserNative encodeBase64WithData_IGB:cipher]];
}

-(void)setBaseURL:(NSString*)baseURL
{
	if ([baseURL hasSuffix:@"/"])
		_baseURL = [[NSString stringWithFormat:@"%@", baseURL] retain];
	else
		_baseURL = [[NSString stringWithFormat:@"%@/", baseURL] retain];
}

-(void)setUserAge:(unsigned int)userAge
{
    _userAge = (userAge >= 13) ? userAge : 0;
}

-(void)setUserGender:(InGameBrowser::UserGender)userGender
{
    _userGender = userGender;
}


- (void)orientationChanged
{
    if(!_isInIGBrowser)
        return;

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    
#ifdef IGB_PORTRAIT_SUPPORT
    if((orientation == UIInterfaceOrientationLandscapeLeft)||(orientation == UIInterfaceOrientationLandscapeRight))
#endif
    {
              
        
//        [_activityIndicator setCenter:CGPointMake(_screenHeight/2, _screenWidth/2)];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            
//            [_activityIndicator setBounds:CGRectMake(0, 0, 32, 32)];
            
            [_IGBWebView setFrame:CGRectMake(0, 32, _screenHeight, _screenWidth -32 -44)];//(WEBVIEW_IPHONE_LANDSCAPE_OFFSET_X, WEBVIEW_IPHONE_LANDSCAPE_OFFSET_Y, _screenHeight, WEBVIEW_IPHONE_LANDSCAPE_H)];
            [_navBar setFrame:CGRectMake(0, 0, _screenHeight, 32)];
            [_toolbar setFrame:CGRectMake(0, _screenWidth - 44, _screenHeight, 44)];
        }
        else {
            
//            [_activityIndicator setBounds:CGRectMake(0, 0, 64, 64)];
            [_IGBWebView setFrame:CGRectMake(0, 44, _screenHeight, _screenWidth - 44 - 44)];//(WEBVIEW_IPAD_LANDSCAPE_OFFSET_X, WEBVIEW_IPAD_LANDSCAPE_OFFSET_Y, _screenHeight, WEBVIEW_IPAD_LANDSCAPE_H)];
            [_navBar setFrame:CGRectMake(0, 0, _screenHeight, 44)];
            [_toolbar setFrame:CGRectMake(0, _screenWidth - 44, _screenHeight, 44)];
        }
        
        
        
    }
#ifdef IGB_PORTRAIT_SUPPORT
    else {
        
//        [_activityIndicator setCenter:CGPointMake(_screenWidth/2, _screenHeight/2)];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
           
//            [_activityIndicator setBounds:CGRectMake(0, 0, 32, 32)];
            [_IGBWebView setFrame:CGRectMake(0, 32, _screenWidth, _screenHeight -32 -44)];
            [_navBar setFrame:CGRectMake(0, 0, _screenWidth, 32)];
            [_toolbar setFrame:CGRectMake(0, _screenHeight - 44, _screenWidth, 44)];
        }
        else {
            
//            [_activityIndicator setBounds:CGRectMake(0, 0, 64, 64)];
            [_IGBWebView setFrame:CGRectMake(0, 44, _screenWidth, _screenHeight -32 -44)];
            [_navBar setFrame:CGRectMake(0, 0, _screenWidth, 32)];
            [_toolbar setFrame:CGRectMake(0, _screenHeight - 44, _screenWidth, 44)];
        }
        
    }
#endif
    switch (orientation) {

#ifdef IGB_PORTRAIT_SUPPORT
        case UIInterfaceOrientationPortrait:
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                _IGBView.transform = CGAffineTransformMakeRotation(0);
            }
//            [_IGBView setCenter:CGPointMake(_screenWidth/2, _screenHeight/2)];
//            [_IGBView setBounds:CGRectMake(0, 0, _screenWidth, _screenHeight)];
            [_IGBView setCenter:CGPointMake(_screenWidth/2, _screenHeight/2)];
            [_IGBView setBounds:CGRectMake(0, 0, _screenWidth, _screenHeight)];
            
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                _IGBView.transform = CGAffineTransformMakeRotation(M_PI);
            }
//            [_IGBView setCenter:CGPointMake(_screenWidth/2, _screenHeight/2)];
//            [_IGBView setBounds:CGRectMake(0, 0, _screenWidth, _screenHeight)];
            [_IGBView setCenter:CGPointMake(_screenWidth/2, _screenHeight/2)];
            [_IGBView setBounds:CGRectMake(0, 0, _screenWidth, _screenHeight)];
            
            break;
#endif
            
        case UIInterfaceOrientationLandscapeLeft:
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                _IGBView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }
            
            
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                [_IGBView setCenter:CGPointMake((_screenWidth )/2, _screenHeight/2)];
            }
            else
            {
                [_IGBView setCenter:CGPointMake(_screenHeight/2, (_screenWidth )/2)];
            }

            [_IGBView setBounds:CGRectMake(0, 0, _screenHeight, _screenWidth)];
            
            
            break;
        default:
            
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                _IGBView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
            
            if(!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
            {
                [_IGBView setCenter:CGPointMake((_screenWidth )/2, _screenHeight/2)];
            }
            else
            {
                [_IGBView setCenter:CGPointMake(_screenHeight/2, (_screenWidth )/2)];
            }
            [_IGBView setBounds:CGRectMake(0, 0, _screenHeight, _screenWidth)];
            
            break;
            
    }
}
- (void)quitIGB
{
    if(!_isInIGBrowser)
        return;
        
    if(_newsWereDisplayed)
    {
        [self refreshUnreadNewsNumberInternal];
    }
	
    if (insideDirectLinkQuery == YES)
    {
        [directLinkConnection cancel];        
        [directLinkData release];
        directLinkData = nil;
        [directLinkConnection release];
        directLinkConnection = nil;
    }
	
	_newsWereDisplayed = NO;
    _banType = -1;

    [urlAddressIGB release];
    urlAddressIGB = nil;
//    [_gameVersion release];
//    [_activityIndicator removeFromSuperview];
//    [_activityIndicator release];
//    _activityIndicator = nil;
    
    [_IGBWebView stopLoading];
    [_IGBWebView setDelegate:nil];
    [_IGBWebView removeFromSuperview];
    [_IGBWebView release];
    _IGBWebView = nil;
    [_navBar removeFromSuperview];
    [_navBar release];
    [_toolbar removeFromSuperview];
    [_toolbar release];
    
    
    [_IGBView removeFromSuperview];
    [_IGBView release];
    _IGBView = nil;
    
    if(_IGBTimer)
    {
        [_IGBTimer invalidate];
        _IGBTimer = nil;
    }
    
    _isInIGBrowser = FALSE;
    
    extern void checkForReward(const char* provider = "");
    checkForReward("gameloft");
    
}

- (void)reload
{
	[_IGBWebView reload];
}
- (void)goBack
{
	if (_IGBWebView.canGoBack == YES) {
		// We can go back. So make the web view load the previous page.
		[_IGBWebView goBack];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}

- (void)goForward
{
	if (_IGBWebView.canGoForward == YES) {
		// We can go forward. So make the web view load the next page.
		[_IGBWebView goForward];
		
		// Check the status of the forward/back buttons
		[self checkNavigationStatus];
	}
}
- (void)checkNavigationStatus
{
	// Check if we can go forward or back
	_backButton.enabled = _IGBWebView.canGoBack;
	_forwardButton.enabled = _IGBWebView.canGoForward;
}

- (CGContextRef)createContext
{
    // create the bitmap context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0,
                                                 colorSpace,kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    return context;
}

- (CGImageRef)createBackArrowImageRef
{
    CGContextRef context = [self createContext];
	
    // set the fill color
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
	
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8.0f, 12.0f);
    CGContextAddLineToPoint(context, 24.0f, 3.0f);
    CGContextAddLineToPoint(context, 24.0f, 21.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);
	
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
	
    return image;
}

- (UIBarButtonItem *)backButton
{
    CGImageRef theCGImage = [self createBackArrowImageRef];
    UIImage *backImage = [[UIImage alloc] initWithCGImage:theCGImage];
    CGImageRelease(theCGImage);
	
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goBack)];
    
    [backImage release], backImage = nil;
	
    return [backButton autorelease];
}
#pragma mark NEWS methods

-(void)refreshUnreadNewsNumber
{
    if(_checkNewsNumberConnection != nil)
    {
        NSLog(@" refreshing news number in progress...");
        return;
    }
    
    NSString* urlString;
       
    _lastUnreadNewsIndex = [self getLastNewsIndex];
    
    [self getIGBLink];
    urlString = [NSString stringWithFormat:K_LINK_CHECK_UNREAD_NEWS_NUMBER, _baseURL, _lastUnreadNewsIndex];
    NSURL *url = [NSURL URLWithString:urlString];
    
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setHTTPMethod:@"POST"];
    [requestObj setHTTPBody:[urlAddressIGB dataUsingEncoding:NSUTF8StringEncoding]];
    _checkNewsNumberConnection = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self startImmediately:YES];
    _receivedDataNewsNumber = [[NSMutableData data] retain];
    
    NSLog(@"urlString = %@", urlString);
    NSLog(@"urlAddressIGB = %@", urlAddressIGB);
}

-(void)refreshUnreadNewsNumberInternal
{
    if(_checkNewsNumberConnectionSave != nil)
    {
        NSLog(@" refreshing news number in progress...");
        return;
    }
    
    NSString* urlString;
    
    _lastUnreadNewsIndex = [self getLastNewsIndex];
    
    [self getIGBLink];
    urlString = [NSString stringWithFormat:K_LINK_SAVE_NEWS_ID, _baseURL, _lastUnreadNewsIndex];
    NSURL *url = [NSURL URLWithString:urlString];
    
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setHTTPMethod:@"POST"];
    [requestObj setHTTPBody:[urlAddressIGB dataUsingEncoding:NSUTF8StringEncoding]];
    _checkNewsNumberConnectionSave = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self startImmediately:YES];
    _receivedDataNewsNumberSave = [[NSMutableData data] retain];
    
    NSLog(@"urlString = %@", urlString);
    NSLog(@"urlAddressIGB = %@", urlAddressIGB);
}

-(void)setUnreadNewsChangedCallback:(InGameBrowser::TUnreadNewsChangedCallback)pCallback
{
    unreadNewsChangedCallback = pCallback;
}

#pragma mark - CC webView delegates

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
	NSLog(@"should start loading with:%@",urlString);
//    [_activityIndicator startAnimating];
    if(_IGBTimer)
    {
        [_IGBTimer invalidate];
        _IGBTimer = nil;
    }
    _IGBTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(igpTimerTimeout) userInfo:nil repeats:NO];
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		NSURL *url = [NSURL URLWithString:urlString];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[webView loadRequest:requestObj];
        if(_IGBTimer)
        {
            [_IGBTimer invalidate];
            _IGBTimer = nil;
        }
		return NO;
	}
	
	if([urlString hasPrefix:@"http://phobos.apple.com"]||[urlString hasPrefix:@"http://itunes.apple.com"]||[urlString hasPrefix:@"https://itunes.apple.com"])
	{
//		[_activityIndicator stopAnimating];
        if(_IGBTimer)
        {
            [_IGBTimer invalidate];
            _IGBTimer = nil;
        }
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return NO;
	}
	if([urlString hasPrefix:@"play:"])
	{
//		[_activityIndicator stopAnimating];
        if(_IGBTimer)
        {
            [_IGBTimer invalidate];
            _IGBTimer = nil;
        }
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString substringFromIndex:5]]];
        return NO;
	}
    if([urlString hasPrefix:@"exit:"])
	{
//		[_activityIndicator stopAnimating];
        if(_IGBTimer)
        {
            [_IGBTimer invalidate];
            _IGBTimer = nil;
        }
        [self quitIGB];
        return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
   _toolbar.items = [NSArray arrayWithObjects:_backButton, _fixedSpace, _forwardButton, _flexibleSpace, _loadingButton, nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//	[_activityIndicator stopAnimating];
    if(_IGBTimer)
    {
        [_IGBTimer invalidate];
        _IGBTimer = nil;
    }
    [self checkNavigationStatus];
    _toolbar.items = [NSArray arrayWithObjects:_backButton, _fixedSpace, _forwardButton, _flexibleSpace, _reloadButton, nil];
}

- (void)webView:(UIWebView *)webView didFailWithError:(NSError *)error
{
	NSLog(@"Error:%@", [error localizedDescription]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    [self checkNavigationStatus];
}
-(void)igpTimerTimeout
{
    NSString *_message_lang = TXT_NET_ERROR_IGB[_languageIndex];
	NSString *_ok_lang = TXT_OK_IGP_IGB[_languageIndex];
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_message_lang delegate:self cancelButtonTitle:_ok_lang otherButtonTitles:nil];
	[alert show];
	[alert release];
    [self quitIGB];
}
#pragma mark connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    
    if (connection == directLinkConnection)
        directLinkData = [[NSMutableData data] retain];    
    
    if(connection == _checkNewsNumberConnection)
    {
        [_receivedDataNewsNumber setLength:0];        
    }
	
    if(connection == _checkNewsNumberConnectionSave)
    {
        [_receivedDataNewsNumberSave setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere    
    //NSLog(@"did receive data");    
    if (connection == directLinkConnection)
        [directLinkData appendData:data];	

    if(connection == _checkNewsNumberConnection)
    {
        [_receivedDataNewsNumber appendData:data];
    }
    if(connection == _checkNewsNumberConnectionSave)
    {
        [_receivedDataNewsNumberSave appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection did failed with error:%@", [error localizedDescription]);

    if (connection == directLinkConnection)
    {
        [directLinkData release];
        directLinkData = nil;
        [directLinkConnection release];
        directLinkConnection = nil;		
        insideDirectLinkQuery = NO;
        
        if (_facebookShareLinkCallback != nil)
            (*_facebookShareLinkCallback)("");
    }
	
    if(connection == _checkNewsNumberConnection)
    {
        [_receivedDataNewsNumber release];
        _receivedDataNewsNumber = nil;
        [_checkNewsNumberConnection release];
        _checkNewsNumberConnection = nil;
        
    }
    if(connection == _checkNewsNumberConnectionSave)
    {
        [_receivedDataNewsNumberSave release];
        _receivedDataNewsNumber = nil;
        [_checkNewsNumberConnection release];
        _checkNewsNumberConnection = nil;
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == directLinkConnection)
    {
        NSString* responseString = [[NSString alloc] initWithData:directLinkData encoding:NSUTF8StringEncoding];
        NSLog(@"directLink = %@", responseString);		
	
        if (_facebookShareLinkCallback != nil)
        {
            (*_facebookShareLinkCallback)([responseString UTF8String]);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseString]];
                [responseString release];
            });
        }
       
       [directLinkData release];
       directLinkData = nil;
       [directLinkConnection release];
       directLinkConnection = nil; 
       insideDirectLinkQuery = NO;
    }

    if(connection == _checkNewsNumberConnection)
    {
        NSString* responseString = [[NSString alloc] initWithData:_receivedDataNewsNumber encoding:NSUTF8StringEncoding];
        NSLog(@"data = %@",responseString);
        [responseString release];
        responseString = nil;
        
        NSError* jsonParseError = nil;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:_receivedDataNewsNumber options:0 error:&jsonParseError];
        
        if(jsonParseError == nil)
        {
            BOOL success = [[responseDictionary objectForKey:@"success"] boolValue];
            if(success == true)
            {
                if(unreadNewsChangedCallback)
                {
//                    if(_unreadNewsNumber != [[responseDictionary objectForKey:@"unread"] intValue])
                    {
                        _unreadNewsNumber = [[responseDictionary objectForKey:@"unread"] intValue];
                        unreadNewsChangedCallback(_unreadNewsNumber);
                    }
                }
                else
                {
                    _unreadNewsNumber = [[responseDictionary objectForKey:@"unread"] intValue];
                }
            }
            else
            {
                NSLog(@"error getting news number: %@", [responseDictionary objectForKey:@"message"]);
            }
            
        }
        else{
            NSLog(@"error parsing json:%@", [jsonParseError localizedDescription]);
        }
        
        [_receivedDataNewsNumber release];
        _receivedDataNewsNumber = nil;
        [_checkNewsNumberConnection release];
        _checkNewsNumberConnection = nil;
    }
    
    
    if(connection == _checkNewsNumberConnectionSave)
    {
        NSString* responseString = [[NSString alloc] initWithData:_receivedDataNewsNumberSave encoding:NSUTF8StringEncoding];
        NSLog(@"data = %@",responseString);
        [responseString release];
        responseString = nil;
        
        NSError* jsonParseError = nil;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:_receivedDataNewsNumberSave options:0 error:&jsonParseError];
        
        if(jsonParseError == nil)
        {
            BOOL success = [[responseDictionary objectForKey:@"success"] boolValue];
            if(success == true)
            {
                _lastUnreadNewsIndex = [[responseDictionary objectForKey:@"current-id"] intValue];
                [self saveLastNewsIndex:_lastUnreadNewsIndex];
                if(unreadNewsChangedCallback)
                {
//                    if(_unreadNewsNumber != [[responseDictionary objectForKey:@"unread"] intValue])
                    {
                        _unreadNewsNumber = 0;
                        unreadNewsChangedCallback(_unreadNewsNumber);
                    }
                }
                else
                {
                    _unreadNewsNumber = 0;
                }
            }
            else
            {
                NSLog(@"error getting news number: %@", [responseDictionary objectForKey:@"message"]);
            }
            
        }
        else{
            NSLog(@"error parsing json:%@", [jsonParseError localizedDescription]);
        }
        
        [_receivedDataNewsNumberSave release];
        _receivedDataNewsNumberSave = nil;
        [_checkNewsNumberConnectionSave release];
        _checkNewsNumberConnectionSave = nil;
        
    }
    
}
#pragma mark news index read/write

-(int)getLastNewsIndex
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	if (localeIdentifier == nil)
	{
		localeIdentifier = @"XX";	//wrong country
	}
    
    
    NSString* fileName = [NSString stringWithFormat:@"%@/lastnewsindex/LNI_%@_%@.txt", [paths objectAtIndex:0],localeIdentifier, TXT_LANGUAGE_LIST_IGB[_languageIndex]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:fileName])
    {
        NSString* lastNewsIndex = [NSString stringWithContentsOfFile:fileName usedEncoding:nil error:nil];
        return [lastNewsIndex intValue];
    }
    else
    {
        return 0;
    }
    
}
-(void)saveLastNewsIndex:(int)lastNewsIndex
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	if (localeIdentifier == nil)
	{
		localeIdentifier = @"XX";	//wrong country
	}
    NSString* cachesDirectory = [paths objectAtIndex:0];
    NSString* lastNewsIndexDirectory = [cachesDirectory stringByAppendingPathComponent:@"/lastnewsindex"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:lastNewsIndexDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:lastNewsIndexDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
        NSString* fileName = [NSString stringWithFormat:@"%@/LNI_%@_%@.txt", lastNewsIndexDirectory,localeIdentifier, TXT_LANGUAGE_LIST_IGB[_languageIndex]];
    
    
    [[NSString stringWithFormat:@"%d", lastNewsIndex] writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


NSString* macaddressIGB()
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
		free(buf); //cs: fix potential mem leak
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSMutableData*) EncryptAES_IGB: (NSString *) key : (NSData*)dataIn
{
	char keyPtr[kCCKeySizeDES+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [dataIn length];
	
    size_t bufferSize = dataLength + kCCBlockSizeDES;
	void *buffer = malloc(bufferSize);
	
    
    NSMutableData *output;// = [[NSData alloc] init];
    
    
    
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmDES, kCCOptionECBMode|kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeDES,
                                     NULL,
                                     [dataIn bytes], [dataIn length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
	
    output = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	if( result == kCCSuccess )
	{
		return output;
	}
    return NULL;
}
+(NSString *)encodeBase64WithData_IGB:(NSData *)objData {
	
	static char _base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
    const unsigned char * objRawData = (const unsigned char *)[objData bytes];
    char * objPointer;
    char * strResult;
	
    // Get the Raw Data length and ensure we actually have data
    int intLength = (int)[objData length];
    if (intLength == 0) return nil;
	
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc(((intLength + 2) / 3) * 4+1, sizeof(char));
    objPointer = strResult;
	
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
		
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
	
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
	
    // Terminate the string-based result
    *objPointer = '\0';
	
    // Return the results as an NSString object
	NSString* re =  [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
	free(strResult);
    return re;
}


@end
