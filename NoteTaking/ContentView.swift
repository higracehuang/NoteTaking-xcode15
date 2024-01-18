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
          NoteEntryView(noteEntry: noteEntry)
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

struct NoteEntryView: View {
  var noteEntry: NoteEntry
  
  var body: some View {
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


#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
