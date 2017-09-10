//
//  RepoData.swift
//  Giter
//
//  Created by Артем Полушин on 17.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import RealmSwift

class RepoData: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var repoDescription: String = ""
    dynamic var language: String = ""
    dynamic var url: String = ""
    dynamic var ownerLogin: String = ""
    var fileList = List<FileData>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
