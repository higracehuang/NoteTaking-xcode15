import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntry.createdAt, ascending: true)], animation: .default)
  private var noteEntries: FetchedResults<NoteEntry>
  
  
  var body: some View {
    NavigationView {
      List {
        ForEach(noteEntries) { noteEntry in
          if let title = noteEntry.title,
             let content = noteEntry.content,
             let updatedAt = noteEntry.updatedAt {
            NavigationLink {
              Text(content)
            } label: {
              Text(title)
              Text(updatedAt, formatter: itemFormatter)
            }
          }
        }
      }
      .toolbar {
        ToolbarItem {
          Button(action: PersistenceController.shared.addNoteEntry) {
            Label("Add Note", systemImage: "plus")
          }
        }
      }
      Text("Select a note")
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
