//
//  YQ app
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    let beaconManager = ESTBeaconManager()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let viewCtrl = ViewController()
       // let navCtrl = UINavigationController(rootViewController: viewCtrl)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        self.window!.rootViewController = viewCtrl
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString: "8492E75F-4FD6-469D-B132-043FE94921D8")!,
            major: 798, minor: 24035, identifier: "monitored region"))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Alert, categories: nil))
        return true
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            "Hi you just pass by a YQ merchant! " +
            "Play the scratch game to win its discount! " +
            "Slide this message to play!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

