//
//  CityManageView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/5.
//

import CoreData
import SwiftUI
struct CityManageView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CityModel.sort, ascending: true)],
        animation: .default)
    private var result: FetchedResults<CityModel>

    @Environment(\.managedObjectContext) private var viewContext

    @State var editMode: EditMode = .inactive

    @GestureState var isDetectingLongPress = false

    var body: some View {
        List {
            ForEach(result) { cityModel in
                HStack {
                    Text(cityModel.name ?? "")
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

//                .background(.red)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0).updating($isDetectingLongPress, body: { currentState, gestureState, transaction in

                        YLPLog(currentState, gestureState, transaction)
                    })
                        .onEnded({ _ in
                            editMode = .active
                        })
                )

                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewContext.delete(cityModel)
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
        }

        .environment(\.editMode, $editMode)
        .navigationBarTitle("城市管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                editMode = editMode == .active ? .inactive : .active
            } label: {
                Text(editMode == .active ? "完成" : "编辑")
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for i in offsets {
            viewContext.delete(result[i])
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        // Make an array of items from fetched results
        var revisedItems: [CityModel] = result.map { $0 }

        // change the order of the items in the array
        revisedItems.move(fromOffsets: source, toOffset: destination)

        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride(from: revisedItems.count - 1,
                                   through: 0,
                                   by: -1)
        {
            revisedItems[reverseIndex].sort =
                Int64(reverseIndex)
        }
    }
}

func getCityManageViewPreviews() -> some View {
    let viewContext = PersistenceController.shared.container.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityModel")

    if let result = try? viewContext.fetch(request) {
        result.forEach({ viewContext.delete($0 as! NSManagedObject) })
    }

    HomeViewModel().cityModel(context: viewContext)

    try? viewContext.save()

    return CityManageView()
        .environment(\.managedObjectContext, viewContext)
}

struct CityManageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            getCityManageViewPreviews()
        }
    }
}
