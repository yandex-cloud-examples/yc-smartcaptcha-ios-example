//
//  SectionModel.swift
//  DemoCaptcha
//

import Foundation

enum RowModelType: String {
    case check, textfield
}

struct SectionModel {
    var headerText: String? = nil
    var rows: [RowModel]
}

protocol RowModel {}

struct CheckRowModel: RowModel {
    var labelText: String
    var onValue: () -> Bool
    var onAction: (Bool) -> Void
}

struct TextRowModel: RowModel {
    var placeholder: String
    var onValue: () -> String
    var onAction: (String) -> Void
}
