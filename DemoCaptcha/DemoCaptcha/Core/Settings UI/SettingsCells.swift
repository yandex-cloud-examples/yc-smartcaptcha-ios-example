//
//  SettingsCells.swift
//  DemoCaptcha
//

import Foundation
import UIKit

class CheckCell: UITableViewCell {

    private var check = UISwitch(frame: .zero)
    private var label = UILabel(frame: .zero)
    private var created = false
    private var onAction: ((Bool) -> Void)?
    
    override func layoutSubviews() {
        makeCell()
        super.layoutSubviews()
    }

    func configure(model: CheckRowModel) {
        label.text = model.labelText
        check.isOn = model.onValue()
        onAction = model.onAction
    }
    
    @objc private func onSelect() {
        onAction?(check.isOn)
    }

    private func makeCell() {
        if created { return }

        let stack = UIStackView(frame: .zero)
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stack.topAnchor),
            contentView.leftAnchor.constraint(equalTo: stack.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: stack.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: stack.heightAnchor)
        ])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        check.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(check)

        check.addTarget(self, action: #selector(onSelect), for: .valueChanged)
        created = true
    }
}


class TextCell: UITableViewCell {
    private var textField = UITextField(frame: .zero)
    private var label = UILabel(frame: .zero)
    private var created = false
    private var onAction: ((String)->Void)?


    override func layoutSubviews() {
        makeCell()
        super.layoutSubviews()
    }

    func configure(model: TextRowModel) {
        textField.placeholder = model.placeholder
        textField.text = model.onValue()
        onAction = model.onAction
    }

    private func makeCell() {
        if created { return }

        let stack = UIStackView(frame: .zero)
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stack.topAnchor),
            contentView.leftAnchor.constraint(equalTo: stack.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: stack.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: stack.heightAnchor)
        ])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(textField)

        created = true
    }
}

