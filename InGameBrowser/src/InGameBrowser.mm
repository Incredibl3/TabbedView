#include "InGameBrowser/InGameBrowser.h"
#include "InGameBrowserNative.h"

InGameBrowserNative* s_inGameBrowser = nil;

static void Alert(const std::string& s)
{
	NSString* messageString = [NSString stringWithCString:s.c_str() encoding:[NSString defaultCStringEncoding]];
	NSLog(@"InGameBrowser - %@", messageString);
#ifdef _DEBUG
	__builtin_trap();
#endif
}

#define REQUIRE_IGB_INITIALIZED(functionName) \
	if (s_inGameBrowser == nil) \
	{	\
		Alert(std::string(functionName) + " will be ignored. The library must be initialized."); \
		return; \
	}

#define REQUIRE_STRING_NONEMPTY(functionName, str) \
	if (str.empty()) \
	{	\
		std::string strName = #str; \
		Alert(std::string(functionName) + " will be ignored - " + strName + " is empty."); \
		return; \
	}

#define REQUIRE_VALID_POINTER(functionName, pointer) \
	if (pointer == NULL) \
	{	\
		std::string pointerName = #pointer; \
		Alert(std::string(functionName) + " will be ignored - " + pointerName + " is NULL."); \
		return; \
	}

	
void InGameBrowser::Init(const InitParams& initParams)
{
	if (s_inGameBrowser != nil)
	{
		Alert("InGameBrowser::Init will be ignored. Library is already initialized");	
		return;
	}

	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.gameCode);	
	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.gameVersion);
	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.gameLanguage);
	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.clientID);
	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.baseURL);
	REQUIRE_STRING_NONEMPTY("InGameBrowser::Init", initParams.anonymousAccount);
	REQUIRE_VALID_POINTER("InGameBrowser::Init", initParams.parentView);
	
	s_inGameBrowser = [InGameBrowserNative sharedInGameBrowserNative];
	s_inGameBrowser.gameCode = [NSString stringWithCString:initParams.gameCode.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.gameVersion = [NSString stringWithCString:initParams.gameVersion.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.gameLanguage = [NSString stringWithCString:initParams.gameLanguage.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.clientID = [NSString stringWithCString:initParams.clientID.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.baseURL = [NSString stringWithCString:initParams.baseURL.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.anonymousAccount = [NSString stringWithCString:initParams.anonymousAccount.c_str() encoding:[NSString defaultCStringEncoding]];
	s_inGameBrowser.userAge = initParams.userAge;	
	s_inGameBrowser.parentView = (UIView*)initParams.parentView;
}

void InGameBrowser::ShowCustomerCare()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowCustomerCare");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showCustomerCare];
	});
}

void InGameBrowser::ShowCustomerCareWithBANType(int banType)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowCustomerCareWithBANType");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showCustomerCareWithBANType:banType];
	});
}

void InGameBrowser::ShowNews()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowNews");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showNews];
	});
}

void InGameBrowser::ShowForum()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowForum");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showForum];
	});
}

void InGameBrowser::ShowTermsOfUse()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowTermsOfUse");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showTermsOfUse];
	});
}

void InGameBrowser::ShowPrivacyPolicy()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowPrivacyPolicy");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showPrivacyPolicy];
	});
}

void InGameBrowser::ShowEULA()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowEULA");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showEULA];
	});
}

void InGameBrowser::ShowFacebookShare(bool directLink)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowFacebookShare");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showFacebookShare:directLink];
	});
}

void InGameBrowser::ShowFacebookPage(bool directLink)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::ShowFacebookPage");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser showFacebookPage:directLink];
	});
}


void InGameBrowser::OpenURL(const std::string& url)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::OpenURL");
	REQUIRE_STRING_NONEMPTY("InGameBrowser::OpenURL", url);
		
	NSString* link = [NSString stringWithCString:url.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser openCustomLink:link withPostString:nil];
	});
}

void InGameBrowser::LaunchBrowserGameUpdate(bool directLink)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::LaunchBrowserGameUpdate");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser launchBrowserGameUpdate:directLink];
	});
}

void InGameBrowser::LaunchBrowserGameReview(bool directLink)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::LaunchBrowserGameReview");
	dispatch_async(dispatch_get_main_queue(), ^
	{	
		[s_inGameBrowser launchBrowserGameReview:directLink];
	});
}

void InGameBrowser::GetFacebookShareLink(bool directLink, void (*facebookShareLinkCallback)(const char*))
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::GetFacebookShareLink");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser getFacebookShareLink:directLink withCallback:facebookShareLinkCallback];
	});
}

void InGameBrowser::RefreshUnreadNewsNumber()
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::RefreshUnreadNewsNumber");	
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser refreshUnreadNewsNumber];
	});
}

int InGameBrowser::GetUnreadNewsNumber()
{
	if (s_inGameBrowser == nil)
	{
		Alert("InGameBrowser::GetUnreadNewsNumber will be ignored. The library must be initialized.");
		return 0;
	}

	return s_inGameBrowser.unreadNewsNumber;
}

void InGameBrowser::SetGameLanguage(const std::string& gameLanguage)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetGameLanguage");
	REQUIRE_STRING_NONEMPTY("InGameBrowser::SetGameLanguage", gameLanguage);
	
	NSString* gameLanguageString = [NSString stringWithCString:gameLanguage.c_str() encoding:[NSString defaultCStringEncoding]];	
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setGameLanguage:gameLanguageString];
	});
}

void InGameBrowser::SetBaseURL(const std::string& baseURL)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetBaseURL");
	REQUIRE_STRING_NONEMPTY("InGameBrowser::SetBaseURL", baseURL);	

	NSString* baseURLString = [NSString stringWithCString:baseURL.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setBaseURL:baseURLString];
	});
}

void InGameBrowser::SetUserAge(unsigned int userAge)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetUserAge");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setUserAge:userAge];
	});
}

void InGameBrowser::SetUserGender(UserGender gender)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetUserGender");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setUserGender:gender];
	});
}


void InGameBrowser::SetAnonymousAccount(const std::string& anonymousAccount)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetAnonymousAccount");

	NSString* anonymousAccountString = [NSString stringWithCString:anonymousAccount.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setAnonymousAccount:anonymousAccountString];
	});	
}

void InGameBrowser::SetFacebookID(const std::string& facebookID)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetFacebookID");

	NSString* facebookIDString = [NSString stringWithCString:facebookID.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setFacebookID:facebookIDString];
	});
}

void InGameBrowser::SetGLLiveAccount(const std::string& gliveAccount)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetGliveAccount");

	NSString* gliveAccountString = [NSString stringWithCString:gliveAccount.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setGliveAccount:gliveAccountString];
	});
}

void InGameBrowser::SetGameCenterUID(const std::string& gameCenterUID)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetGameCenterUID");

	NSString* gameCenterUIDString = [NSString stringWithCString:gameCenterUID.c_str() encoding:[NSString defaultCStringEncoding]];
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setGameCenterUID:gameCenterUIDString];
	});		
}

bool InGameBrowser::IsDisplayed()
{
	if (s_inGameBrowser == nil)
	{
		Alert("InGameBrowser::IsDisplayed will be ignored. The library must be initialized.");
		return false;
	}

	return s_inGameBrowser.isInIGBrowser;
}

void InGameBrowser::SetUnreadNewsChangedCallback(TUnreadNewsChangedCallback callback)
{
	REQUIRE_IGB_INITIALIZED("InGameBrowser::SetUnreadNewsChangedCallback");
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[s_inGameBrowser setUnreadNewsChangedCallback:callback];
	});
}
