//
//  SearchableRecord.swift
//  Talkup
//
//  Created by Andrew Ervin Gierke on 5/3/17.
//  Copyright © 2017 Androoo. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
