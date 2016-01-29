#include <UIKit/UIKit.h>
#include "SimpleApp/SimpleApp.h"
#import "InGameBrowser/InGameBrowser.h"

SimpleApp* g_app = NULL;

void InitInGameBrowser();
void ShowCustomerCare();
void ShowCustomerCareWithBANType();
void ShowNews();
void ShowForum();
void ShowTermsOfUse();
void ShowPrivacyPolicy();
void ShowEULA();
void ShowFacebookShare();
void ShowFacebookPage();
void OpenURL();
void LaunchBrowserGameUpdate();
void LaunchBrowserGameReview();
void GetFacebookShareLink();

void OnPause();
void OnResume();
void OnRun();
void OnExit();

void checkForReward(const char*) {}

void Main()
{
	g_app = SimpleApp::Create("InGameBrowser Test");
	g_app->AddMenuItem("ShowCustomerCare", ShowCustomerCare);
	g_app->AddMenuItem("ShowCustomerCareWithBANType", ShowCustomerCareWithBANType);	
	g_app->AddMenuItem("ShowNews", ShowNews);
	g_app->AddMenuItem("ShowForum", ShowForum);
	g_app->AddMenuItem("ShowTerms", ShowTermsOfUse);
	g_app->AddMenuItem("ShowPrivacy", ShowPrivacyPolicy);
	g_app->AddMenuItem("ShowEULA", ShowEULA);
	g_app->AddMenuItem("ShowFacebookShare", ShowFacebookShare);
	g_app->AddMenuItem("ShowFacebookPage", ShowFacebookPage);
	g_app->AddMenuItem("OpenURL", OpenURL);
	g_app->AddMenuItem("LaunchBrowserGameUpdate", LaunchBrowserGameUpdate);
	g_app->AddMenuItem("LaunchBrowserGameReview", LaunchBrowserGameReview);
	g_app->AddMenuItem("GetFacebookShareLink", GetFacebookShareLink);
	
	g_app->SetPauseDelegate(std::bind(&OnPause));
	g_app->SetResumeDelegate(std::bind(&OnResume));
	g_app->SetRunDelegate(std::bind(&OnRun));
	g_app->SetExitDelegate(std::bind(&OnExit));
	
	InitInGameBrowser();	

	g_app->Run();
}

void InitInGameBrowser()
{
	InGameBrowser::InitParams params;
	params.gameCode = "TEST";
	params.gameVersion = "1.9.2";
	params.gameLanguage = "en";
	params.clientID = "1533:56843:1.9.2:ios:appstore";
	params.baseURL = "http://ingameads.gameloft.com";
	params.anonymousAccount = "YW5kcm9pZF82ZjYzN2Y2ZTg5N2MzYjI1";
	params.userAge = 22;
	params.parentView = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];    
	InGameBrowser::Init(params);
    InGameBrowser::SetUserGender(InGameBrowser::GENDER_MALE);
}

void ShowCustomerCare()
{
	InGameBrowser::ShowCustomerCare();
}

void ShowCustomerCareWithBANType()
{
	InGameBrowser::ShowCustomerCareWithBANType(0);
}

void ShowNews()
{
	InGameBrowser::ShowNews();
}

void ShowForum()
{
	InGameBrowser::ShowForum();
}

void ShowTermsOfUse()
{
	InGameBrowser::ShowTermsOfUse();
}

void ShowPrivacyPolicy()
{
	InGameBrowser::ShowPrivacyPolicy();
}

void ShowEULA()
{
	InGameBrowser::ShowEULA();
}

void ShowFacebookShare()
{
	InGameBrowser::ShowFacebookShare();
}

void ShowFacebookPage()
{
	InGameBrowser::ShowFacebookPage();
}

void OpenURL()
{
	InGameBrowser::OpenURL("http://www.gameloft.com");
}

void LaunchBrowserGameUpdate()
{
	InGameBrowser::LaunchBrowserGameUpdate(true);
}

void LaunchBrowserGameReview()
{
	InGameBrowser::LaunchBrowserGameReview(true);
}

void GetFacebookShareLinkCallback(const char* facebookShareLink)
{
	g_app->Alert(std::string("Facebook share link =") + facebookShareLink);
}

void GetFacebookShareLink()
{
	InGameBrowser::GetFacebookShareLink(true, GetFacebookShareLinkCallback);
}

void OnRun()
{
}

void OnPause()
{
}

void OnResume()
{
}

void OnExit()
{
	delete g_app;
}