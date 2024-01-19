import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    for _ in 0..<10 {
      let newNoteEntry = NoteEntry(context: viewContext)
      newNoteEntry.createdAt = Date()
      newNoteEntry.updatedAt = Date()
      newNoteEntry.content = "(Content)"
      newNoteEntry.title = "(title)"
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
  
  func save() {
    let viewContext = container.viewContext
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
  
  func addNoteEntry() {
    let viewContext = container.viewContext
    let newNoteEntry = NoteEntry(context: viewContext)
    newNoteEntry.createdAt = Date()
    newNoteEntry.updatedAt = Date()
    newNoteEntry.title = "Untitled"
    newNoteEntry.content = "TBD"
    
    save()
  }
  
  func updateNoteEntry(noteEntry: NoteEntry, title:String, content: String) {
    let viewContext = container.viewContext
    noteEntry.content = content
    noteEntry.title = title
    noteEntry.updatedAt = Date()
    
    save()
  }
  
  func deleteNoteEntry(noteEntry: NoteEntry) {
    let viewContext = container.viewContext
    viewContext.delete(noteEntry)
    save()
  }
}
