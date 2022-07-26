import SafariServices
import SwiftUI
import UIKit

public struct SafariView: View {

    // MARK: - Initializers
    
    public init(url: URL) {
        self.url = url
        self.configuration = Configuration()
    }
        
    // MARK: - API
    
    public typealias Configuration = SFSafariViewController.Configuration
    public typealias DismissButtonStyle = SFSafariViewController.DismissButtonStyle
    public typealias ActivityButton = SFSafariViewController.ActivityButton
    
    public func accentColor(_ accentColor: Color?) -> Self {
        preferredBarTintColor(accentColor)
    }
    
    public func preferredBarTintColor(_ color: Color?) -> Self {
        var modified = self
        if let color = color {
            modified.preferredBarTintColor = UIColor(color)
        } else {
            modified.preferredBarTintColor = nil
        }
        return modified
    }
    
    public func preferredControlTintColor(_ color: Color?) -> Self {
        var modified = self
        if let color = color {
            modified.preferredControlTintColor = UIColor(color)
        } else {
            modified.preferredControlTintColor = nil
        }
        return modified
    }
    
    public func dismissButtonStyle(_ style: DismissButtonStyle) -> Self {
        var modified = self
        modified.dismissButtonStyle = style
        return modified
    }
    
    public func configuration(_ configuration: Configuration) -> Self {
        var modified = self
        modified.configuration = configuration
        return self
    }
    
    public func entersReaderIfAvailable(_ entersReaderIfAvailable: Bool) -> Self {
        configuration.entersReaderIfAvailable = entersReaderIfAvailable
        return self
    }
    
    public func barCollapsingEnabled(_ barCollapsingEnabled: Bool) -> Self {
        configuration.barCollapsingEnabled = barCollapsingEnabled
        return self
    }
    
    public func activityButton(_ activityButton: ActivityButton?) -> Self {
        configuration.activityButton = activityButton
        return self
    }
    
    @available(iOS 15.2, *)
    public func eventAttribution(_ eventAttribution: UIEventAttribution?) -> Self {
        configuration.eventAttribution = eventAttribution
        return self
    }
    
    // MARK: - View
    
    public var body: some View {
        Representable(parent: self)
            .ignoresSafeArea(.container, edges: .all)
    }
    
    // MARK: - Private
    
    struct Modifier: ViewModifier {
        
        // MARK: - API
        
        @Binding
        var isPresented: Bool
        var onDismiss: () -> Void
        var builder: () -> SafariView
        
        // MARK: - ViewModifier
        
        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(isPresented: $isPresented,
                              onDismiss: onDismiss,
                              builder: builder)
                )
        }
    }
    
    struct ItemModitifer<Item>: ViewModifier where Item: Identifiable {
        
        // MARK: - API
        
        @Binding
        var item: Item?
        var onDismiss: () -> Void
        var builder: (Item) -> SafariView
            
        // MARK: - ViewModifier
        
        func body(content: Content) -> some View {
            content.background(
                ItemPresenter<Item>(
                    item: $item,
                    onDismiss: onDismiss,
                    builder: builder
                )
            )
        }
    }
    
    private struct Presenter: UIViewRepresentable {
        
        // MARK: - API
        
        @Binding
        var isPresented: Bool
        var onDismiss: () -> Void
        var builder: () -> SafariView
        
        // MARK: - UIViewRepresentable
        
        final class Coordinator: NSObject, SFSafariViewControllerDelegate {
            
            // MARK: - Initialziers
            
            init(parent: Presenter) {
                self.parent = parent
            }
            
            // MARK: - API
            
            var parent: Presenter
            
            let view = UIView()
            
            var isPresented: Bool = false {
                didSet {
                    handleChange(from: oldValue, to: isPresented)
                }
            }
            
            // MARK: - SFSafariViewControllerDelegate
            
            func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                parent.isPresented = false
                parent.onDismiss()
            }
            
            // MARK: - Private
            
            private weak var safari: SFSafariViewController?
            
            private func handleChange(from oldValue: Bool, to newValue: Bool) {
                switch (oldValue, newValue) {
                case (false, false):
                    break
                case (false, true):
                    presentSafari()
                case (true, false):
                    dismissSafari()
                case (true, true):
                    updateSafari()
                }
            }
            
            private func presentSafari() {
                let rep = parent.builder()
                let vc = SFSafariViewController(url: rep.url, configuration: rep.configuration)
                vc.delegate = self
                rep.apply(to: vc)
                guard let presenting = view.viewController else {
                    parent.isPresented = false
                    return
                }
                presenting.present(vc, animated: true)
                safari = vc
            }
            
            private func dismissSafari() {
                guard let safari = safari else {
                    return
                }
                
                safari.dismiss(animated: true) {
                    self.parent.onDismiss()
                }
            }
            
            private func updateSafari() {
                guard let safari = safari else {
                    return
                }
                let rep = parent.builder()
                rep.apply(to: safari)
            }
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }
        
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.parent = self
            context.coordinator.isPresented = isPresented
        }
        
    }
    
    private struct ItemPresenter<Item>: UIViewRepresentable where Item: Identifiable {
        
        // MARK: - API
        
        @Binding
        var item: Item?
        var onDismiss: () -> Void
        var builder: (Item) -> SafariView
        
        // MARK: - UIViewRepresentable
        
        final class Coordinator: NSObject, SFSafariViewControllerDelegate {
            
            // MARK: - Initializers
            
            init(parent: ItemPresenter) {
                self.parent = parent
            }
            
            // MARK: - API
            
            var parent: ItemPresenter
            
            let uiView = UIView()
            
            var item: Item? {
                didSet(oldItem) {
                    handleItemChange(from: oldItem, to: item)
                }
            }
            
            // MARK: - SFSafariViewControllerDelegate
            
            func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                parent.item = nil
                parent.onDismiss()
            }
            
            // MARK: - Private
            
            private weak var safari: SFSafariViewController?
            
            private func handleItemChange(from oldItem: Item?, to newItem: Item?) {
                switch (oldItem, newItem) {
                case (.none, .none):
                    ()
                case let (.none, .some(newItem)):
                    presentSafari(with: newItem)
                case let (.some(oldItem), .some(newItem)) where oldItem.id != newItem.id:
                    dismissSafari() {
                        self.presentSafari(with: newItem)
                    }
                case let (.some, .some(newItem)):
                    updateSafari(with: newItem)
                case (.some, .none):
                    dismissSafari()
                }
            }
            
            private func presentSafari(with item: Item) {
                let representation = parent.builder(item)
                let vc = SFSafariViewController(url: representation.url, configuration: representation.configuration)
                vc.delegate = self
                representation.apply(to: vc)
                
                guard let presenting = uiView.viewController else {
                    self.parent.item = nil
                    return
                }
                
                presenting.present(vc, animated: true)
                
                safari = vc
            }
            
            private func updateSafari(with item: Item) {
                guard let safari = safari else {
                    return
                }
                let representation = parent.builder(item)
                representation.apply(to: safari)
            }
            
            private func dismissSafari(completion: (() -> Void)? = nil) {
                guard let safari = safari else {
                    return
                }
                
                safari.dismiss(animated: true) {
                    self.parent.onDismiss()
                    completion?()
                }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }
        
        func makeUIView(context: Context) -> some UIView {
            context.coordinator.uiView
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.parent = self
            context.coordinator.item = item
        }
        
    }
    
    private struct Representable: UIViewControllerRepresentable {
        
        // MARK: - Initializers
        
        init(parent: SafariView) {
            self.parent = parent
        }
        
        // MARK: - UIViewControllerRepresentable
        
        func makeUIViewController(context: Context) -> SFSafariViewController {
            let safari = SFSafariViewController(url: parent.url,
                                                configuration: parent.configuration)
            
            safari.modalPresentationStyle = .none
            parent.apply(to: safari)
            return safari
        }
        
        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
            parent.apply(to: uiViewController)
        }
        
        // MARK: - Private
        
        private var parent: SafariView
        
    }
    
    private let url: URL
    private var configuration: Configuration
    private var preferredBarTintColor: UIColor?
    private var preferredControlTintColor: UIColor?
    private var dismissButtonStyle: DismissButtonStyle = .done
    
    private func apply(to controller: SFSafariViewController) {
        controller.preferredBarTintColor = preferredBarTintColor
        controller.preferredControlTintColor = preferredControlTintColor
        controller.dismissButtonStyle = dismissButtonStyle
    }
    
}

fileprivate extension UIView {
    var viewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.viewController
        } else {
            return nil
        }
    }
}
