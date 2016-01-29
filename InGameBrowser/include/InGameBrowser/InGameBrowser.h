#ifndef __INGAMEBROWSER__
#define __INGAMEBROWSER__

#include <string>

namespace InGameBrowser
{
	/**
	 * InGameBrowser initialization parameters.
	 */
	struct InitParams
	{
		std::string gameCode;
		std::string gameVersion;
		std::string gameLanguage;
		std::string clientID;
		std::string baseURL;
		std::string anonymousAccount;
		unsigned int userAge;
		void* parentView;
		
		InitParams()
		{
			userAge = 0;
			parentView = NULL;
		}
	};	
	
	/**
	 * The user gender.
	 */
	enum UserGender
	{
		GENDER_UNKNOWN,
		GENDER_MALE,
		GENDER_FEMALE,
	};

	/*
	* The unread news callback type
	*/
	typedef void (*TUnreadNewsChangedCallback)(int unreadNewsNumber);	
	
	/**
	 * Initialize InGameBrowser.
	 *
	 * @param initParams       The parameters to be used.
	 */
	void Init(const InitParams& initParams);

	/**
	 * Show the Customer Care page.
	 */
	void ShowCustomerCare();

	/**
	 * Show the User Banned page.
	 *
	 * @param banType     Type of ban.
	 */
	void ShowCustomerCareWithBANType(int banType);

	/**
	 * Shows the News page.
	 */
	void ShowNews();

	/**
	 * Show the Forum page.
	 */
	void ShowForum();

	/**
	 * Shows the Terms Of Use page.
	 */
	void ShowTermsOfUse();

	/**
	 * Shows the Privacy Policy page.
	 */
	void ShowPrivacyPolicy();

	/**
	 * Shows the End User License Agreement page.
	 */
	void ShowEULA();

	/**
	 * Shows or redirects to the Facebook Share page.
	 *
	 * @param directLink       If true then:
								1) a query to the server will be started
								2) the received link will be opened in an external browser
							   otherwise the link will be opened in IGB
	 */
	void ShowFacebookShare(bool directLink = true);

	/**
	 * Shows or redirects to the Facebook page.
	 *
	 * @param directLink       If true then:
								1) a query to the server will be started
								2) the received link will be opened in an external browser
							   otherwise the link will be opened in IGB
	 */
	void ShowFacebookPage(bool directLink = false);
	
	/**
	 * Shows IGB with the given url.
	 *
	 * @param url       Navigate to the given url
	 */
	void OpenURL(const std::string& url);

	/**
	 * Redirect to the new version screen link.
	 *
	 * @param directLink       If true then:
								1) a query to the server will be started
								2) the received link will be opened in an external browser
							   otherwise the link will be opened in IGB
	 */
	void LaunchBrowserGameUpdate(bool directLink = true);

	/**
	 *  Rate this application redirect.
	 *
	 * @param directLink       If true then:
								1) a query to the server will be started
								2) the received link will be opened in an external browser
							   otherwise the link will be opened in IGB
	 */
	void LaunchBrowserGameReview(bool directLink = true);

	/**
	 * Refresh the Unread News Number.
	 */
	void RefreshUnreadNewsNumber();

	/**
	 * Get the Number of Unread News.
	 */
	int GetUnreadNewsNumber();
	
	/**
	* Sets the unread news callback
	*/	
	void SetUnreadNewsChangedCallback(TUnreadNewsChangedCallback callback);

	/**
	 * Gets Facebook Share link.
	 *
	 * @param directLink      If true, it will launch the 
	 * @param facebookShareLinkCallback      Callback with link as parameter
	 */
	void GetFacebookShareLink(bool directLink, void (*facebookShareLinkCallback)(const char*));

	/**
	 * Sets IGB language.
	 *
	 * @param language      The language.
	 */
	void SetGameLanguage(const std::string& language);

	/**
	 * Sets the base URL.
	 *
	 * @param baseUrl       The string of the base URL.
	 */
	void SetBaseURL(const std::string& baseURL);

	/**
	 * Sets the use age.
	 *
	 * @param userAge      The value of the user age.
	 */
	void SetUserAge(unsigned int userAge);
	
	/**
	 * Sets the user gender.
	 *
	 * @param gender      The user's gender.
	 */
	void SetUserGender(UserGender gender);	

	/**
	 * Sets the anonymous account.
	 *
	 * @param anonymousAccount      The value of the anonymous account.
	 */
	void SetAnonymousAccount(const std::string& anonymousAccount);

	/**
	 * Sets the Facebook Account ID.
	 *
	 * @param facebookAccount      The value of the Facebook Account ID
	 */
	void SetFacebookID(const std::string& facebookID);

	/**
	 * Sets the GLLive Account ID.
	 *
	 * @param gliveAccount      The value of the GLLive Account ID
	 */
	void SetGLLiveAccount(const std::string& gliveAccount);

	/**
	 * Sets the Game Center UID
	 *
	 * @param gameCenterUID    The value of the Game Center Account ID
	 */
	void SetGameCenterUID(const std::string& gameCenterUID);		

	/**
	 * Returns true if the InGameBrowser is displayed on the screen
	 */		
	bool IsDisplayed();
};

#endif