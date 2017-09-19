//
//  BranchData.swift
//  Giter
//
//  Created by Артем Полушин on 17.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import RealmSwift

class BranchData: Object {
    dynamic var name: String = ""
    dynamic var sha: String = ""
    dynamic var url: String = ""
}
