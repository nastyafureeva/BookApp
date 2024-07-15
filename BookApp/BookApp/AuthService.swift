//
//  AuthService.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 24.04.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {

    private let db = Firestore.firestore()

    public static let shared = AuthService()
    private init() {}

    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }

            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }

            self.db.collection("users").document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ]) {error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }
    }

    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return } else{
                    UserDefaults.standard.set(userRequest.email, forKey: "email")
                    completion(nil)
                }
        }
    }

    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }

    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        db.collection("users").getDocuments { (snapshot, error) in
            guard error == nil, let snapshot = snapshot else {
                completion(.failure(NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "failedToFetch"])))
                return
            }

            var values: [[String: String]] = []
            for document in snapshot.documents {
                if let data = document.data() as? [String: String] {
                    values.append(data)
                }

                //                values.append(document.data() as? [String: String] ?? [:])
            }

            completion(.success(values))
        }

    }
    public enum FirestoreError{
        case failedToFetch
    }

}

extension AuthService {
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String
        else {
            return
        }
        let ref =  db.collection("users")
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print(uid)
            ref.document(uid).getDocument { [weak self] documentSnapshot, error in
                guard let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                    completion(false)
                    print(currentEmail)
                    print("user not found")
                    return
                }
                print("getDocument true")
                guard var userNode = documentSnapshot.data() else {
                    completion(false)
                    print("user data not found")
                    return
                }


                let messageDate = firstMessage.sentDate
                let dateString = ChatViewController.dateFormatter.string(from: messageDate)

                var message = ""

                switch firstMessage.kind {
                case .text(let messageText):
                    message = messageText
                case .attributedText(_):
                    break
                case .photo(_):
                    break
                case .video(_):
                    break
                case .location(_):
                    break
                case .emoji(_):
                    break
                case .audio(_):
                    break
                case .contact(_):
                    break
                case .custom(_), .linkPreview(_):
                    break
                }


                let conversationId = "conversation_\(firstMessage.messageId)"

                let newConversationData: [String: Any] = [
                    "id": conversationId,
                    "other_user_email": otherUserEmail,
                    "username": name,
                    "latest_message": [
                        "date": dateString,
                        "message": message,
                        "is_read": false
                    ]
                ]
                if var conversations = userNode["conversations"] as? [[String: Any]] {

                    conversations.append(newConversationData)
                    userNode["conversations"] = conversations
                    print(currentEmail)
                    let user = Auth.auth().currentUser
                    print(user)

                    print(uid)
                    ref.document(uid).updateData(userNode) { [weak self] error in
                        guard error == nil else {
                            print("updateData false \(error)")
                            completion(false)
                            return
                        }
                        print("updateData true")
                        self?.finishCreatingConversation(conversationID: conversationId, name: name, firstMessage: firstMessage, completion: completion)
                    }

                }
                else {
                    userNode["conversations"] = [
                        newConversationData
                    ]
                    ref.document(uid).updateData(userNode) { [weak self] error in
                        guard error == nil else {
                            print("updateData false \(error)")
                            completion(false)
                            return
                        }
                        print("updateData true")
                        self?.finishCreatingConversation(conversationID: conversationId, name: name, firstMessage: firstMessage, completion: completion)
                    }

                }
            }
        }
    }
    private func finishCreatingConversation(conversationID: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else { completion(false)
            return
        }

        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)

        var message = ""

        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_), .linkPreview(_):
            break
        }
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentEmail,
            "is_read": false,
            "username": name
        ]

        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        //
        //         print("adding convo: \(conversationID)")
        //
        db.collection("\(conversationID)").addDocument(data: value, completion: { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }

    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completion(.failure(NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "failedToFetch"])))
                return
            }

            guard let document = snapshot.documents.first else {
                completion(.failure(NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "failedToFetch"])))
                return
            }

            guard let value = document["conversations"] as? [[String: Any]] else {
                completion(.failure(NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "failedToFetch"])))
                return
            }

            print("VALUE\(value)")
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["username"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {

                    return nil
                }

                let latestMmessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)

                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })
            print("CONVERS\(conversations)")
            completion(.success(conversations))
        }
    }
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
    }

    public func sendMessage(to conversation: String,  mmessage: Message, completion: @escaping (Bool) -> Void) {
    }
}
