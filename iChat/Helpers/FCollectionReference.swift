//
//  CollectionReference.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/09.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}

func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
