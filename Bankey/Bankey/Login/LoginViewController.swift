//
//  ViewController.swift
//  Bankey
//
//  Created by Hamit Tırpan on 27.01.2024.
//

import UIKit

protocol LogoutDelegate: AnyObject{
    func didLogout()
}

protocol LoginViewControllerDelegate: AnyObject{
    func didLogin()
}

class LoginViewController: UIViewController {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let loginView = LoginView()
    let signInButton = UIButton()
    let errorMessageLabel = UILabel()
    
    weak var delegate: LoginViewControllerDelegate?
    
    var username : String?{
        return loginView.usernameTextField.text
    }
    
    var password : String?{
        return loginView.passwordTextField.text
    }
    
    //animation
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEdgeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var subtitleLeadingAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    private func setGradientBackground(){
        
        let startColor = UIColor(red: 0.67, green: 0.73, blue: 0.73, alpha: 0.67)
        
        let endColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)

        // Gradient layer oluştur
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        // Gradient layer'ı view'e ekle
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension LoginViewController{
    private func style(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = "Bankey"
        titleLabel.textColor = primaryColor
        titleLabel.alpha = 0

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = secondaryColor
        subtitleLabel.text = "Your premium source for all things banking!"
        subtitleLabel.alpha = 0
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.tintColor = primaryColor
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])

        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered )
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = errorColor
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
    }
    
    private func layout(){
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // Title
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        // Subtitle
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        subtitleLeadingAnchor = subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        subtitleLeadingAnchor?.isActive = true
        
        // LoginView
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 2),
        ])
        
        // Button
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Error Label
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
    }
}

// MARK: Actions
extension LoginViewController{
    @objc func signInTapped(sender: UIButton){
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login(){
        
        guard let username = username, let password = password else {
            assertionFailure("Username / Password should never be nil")
            return
        }
        
        if username.isEmpty || password.isEmpty{
            configureView(withMessage: "Username / Password cannot be blank")
            return
        }
        
        if username == "Hamit" && password == "Welcome"{
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username / password")
            return
        }
    }
    
    private func configureView(withMessage message : String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        shakeButton()
    }
    
    private func shakeButton(){
        let animation = CAKeyframeAnimation()
        
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.3
        
        animation.isAdditive = true
        signInButton.layer.add(animation, forKey: "shake ")
    }
}

extension LoginViewController{
    
    private func animate(){
        let duration = 0.8
         
        let titleAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut){
            self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        titleAnimation.startAnimation()
        
        let subtitleAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut){
            self.subtitleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        
        subtitleAnimation.startAnimation(afterDelay: 0.2)
        
        let alphaAnimation = UIViewPropertyAnimator(duration: duration * 2, curve: .easeInOut){
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
        }
        
        alphaAnimation.startAnimation(afterDelay: 0.2)
    }
}
