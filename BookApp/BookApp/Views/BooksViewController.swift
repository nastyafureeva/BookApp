// swiftlint:disable all

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import EpubReaderLight

// Модель данных книги
struct Book: Identifiable, Decodable {
    var id: String // ID документа в Firestore
    var title: String
    var author: String
    var cover: String
    var description: String
    var epub: String
}

// Вью для отображения списка книг
struct BooksViewController: View {
    @State private var books: [Book] = []

    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookReaderView(epubUrl: book.epub)) {
                    HStack {
                        WebImage(url: URL(string: book.cover)!).resizable().frame(width: 120, height: 170).cornerRadius(10)
                        VStack(alignment: .leading) {
                            Text(book.title).font(.headline)
                            Text(book.author).font(.subheadline)
                            Text(book.description).font(.caption).lineLimit(4).multilineTextAlignment(.leading)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Книги"), displayMode: .inline)
            .onAppear {
                loadBooksFromFirestore()
            }
        }
    }

    func loadBooksFromFirestore() {
        let db = Firestore.firestore()
        db.collection("books").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Ошибка при получении документов: (error)")
            } else {
                if let snapshot = querySnapshot {
                    self.books = snapshot.documents.compactMap { doc -> Book? in
                        try? doc.data(as: Book.self)
                    }
                    for (index, book) in books.enumerated() {
                        books[index].id = snapshot.documents[index].documentID
                    }
                }
            }
        }
    }
}

// Вью для чтения книги
struct BookReaderView: View {
    @StateObject private var readerViewController = EpubReaderLight.ReaderViewController(theme: .light)
    let epubUrl: String

    var body: some View {
        ReaderView(controller: readerViewController)
            .onAppear {
                Task {
                    do {
                        let urlBook = URL(string: epubUrl)!
                        try await readerViewController.loadBook(url: urlBook)
                    } catch {
                        print("Error loading book: (error)")
                    }
                }
            }
           
    }
}
