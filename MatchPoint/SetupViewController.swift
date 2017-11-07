//
//  ViewController.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import UIKit
import Moya
import KeychainSwift

class SetupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var incorrectLoginLabel: UILabel!
    
    
    let provider = MoyaProvider<PontoMaisService>()
    let keychain = KeychainSwift()
    
    func showLoginError() {
        self.incorrectLoginLabel.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.incorrectLoginLabel.isHidden = false
            self.incorrectLoginLabel.alpha = 1
            self.activityIndicator.stopAnimating()
            self.loginButton.isEnabled = true
            self.loginButton.alpha = 1.0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.incorrectLoginLabel.alpha = 0
        loginTextField.delegate = self
        passwordTextField.delegate = self
    
        loginButton.setTitle("", for: .disabled)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        login()
    }
    
    func login() {
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
        
        
        provider.request(.login(login: self.loginTextField.text!, password: self.passwordTextField.text!)) { result in
            switch result {
            case let .success(response):
                let login = LoginResponse(JSONString: String(data: response.data, encoding: String.Encoding.utf8) as String!)
                if let validLogin = login {
                    
                    guard let _ = validLogin.token, let _ = validLogin.clientId else {
                        self.showLoginError()
                        return
                    }

                    self.keychain.set(validLogin.token!, forKey: "token", withAccess: .accessibleAfterFirstUnlock)
                    self.keychain.set(validLogin.clientId!, forKey: "clientId", withAccess: .accessibleAfterFirstUnlock)
                    self.keychain.set(self.loginTextField.text!, forKey: "email", withAccess: .accessibleAfterFirstUnlock)
                    
                    self.performSegue(withIdentifier: "loggedin", sender: self)
                    
                }
            case .failure(_):
                self.showLoginError()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if loginTextField.text != "" && passwordTextField.text != "" {
            login()
        }
        return true
    }
}
