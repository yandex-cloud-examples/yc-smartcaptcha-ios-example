//
//  SettingsDataSource.swift
//  DemoCaptcha
//

import Foundation
import UIKit


class SettingsDataSource: NSObject, UITableViewDataSource {
    private var sections: [SectionModel]

    init(sections: [SectionModel], table: UITableView?) {
        self.sections = sections
        CellItemFactory.cellsIdsToClass.forEach { table?.register($1, forCellReuseIdentifier: $0)  }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sections.count > 0 else { return 0 }
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].rows[indexPath.row]
        return CellItemFactory.cell(by: model, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.headerText
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
}
