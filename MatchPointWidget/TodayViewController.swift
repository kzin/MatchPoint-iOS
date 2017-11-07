//
//  TodayViewController.swift
//  MatchPointWidget
//
//  Created by Lucas Salton Cardinali on 13/09/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import UIKit
import NotificationCenter
import KeychainSwift
import Moya

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var registerButton: UIButton!
        
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let keychain = KeychainSwift()
    let provider = MoyaProvider<PontoMaisService>()
    var token: String = ""
    var clientId: String = ""
    var email: String = ""
    
    let successColor = UIColor(red:0.32, green:0.48, blue:0.93, alpha:1.0)
    let defaultColor = UIColor(red:0.00, green:0.16, blue:0.55, alpha:1.0)
    let errorColor = UIColor(red:0.65, green:0.00, blue:0.00, alpha:1.0)
    
    
    @IBOutlet weak var tryAgainLabel: UILabel!
    @IBOutlet weak var loginMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.stopAnimating()
        

        if let validToken = self.keychain.get("token"), let validClientId = self.keychain.get("clientId"), let validEmail = self.keychain.get("email") {
            self.token = validToken
            self.clientId = validClientId
            self.email = validEmail
        } else {
            self.registerButton.isHidden = true
            self.registerButton.isEnabled = false
            self.loginMessage.isHidden = false
        }

    
    }
    
    @IBAction func didTapRegisterButton(_ sender: Any) {
        self.activityIndicator.startAnimating()
        self.registerButton.isEnabled = false
        
        provider.request(.register(token: token, client: clientId, uid: email)) {
            result in
            switch result {
            case let .success(response):
                let register = String(data: response.data, encoding: String.Encoding.utf8) as String!
                
                if let _ = register {
                    self.setSuccessButton()
                } else {
                    self.setErrorButton()
                }
            
            case .failure(_):
                self.setErrorButton()
            }
        }
        
    }
    
    func setErrorButton() {
        self.registerButton.setTitle("", for: .disabled)
        UIView.animate(withDuration: 0.5, animations: {
            self.registerButton.setTitle("Erro ao bater o Ponto", for: .normal)
            self.registerButton.backgroundColor = self.errorColor
            self.tryAgainLabel.isHidden = false
            self.registerButton.isEnabled = true
        })
    }
    
    func setSuccessButton() {
        
        UIView.animate(withDuration: 0.5, animations: {
            let hour = Calendar.current.component(.hour, from: Date())
            var message = ""
            
            if hour >= 0 && hour <= 11 {
                message = "Bom Trabalho!"
            } else if hour >= 12 && hour <= 13 {
                message = "Bom Almoço!"
            } else if hour >= 14 && hour <= 16 {
                message = "Bom Trabalho!"
            } else if hour >= 17 && hour <= 23 {
                message = "Boa Volta!"
            }
        
            self.registerButton.setTitle(message, for: .normal)
            self.registerButton.setTitle(message, for: .disabled)
            self.tryAgainLabel.isHidden = true
            self.activityIndicator.stopAnimating()
            
            self.registerButton.backgroundColor = self.successColor
            self.tryAgainLabel.isHidden = true
            self.registerButton.isEnabled = false
        })
    }
    
    func setDefaultButton() {
        self.registerButton.setTitle("", for: .disabled)
        registerButton.setTitle("Bater o Ponto", for: .normal)
        registerButton.backgroundColor = defaultColor
        tryAgainLabel.isHidden = false
        registerButton.isEnabled = true
    }
    
    
  //  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
       // completionHandler(NCUpdateResult.noData)
    //}
    
}
