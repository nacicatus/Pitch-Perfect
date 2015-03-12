//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Saurabh Sikka on 10/03/15.
//  Copyright (c) 2015 Saurabh Sikka. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}