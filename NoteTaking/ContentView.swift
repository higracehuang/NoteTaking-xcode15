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
  @ObservedObject var noteEntry: NoteEntry
  
  @State private var titleInput: String = ""
  @State private var contentInput: String = ""
  
  @State private var shouldShowDeleteButton = false
  
  var body: some View {
    if let title = noteEntry.title,
       let content = noteEntry.content,
       let updatedAt = noteEntry.updatedAt {
      NavigationLink {
        VStack {
          TextField("Title", text: $titleInput)
            .onAppear() {
              self.titleInput = title
            }
            .onChange(of: titleInput) { oldTitle, newTitle in
              PersistenceController.shared.updateNoteEntry(
                noteEntry: noteEntry, title: newTitle, content: contentInput)
            }
          TextEditor(text: $contentInput)
            .onAppear() {
              self.contentInput = content
            }
            .onChange(of: contentInput) { oldContent, newContent in
              PersistenceController.shared.updateNoteEntry(
                noteEntry: noteEntry, title: titleInput, content: newContent)
            }
        }
      } label: {
        HStack {
          Text(title)
          Text(updatedAt, formatter: itemFormatter)
          Spacer()
          if shouldShowDeleteButton {
            
            Button {
              PersistenceController.shared.deleteNoteEntry(noteEntry: noteEntry)
            } label: {
              Image(systemName: "minus.circle")
            }.buttonStyle(.plain)
          }
          
        }.onHover { isHover in
          shouldShowDeleteButton = isHover
        }
      }
    }
  }
}


#Preview {
  ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
