//
//  OtpNavigation.swift
//  PresentationLayer
//
//  Created by Kerimov Qehreman on 06.09.26.
//

import Foundation
@MainActor
public protocol OtpNavigation : AnyObject {
    func getStarted(name : String)
}
