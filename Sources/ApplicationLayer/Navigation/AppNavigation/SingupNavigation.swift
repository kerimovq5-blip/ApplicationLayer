//
//  Untitled.swift
//  PresentationLayer
//
//  Created by Kerimov Qehreman on 06.09.26.
//

import Foundation
@MainActor
public protocol SingUpNavigation : AnyObject {
    func showLogin()
    func getStarted(name : String)
}
