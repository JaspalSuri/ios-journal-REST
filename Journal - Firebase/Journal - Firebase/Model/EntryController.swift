import Foundation

class EntryController {
    
    // Data Source
    var entries: [Entry] = []
    
    // Firebase URL
    let baseURL = URL(string: "https://lambdajournalentry.firebaseio.com/")!

    func put(entry: Entry, completion: @escaping (Error?) -> Void) {
        let entryIdentifierURL = baseURL.appendingPathComponent(entry.identifier)
        let withJSONURL = entryIdentifierURL.appendingPathExtension("json")
        
        var requestURL = URLRequest(url: withJSONURL)
        requestURL.httpMethod = "PUT"
        
        do {
            let encoder = JSONEncoder()
            requestURL.httpBody = try encoder.encode(entry)
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (_, _, error) in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()

    }
    
    func createEntry(title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        
        let entry = Entry(title: title, bodyText: bodyText)
        
        put(entry: entry, completion: completion)
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        
        guard let index = entries.index(of: entry) else { return }
        
        entries[index].title = title
        
        entries[index].bodyText = bodyText
        
        let updatedEntries = entries[index]
        
        put(entry: updatedEntries, completion: completion)
        
    }
    
}
