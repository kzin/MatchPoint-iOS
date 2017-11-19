//
//  LoggedInViewController.swift
//  MatchPoint
//
//  Created by Lucas Salton Cardinali on 18/10/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import UIKit
import KeychainSwift
import CoreLocation
import UserNotifications

class LoggedInViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var rememberNotificationSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var rememberSwitch: UISwitch!
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]

    let locationManager = CLLocationManager() // Add this statement

    override func viewDidLoad() {
        super.viewDidLoad()

        rememberSwitch.addTarget(self, action: #selector(stateChanged(state:)), for: UIControlEvents.valueChanged)

        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    @objc func stateChanged(state: UISwitch) {
        if state.isOn {
            requestLocation()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocation()
    }

    func requestLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            let alert = UIAlertController(title: "Localização", message: "O acesso à localização foi negado, ative-a nas Configurações", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:nil))

            self.present(alert, animated: true, completion: nil)
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            requestNotifications()
        }

    }

    func requestNotifications() {
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            } else {
                self.setupNotifications()
            }
        }
    }

    // MARK CLLocationManagerDelegate:

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.requestNotifications()
        }
    }

    func setupNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Matchpoint"
        content.body = "Está chegando/saindo da Concrete? Não esqueça de bater o ponto!"

        let concreteSPCoordinates = CLLocationCoordinate2D(latitude: -23.601449, longitude: -46.694799)
        let concreteSPRegion = CLCircularRegion(center: concreteSPCoordinates, radius: 100, identifier: "concreteSP")
        concreteSPRegion.notifyOnExit = true
        concreteSPRegion.notifyOnEntry = true

        let concreteRJCoordinates = CLLocationCoordinate2D(latitude: -22.910222, longitude: -43.172658)
        let concreteRJRegion = CLCircularRegion(center: concreteRJCoordinates, radius: 100, identifier: "concreteRJ")
        concreteRJRegion.notifyOnExit = true
        concreteRJRegion.notifyOnEntry = true

        let concreteBHCoordinates = CLLocationCoordinate2D(latitude: -19.935331, longitude: -43.929717)
        let concreteBHRegion = CLCircularRegion(center: concreteBHCoordinates, radius: 100, identifier: "concreteBH")
        concreteBHRegion.notifyOnExit = true
        concreteBHRegion.notifyOnEntry = true

        let triggerSP = UNLocationNotificationTrigger(region: concreteSPRegion, repeats: true)
        let triggerRJ = UNLocationNotificationTrigger(region: concreteRJRegion, repeats: true)
        let triggerBH = UNLocationNotificationTrigger(region: concreteBHRegion, repeats: true)

        let notificationSP = UNNotificationRequest(identifier: "ConcreteSP", content: content, trigger: triggerSP)
        let notificationRJ = UNNotificationRequest(identifier: "ConcreteRJ", content: content, trigger: triggerRJ)
        let notificationBH = UNNotificationRequest(identifier: "ConcreteBH", content: content, trigger: triggerBH)

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        center.add(notificationSP)
        center.add(notificationRJ)
        center.add(notificationBH)
    }

    @IBAction func didTapLogoutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sair", message: "Tem certeza que deseja sair?", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.destructive, handler: { action in
            self.logout()
        }))

        alert.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func logout() {
        let keychain = KeychainSwift()
        keychain.set("", forKey: "token")
        keychain.set("", forKey: "clientId")
        self.performSegue(withIdentifier: "logout", sender: self)
    }

}
