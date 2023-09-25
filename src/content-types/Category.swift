enum Category: String, CaseIterable {
    case specification, implementation, testing, housekeeping, announcements

    var name: String {
        switch(self) {
        case .specification:
            return "Feature Specification"
        case .implementation:
            return "Implementation Details"
        case .testing:
            return "Testing"
        case .housekeeping:
            return "Project Housekeeping"
        case .announcements:
            return "Announcements"
        }
    }
}
