//
//  User.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import FirebaseFirestoreSwift
import MessageKit


class User: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var firstName: String
    var birthDate: Date
    var skiProficiency: String?
    var skiPassLocation: String?
    var currentLocation: String?
    var bio: String?
    var skiStyleTags: [String]
    var skiDates: SkiDates
    var skiInvites: [SkiInvites]
    var skiTypes: SkiTypes
    var profilePhotoURL: String?
    var photoURLS: [String]
    var onboardingComplete: Bool
    
    var chats: [Chat]
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case firstName = "first_name"
        case birthDate = "birth_date"
        case skiProficiency = "ski_proficiency"
        case skiPassLocation = "ski_pass_location"
        case currentLocation = "current_location"
        case bio = "bio"
        case skiStyleTags = "ski_style_tags"
        case skiDates = "ski_dates"
        case skiInvites = "ski_invites"
        case skiTypes = "ski_types"
        case profilePhotoURL = "profile_photo_url"
        case photoURLS = "photo_urls"
        case onboardingComplete = "onboarding_complete"

        case chats = "chats"
    }
    
    
    init(uid: String,
         firstName: String,
         birthDate: Date = Date(),
         skiProficiency: String = "First Timer",
         skiPassLocation: String = "None",
         currentLocation: String = "",
         bio: String = "",
         skiStyleTags: [String] = [],
         skiDates: SkiDates = SkiDates() ,
         skiInvites: [SkiInvites] = [],
         skiTypes: SkiTypes = SkiTypes(ski: false, snowboard: false),
         profilePhotoURL: String = "",
         photoURLS: [String] = [],
         onboardingComplete: Bool = false,

         chats: [Chat] = []
    ) {
        self.uid = uid
        self.firstName = firstName
        self.birthDate = birthDate
        self.skiProficiency = skiProficiency
        self.skiPassLocation = skiPassLocation
        self.currentLocation = currentLocation
        self.bio = bio
        self.skiStyleTags = skiStyleTags
        self.skiDates = skiDates
        self.skiInvites = skiInvites
        self.skiTypes = skiTypes
        self.profilePhotoURL = profilePhotoURL
        self.photoURLS = photoURLS
        self.onboardingComplete = onboardingComplete

        self.chats = chats
    }
}

class SkiDates: Codable {
    var willSkiDates: [Date]
    var maybeSkiDates: [Date]
    
    enum CodingKeys: String, CodingKey {
        case willSkiDates = "will_ski_dates"
        case maybeSkiDates = "maybe_ski_dates"
    }
    
    init(willSkiDates: [Date] = [], maybeSkiDates: [Date] = []) {
        self.willSkiDates = willSkiDates
        self.maybeSkiDates = maybeSkiDates
    }
}

class SkiInvites: Codable {
    var inviterUid: String
    var inviterFirstName: String
    var inviterPhotoURL: String
    var didStartConversation: Bool
    var inviteDate: Date
    
    enum CodingKeys: String, CodingKey {
        case inviterUid = "inviter_uid"
        case inviterFirstName = "inviter_first_name"
        case didStartConversation = "did_start_conversation"
        case inviterPhotoURL = "inviter_photo_url"
        case inviteDate = "invite_date"
    }

    init(inviterUid: String, inviterFirstName: String, didStartConversation: Bool = false, inviterPhotoUrl: String, inviteDate: Date) {
        self.inviterUid = inviterUid
        self.inviterFirstName = inviterFirstName
        self.didStartConversation = didStartConversation
        self.inviterPhotoURL = inviterPhotoUrl
        self.inviteDate = inviteDate
    }
}

struct SkiTypes: Codable {
    var ski: Bool
    var snowboard: Bool
    
    enum CodingKeys: String, CodingKey {
        case ski
        case snowboard
    }
}

// ------CONVERSATION------

struct Chat: Codable {
    var conversationId: String
    var otherUserUid: String
    var latestMessage: LatestMessage
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case otherUserUid = "other_user_uid"
        case latestMessage = "latestMessage"
    }
}

class LatestMessage: Codable {
    var date: Date
    var isRead: Bool
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case isRead = "is_read"
        case message = "message"
    }
}

struct Conversation: Codable{
    var conversationId: String
    var messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case conversationId = "conversation_id"
        case messages = "messages"
    }
    
}

struct Message: Codable {
    var messageId: String
    var senderUid: String
    var content: String
    var date: Date
    var isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case senderUid = "sender_uid"
        case content = "content"
        case date = "date"
        case isRead = "is_read"
    }
}
