import UIKit

extension UIApplication {
    func getTopMostViewController() -> UIViewController? {
        guard let window = self.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).first,
              var topController = window.rootViewController else {
            return nil
        }

        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        return topController
    }
}

extension Progress {
    func toProgressEntry() -> ProgressEntry? {
        // Ensure milestoneId is valid
        guard let milestoneUUID = self.milestoneId as UUID? else { return nil }
        
        return ProgressEntry(
            id: UUID(),
            milestoneId: milestoneUUID,
            goalId: self.goalId,
            description: self.description,
            date: self.date
        )
    }
}
