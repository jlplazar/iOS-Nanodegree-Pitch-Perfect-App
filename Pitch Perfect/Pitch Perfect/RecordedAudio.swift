//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jorge Plaza on 9/24/15.
//  Copyright (c) 2015 Jorge Plaza. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}