
// MARK: - Фуреева Анастасия
import UIKit
import MessageKit
import InputBarAccessoryView

struct Message:MessageType{
    public var sender: any MessageKit.SenderType
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var kind: MessageKit.MessageKind
    
    
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(let string):
            return "text"
        case .attributedText(let nSAttributedString):
            return "attributedText"
        case .photo(let mediaItem):
            return "photo"
        case .video(let mediaItem):
            return "video"
        case .location(let locationItem):
            return "location"
        case .emoji(let string):
            return "emoji"
        case .audio(let audioItem):
            return "audio"
        case .contact(let contactItem):
            return "contact"
        case .linkPreview(let linkItem):
            return "linkPreview"
        case .custom(let any):
            return "custom"
        }
    }
}
struct Sender: SenderType{
    public var photoUrl: String
    public var senderId: String
    
    public var displayName: String
    
    
}
final class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    
    public var otherUserEmail: String
    private var conversationId: String?
    
    public var isNewConversation = false
    
    private var messages = [Message]()
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        return Sender(photoUrl: "", senderId: email, displayName: "NNN")
        
    }
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
        if let conversationId = conversationId{
            listenForMessages(id: conversationId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        messagesCollectionView.reloadData()
        print(messages)
    }
    
    private func listenForMessages(id: String) {
        AuthService.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                print("success in getting messages: \(messages)")
                guard !messages.isEmpty else {
                    print("messages are empty")
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    //
                    //                    if shouldScrollToBottom {
                    //                        self?.messagesCollectionView.scrollToBottom()
                    //                    }
                }
            case .failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        //           if let conversationId = conversationId {
        //               listenForMessages(id: conversationId, shouldScrollToBottom: true)
        //           }
    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    var currentSender: any MessageKit.SenderType {
        if let sender = selfSender {
            return sender
        }
        
        fatalError("Self Sender is nil, email should be cached")
    }
    
    
    
    //    func currentSender() -> SenderType {
    //        if let sender = selfSender {
    //            return sender
    //        }
    //
    //        fatalError("Self Sender is nil, email should be cached")
    //    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId()
                //              let selfSender = self.selfSender,
                //              let messageId = createMessageId()
        else {
            return
        }
        print(text)
        
        if isNewConversation {
            let mmesage = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .text(text))
            AuthService.shared.createNewConversation(with: otherUserEmail, name: selfSender.displayName, firstMessage: mmesage, completion: { success in
                if success {
                    print("message sent")
                }
                else {
                    print("failed to send message")
                }
            })
            
        }
    }
    private func createMessageId() -> String? {
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        //            let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        //
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)"
        print("mes ID \(newIdentifier)")
        //
        //            print("created message id: \(newIdentifier)")
        
        return newIdentifier
    }
}
