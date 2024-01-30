//
//  AppDelegate.swift
//  Bankey
//
//  Created by Hamit Tırpan on 27.01.2024.
//

import UIKit

let appColor = UIColor(red: 0.12, green: 0.15, blue: 0.27, alpha: 1.00)
let primaryColor = UIColor(red: 0.28, green: 0.31, blue: 0.48, alpha: 1.00)
let secondaryColor = UIColor(red: 0.51, green: 0.41, blue: 0.62, alpha: 1.00)
let thirdColor = UIColor(red: 1.00, green: 0.82, blue: 0.93, alpha: 1.00)
let errorColor = UIColor(red: 0.82, green: 0.27, blue: 0.27, alpha: 1.00)

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingContainerViewController = OnboardingContainerViewController()
    let mainViewController = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingContainerViewController.delegate = self
        
        registerForNotifications()
        
        displayLogin()
        
        return true
    }
    
    private func registerForNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
    private func displayLogin(){
        setRootViewController(loginViewController)
    }
    
    private func displayNextScreen(){
        if LocalState.hasOnboarded{
            prepMainView()
            setRootViewController(mainViewController)
        } else{
            setRootViewController(onboardingContainerViewController)
        }
    }
    
    private func prepMainView(){
        mainViewController.setStatusBar()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = primaryColor
    }
}

extension AppDelegate{
    func setRootViewController(_ vc: UIViewController, animated: Bool = true){
        guard animated, let window = self.window else{
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        
    }
}

extension AppDelegate: LoginViewControllerDelegate{
    func didLogin() {
        displayNextScreen()
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate{
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        prepMainView()
        setRootViewController(mainViewController)
    }
}

extension AppDelegate: LogoutDelegate{
    @objc func didLogout() {
        setRootViewController(loginViewController)
    }
}
