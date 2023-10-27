//
//  FeedFirebaseError.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/20.
//

import Foundation

enum FeedFirebaseError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
