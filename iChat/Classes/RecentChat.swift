//
//  RecentChat.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/16.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import Foundation

func startPrivateChat(user1: FUser, user2: FUser) -> String {
    
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1, userId2]
    
    //create recent chats
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1, user2], avatarOfGroup: nil)
    
    return chatRoomId
}

func createRecent(members: [String], chatRoomId: String, withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    
    var tempMembers = members
    
    reference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        //return if snapshot was nil
        guard let snapshot = snapshot else {return}
        
        if !snapshot.isEmpty {
            for recentChat in snapshot.documents {
                let currentRecentChat = recentChat.data() as NSDictionary
                if let currenUserId = currentRecentChat[kUSERID] {
                    if tempMembers.contains(currenUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currenUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in tempMembers {
            createRecentItems(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
        }
    }
}

func createRecentItems(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = DateFormatter().string(from: Date())
    
    var recent: [String: Any]!
    
    if type == kPRIVATE {
        //private
        var withUser: FUser?
        
        if users != nil && users!.count > 0 {
            if userId == FUser.currentId() {
                //for current user
                withUser = users!.last!
            } else {
                withUser = users!.first!
            }
        }
        
        recent = [
            kRECENTID: recentId,
            kUSERID: userId,
            kCHATROOMID: chatRoomId,
            kMEMBERS: members,
            kMEMBERSTOPUSH: members,
            kWITHUSERFULLNAME: withUser!.fullname,
            kWITHUSERUSERID: withUser!.objectId,
            kLASTMESSAGE: "",
            kCOUNTER: 0,
            kDATE: date,
            kTYPE: type,
            kAVATAR: withUser!.avatar
            ] as [String: Any]
    } else {
        //group
        if avatarOfGroup != nil {
            recent = [
            kRECENTID: recentId,
            kUSERID: userId,
            kCHATROOMID: chatRoomId,
            kMEMBERS: members,
            kMEMBERSTOPUSH: members,
            kWITHUSERFULLNAME: withUserUserName,
            //WITHUSERUSERID: withUser!.objectId,
            kLASTMESSAGE: "",
            kCOUNTER: 0,
            kDATE: date,
            kTYPE: type,
            kAVATAR: avatarOfGroup
                ] as [String: Any]
        }
    }
    
    // save recent chat
    localReference.setData(recent)
}
