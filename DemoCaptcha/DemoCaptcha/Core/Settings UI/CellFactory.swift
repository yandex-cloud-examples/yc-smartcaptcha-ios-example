
import Foundation
import UIKit

struct CellItemFactory {
    private static let accountCellIdentifier = "CheckCell"
    private static let actionCellIdentifier = "TextCell"

    private init() { }

    static var cellsIdsToClass: [String: Swift.AnyClass] {
        [
            accountCellIdentifier: CheckCell.self,
            actionCellIdentifier: TextCell.self,
        ]
    }

    static func cell(by item: RowModel, tableView: UITableView) -> UITableViewCell {
        let resultCell: UITableViewCell
        if let item = item as? CheckRowModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier)! as! CheckCell
            cell.configure(model: item)
            resultCell = cell
        } else if let item = item as? TextRowModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: actionCellIdentifier)! as! TextCell
            cell.configure(model: item)
            resultCell = cell
        } else {
            fatalError("Invalid type of cell item \(item)")
        }
        return resultCell
    }
}