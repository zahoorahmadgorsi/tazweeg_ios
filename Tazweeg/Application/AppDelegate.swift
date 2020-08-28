//
//  AppDelegate.swift
//  Coffee & Go
//
//  Created by Tazweeg on 01/01/2019.
//  Copyright © 2018 Tazweeg. All rights reserved.
//

import UIKit
import LocalAuthentication
import SlideMenuControllerSwift
import MOLH
import EAIntroView

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MOLHResetable {
    var window: UIWindow?
    var lang = ""
    var isConsultantLogin = false
    /// An authentication context stored at class scope so it's available for use during UI updates.
    var context = LAContext()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor(hexString: appColors.defaultColor.rawValue)
        bar.isTranslucent = false
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let font = UIFont.systemFont(ofSize: 17)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: appColors.blackColor.rawValue),NSAttributedStringKey.font: font]
        }else{  //tablet
            let font = UIFont.systemFont(ofSize: 27)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: appColors.blackColor.rawValue),NSAttributedStringKey.font: font]
        }
        isConsultantLogin = (UserDefaults.standard.object(forKey: "isConsultantLogin") != nil)
        isAlreadyLoggedIn(isLanguageResetOrSignedOut: false)
        MOLH.shared.activate(true)
        //MOLH.shared.specialKeyWords = ["Cancel","Done"]
        registerForPushNotifications() //here ensures the app will attempt to register for push notifications any time it’s launched.
        // set the delegate in didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
              
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings() //This is important as the user can, at any time, go into the Settings app and change their notification permissions.
        }
      }
    
    //if the user declines the permissions?
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        //The user has granted notification permissions
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          //kick off registration with the Apple Push Notification service. You need to call it on the main thread, or you’ll receive a runtime warning.
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }

    //Once the APNS registration completes, iOS calls
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "deviceToken") //Saving full user into shared preferences
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
     
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    // When launguage is change from the UserSelection VC we are reloadingthe controller
    func reset() {
        isAlreadyLoggedIn(isLanguageResetOrSignedOut: true)
    }
    
    //This function first checks if we can even check local authentication or not if not then it just goes to home screen
    //if we can perorm local authentication, then its performing local authentication and at success its going to home screen
    //at local authentication failure its logging out the user i.e. sending back to user selection screen.
    func performLocalAuthentication()
    {
        //Get a fresh context for each login. If you use the same context on multiple attempts (by commenting out the next line), then a previously successful authentication causes the next policy evaluation to succeed without testing biometry again. That's usually not what you want.
            context = LAContext()
            
            context.localizedCancelTitle = "faceID_enter_credentials".localized
            // First check if we have the needed hardware support.
            var error: NSError?
//            The biometryType, which affects this app's UI when state changes, is only meaningful after running canEvaluatePolicy. But make sure not to run this test from inside a policy evaluation callback (for example, don't put next line in the state's didSet method, which is triggered as a result of the state change made in the callback), because that might result in deadlock.
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "faceID_login".localized
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.navigateAfterLogin()
                        }
                    } else {
//                        print(error?.localizedDescription ?? "Failed to authenticate")
                        // Fall back to a asking for username and password.
                        DispatchQueue.main.async { [unowned self] in
                            Utility.logout()
                        }
                    }
                }
            } else {
//                print(error?.localizedDescription ?? "Can't evaluate policy")
                self.navigateAfterLogin()
            }
    }
    
    //This function only checks if user is not logged then redirects to user selection page
    // But if user is already logged in then first it checks if user has enabled local authentication from settings or not. if enabled then it peforms the loca authentication else navigates to main screen
    //isAlreadyLoggedIn is called from many places, isJustSignedOut lets you know whether this function was called from just click on sign out
    func isAlreadyLoggedIn( isLanguageResetOrSignedOut : Bool) {
        if Utility.isLoggedIn() {
            // == nil mean this key doesnt exist which mean user has not set any thing yet, so default behavior is to enable FaceID
            if ((UserDefaults.standard.object(forKey: Constants.strIsFaceIDEnabled)) == nil || UserDefaults.standard.bool(forKey: Constants.strIsFaceIDEnabled) != false){
                performLocalAuthentication() //For speedy development disable it from settings
            }else{ //Key does exist in userdefault and its value is false
                navigateAfterLogin() //no need of faceid
            }
        }
        else if(isLanguageResetOrSignedOut) {
            loadUserSelectionVC()
        }else{
            //it could be on verification code ui, and this method is called when app came on front
        }
    }
    
    func navigateAfterLogin()
    {
        Constants.loggedInMember = Utility.getLoggedInMember()
        if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.member.rawValue)//Member
        {
            let homeVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileVC) as! HomeVC
            let itemHome = UITabBarItem()
            itemHome.title = "home".localized
            itemHome.image = UIImage(named: "home_inactive")
            itemHome.selectedImage = UIImage(named: "home_active")?.withRenderingMode(.alwaysOriginal)
            homeVC.tabBarItem = itemHome
            let homeVCNav = UINavigationController(rootViewController: homeVC)
            
            let profileVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
            profileVC.pageType = .profile
            profileVC.memberDetail = Constants.loggedInMember
            let itemProfile = UITabBarItem()
            itemProfile.title = "profile".localized
            itemProfile.image = UIImage(named: "profile_inactive")
            itemProfile.selectedImage = UIImage(named: "profile_active")?.withRenderingMode(.alwaysOriginal)
            profileVC.tabBarItem = itemProfile
            let memberDetailVCNav = UINavigationController(rootViewController: profileVC)

            let matchingsVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .profileDetailVC) as! ProfileDetailVC
            matchingsVC.pageType = .choosings
            matchingsVC.memberDetail = Constants.loggedInMember
            let itemMatchings = UITabBarItem()
            itemMatchings.title = "matchings".localized
            itemMatchings.image = UIImage(named: "matching_inactive")
            itemMatchings.selectedImage = UIImage(named: "matching_active")?.withRenderingMode(.alwaysOriginal)
            matchingsVC.tabBarItem = itemMatchings
            let memberMatchingsVCNav = UINavigationController(rootViewController: matchingsVC)
            
            let groupedSettingsVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .groupedSettingsVC) as! GroupedSettingsVC
            let itemSettings = UITabBarItem()
            itemSettings.title = "settings".localized
            itemSettings.image = UIImage(named: "settings_inactive")
            itemSettings.selectedImage = UIImage(named: "settings_active")?.withRenderingMode(.alwaysOriginal)
            groupedSettingsVC.tabBarItem = itemSettings
            let settingsVCNav = UINavigationController(rootViewController: groupedSettingsVC)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [homeVCNav, memberDetailVCNav,memberMatchingsVCNav,settingsVCNav]
//            tabBarController.viewControllers = [homeVCNav,settingsVCNav]
            tabBarController.tabBar.tintColor = UIColor(hexString: appColors.defaultColor.rawValue) 
            tabBarController.tabBar.barTintColor = UIColor.white
            
            self.window?.rootViewController = tabBarController
            
        }else if (UserDefaults.standard.integer(forKey: "currentUser") == UserType.consultant.rawValue ||
                    UserDefaults.standard.integer(forKey: "currentUser") == UserType.admin.rawValue){
            let rightVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .slideMenuVC) as! SlideMenuVC
            let viewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .membersVC) as! MembersVC
            let viewControllerNav = UINavigationController(rootViewController: viewController)
            if MOLHLanguage.isRTLLanguage() {
                let slideMenuController = SlideMenuController(mainViewController: viewControllerNav, rightMenuViewController: rightVC )
                self.window?.rootViewController = slideMenuController
            }else{
                let slideMenuController = SlideMenuController(mainViewController: viewControllerNav, leftMenuViewController: rightVC )
                self.window?.rootViewController = slideMenuController
            }
        }
        self.window?.makeKeyAndVisible()
        self.window?.isUserInteractionEnabled = true
    }
    //Loading the User Selection view controller
    func loadUserSelectionVC(){
        let userSelectionVC = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .userSelectionVC) as! UserSelectionVC
        self.window?.rootViewController = userSelectionVC
        self.window?.makeKeyAndVisible()
        self.window?.isUserInteractionEnabled = true
    }
    
    
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    }
    
    func handleNotification(alertData: Dictionary<String,AnyObject>,state:UIApplicationState, message: String){
//        print(alertData)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("applicationWillEnterForeground")
        isAlreadyLoggedIn(isLanguageResetOrSignedOut: false)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        print("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

