//
//  SceneDelegate.swift
//  rokhanPW3
//
//  Created by Roman on 05.10.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var menadger = AlarmMenadger()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UNUserNotificationCenter.current().delegate = self
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        
        menadger.scene = self
        menadger.loadFromDataBase()
        
        
        let viewControllers = [
            StackViewController(),
            TableViewController(),
            CollectionViewController()]
        
        
        tabBarController.setViewControllers(viewControllers, animated: false)
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.barTintColor = .black
        tabBarController.tabBar.isTranslucent = false
        
        guard let items = tabBarController.tabBar.items else {return}
        let titles = ["Stack", "Table", "Collection"]
        let images = [UIImage(named: "stack"),
                      UIImage(named: "table-grid"),
                      UIImage(named: "collect")]
        for i in 0..<titles.count {
            viewControllers[i].title = titles[i];
            viewControllers[i].view.backgroundColor = UIColor(red: CGFloat(28) / 255, green: CGFloat(28) / 255, blue: CGFloat(28) / 255, alpha: 1)
            (viewControllers[i] as? AlarmViewControllerProtocol)?.alarmMenadger = menadger
            items[i].image = images[i]
        }
        (viewControllers[0] as? StackViewController)?.setupStackView()
        menadger.controllers = viewControllers as? [AlarmViewControllerProtocol]
        
        let navigator = UINavigationController(rootViewController: tabBarController)
        tabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                      target: self,
                                                                      action: #selector(addViewControllerShow))
        tabBarController.navigationItem.rightBarButtonItem?.tintColor = .orange
        tabBarController.navigationItem.title = "ALARMS"
        navigator.navigationBar.barTintColor = .black
        navigator.navigationBar.isTranslucent = false
        navigator.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        window.rootViewController = navigator
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
    @objc func addViewControllerShow(mode: Bool = false, alarmIndex: Int) {
        let controller = AlarmConfigureViewController()
        let detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: window?.rootViewController ?? UIViewController(), to: controller)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = detailsTransitioningDelegate
        controller.alarmMenadger = menadger
        controller.flagMode = mode
        controller.alarmIndex = alarmIndex
        
        window?.rootViewController?.present(controller, animated: true, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}
