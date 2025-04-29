struct AIBannerModel {
    let icon: String
    let name: String
    let h5Url: String
    
    init(icon: String, name: String, h5Url: String) {
        self.icon = icon.isEmpty ? "default_icon" : icon
        self.name = name
        self.h5Url = h5Url
    }
}