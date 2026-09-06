//
//  StartNavigation.swift
//  PresentationLayer
//
//  Created by Kerimov Qehreman on 06.09.26.
//

import Foundation
@MainActor
public protocol StartNavigation : AnyObject {
    func showSignUp()
    func showLogin()
}
