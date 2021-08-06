extension APIScope {
    /// https://vk.com/dev/video
    public enum Video: APIMethod {
        case add(Parameters)
        case addAlbum(Parameters)
        case addToAlbum(Parameters)
        case createComment(Parameters)
        case delete(Parameters)
        case deleteAlbum(Parameters)
        case deleteComment(Parameters)
        case edit(Parameters)
        case editAlbum(Parameters)
        case editComment(Parameters)
        case get(Parameters)
        case getAlbumById(Parameters)
        case getAlbums(Parameters)
        case getAlbumsByVideo(Parameters)
        case getCatalog(Parameters)
        case getCatalogSection(Parameters)
        case getComments(Parameters)
        case hideCatalogSection(Parameters)
        case removeFromAlbum(Parameters)
        case reorderAlbums(Parameters)
        case reorderVideos(Parameters)
        case report(Parameters)
        case reportComment(Parameters)
        case restore(Parameters)
        case restoreComment(Parameters)
        case save(Parameters)
        case search(Parameters)
    }
}