//
//  SettingsViewController.swift
//  Jirassic
//
//  Created by Baluta Cristian on 06/05/15.
//  Copyright (c) 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
	
	var handleSaveButton: (() -> ())?
	var handleCloseButton: (() -> ())?
	
	@IBOutlet private var emailTextField: NSTextField?
	@IBOutlet private var passwordTextField: NSTextField?
    @IBOutlet private var butLogin: NSButton?
    @IBOutlet private var butQuit: NSButton?
	@IBOutlet private var progressIndicator: NSProgressIndicator?
	
	var credentials: UserCredentials {
		get {
			return (email: self.emailTextField!.stringValue,
				password: self.passwordTextField!.stringValue)
		}
		set {
			self.emailTextField!.stringValue = newValue.email
			self.passwordTextField!.stringValue = newValue.password
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let user = ReadUserInteractor().execute()
        butLogin?.title = user.isLoggedIn ? "Logout" : "Login"
        emailTextField?.stringValue = user.email!
    }
	
	func removeFromSuperview() {
		self.view.removeFromSuperview()
	}
	
	func showLoadingIndicator (show: Bool) {
		if show {
			progressIndicator?.startAnimation(nil)
		} else {
			progressIndicator?.stopAnimation(nil)
		}
	}
	
	
	// MARK: Actions
	
	@IBAction func handleLoginButton (sender: NSButton) {
		
		let user = ReadUserInteractor().execute()
        let login = LoginInteractor(data: localRepository)
        login.onLoginSuccess = {
            self.showLoadingIndicator(false)
        }
        user.isLoggedIn ? login.logout() : login.loginWithCredentials(credentials)
	}
	
	@IBAction func handleSaveButton (sender: NSButton) {
		self.handleSaveButton?()
	}
	
    @IBAction func handleQuitAppButton (sender: NSButton) {
        NSApplication.sharedApplication().terminate(nil)
    }
}