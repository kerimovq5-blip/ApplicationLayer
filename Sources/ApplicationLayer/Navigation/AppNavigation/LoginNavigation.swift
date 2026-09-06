//
//  LoginNavigation.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 06.09.26.
//

import Foundation
@MainActor
public protocol LoginNavigation: AnyObject {
    func showSignUp()
    func showOtpVerification(email: String)
    func finishAuth()
}
