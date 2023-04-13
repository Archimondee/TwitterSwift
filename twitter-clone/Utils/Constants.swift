//
//  Constants.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 12/04/23.
//

import Firebase
import Foundation

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
