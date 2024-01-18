import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
    }
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "NoteTaking")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
  
  func addNoteEntry() {
    let viewContext = container.viewContext
    let newNoteEntry = NoteEntry(context: viewContext)
    newNoteEntry.createdAt = Date()
    newNoteEntry.updatedAt = Date()
    newNoteEntry.title = "Untitled"
    newNoteEntry.content = "TBD"
    
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
  
  func updateNoteEntry(noteEntry: NoteEntry, title:String, content: String) {
    let viewContext = container.viewContext
    noteEntry.content = content
    noteEntry.title = title
    noteEntry.updatedAt = Date()
    
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}
