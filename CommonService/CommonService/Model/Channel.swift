//
//  Cha.swift
//  Smack
//
//  Created by William Huang on 13/06/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

public struct Channel {
    private(set) public var channelName: String!
    private(set) public var channelDesc: String!
    private(set) public var id: String!
}

//All member must be exactly same like JSON member
//struct Channel: Decodable {
//    private(set) public var _id: String!
//    private(set) public var name: String!
//    private(set) public var description: String!
//    private(set) public var __v: Int!
//}

