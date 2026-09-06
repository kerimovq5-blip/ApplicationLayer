//
//  GetStartedNavigation.swift
//  PresentationLayer
//
//  Created by Kerimov Qehreman on 06.09.26.
//

import Foundation
@MainActor
public protocol GetStartedNavigation: AnyObject {
    func backToMain()
    func showTopics()
    
}
