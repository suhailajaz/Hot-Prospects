//
//  Prospect.swift
//  Project16-HotProspects
//
//  Created by suhail on 22/12/24.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
    
}
