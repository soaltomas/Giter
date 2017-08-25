//
//  FileData.swift
//  Giter
//
//  Created by Артем Полушин on 06.08.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import RealmSwift

class FileData: Object {
 //   dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var path: String = ""
    dynamic var sha: String = ""
    dynamic var size: Int = 0
    dynamic var url: String = ""
    dynamic var html_url: String = ""
    dynamic var git_url: String = ""
    dynamic var download_url: String = ""
    dynamic var type: String = ""
    dynamic var content: String = ""
    var fileList = List<FileData>()

//    override static func primaryKey() -> String? {
//        return "id"
//    }
//
//    static func incrementId() -> Int {
//        let realm = try! Realm()
//        if let retNext = realm.objects(FileData.self).sorted(byKeyPath: "id").first?.id {
//            return retNext + 1
//        }else{
//            return 1
//        }
//    }
}
