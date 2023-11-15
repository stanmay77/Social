import UIKit

// UI Constants


struct UIConstants {
    
    // Login view
    
    static let logoImageShadowRadius = 6.0
    static let logoImageShadowOpacity = 0.9
    static let logoImageWidth = 180.0
    static let logoImageHeight = 180.0
    
    static let postTitleAlignment = 10.0
    static let postAvatarSize = 65.0
    static let newPostAvatarSize = 65.0
    static let newPostTitleTopOffset = 20.0
    static let newPostGreetingFontSize = 19.0
    static let trailingStandardOffser = -15.0
    
    static let loginEntryHeaderTopSpacing = 50.0
    static let loginEntryHeaderSize = 180.0
    static let loginAppNameLabelTopSpacing = 50.0
    static let loginFieldTopSpacing = 50.0
    static let loginFieldLeadingTrailingSpacing = 16.0
    static let loginFieldHeight = 50.0
    static let passwordFieldTopSpacing = 15.0
    static let loginButtonHeight = 50.0
    static let loginButtonTopSpacing = 16.0
    static let signUpLabelTopSpacing = 5.0
    static let signUpLabelHeight = 30.0
    static let signUpLabelBottomSpacing = -20.0
    
    
    //Sign Up
    static let signUpTitleLabelTopSpacing = 15.0
    static let signUpLabelLeadingTrailingSpacing = 21.0
    static let textFieldHeight = 50.0
    static let textFieldTopSpacing = 5.0
    static let textFieldLeadingTrailingSpacing = 16.0
    static let passwordConfirmationLabelTopSpacing = 15.0
    static let passwordConfirmationLabelHeight = 20.0
    static let profileLabelTopSpacing = 15.0
    static let signUpProfileDetailsViewHeight = 155.0
    static let uploadPhotoLabelTopSpacing = 70.0
    static let uploadPhotoLabelWidth = 100.0
    static let signUpButtonHeight = 50.0
    static let signUpButtonTopSpacing = 50.0
    static let avatarImageViewSize = 100.0
    static let avatarImageViewTrailingSpacing = -16.0
    
    
    // New Post
    
    static let newPostScrollViewTopAnchor = 0.0
    static let newPostScrollViewLeadingAnchor = 0.0
    static let newPostScrollViewTrailingAnchor = 0.0
    static let newPostScrollViewBottomAnchor = 0.0
    static let newPostScrollContentViewTopAnchor = 0.0
    static let newPostAvatarTopOffset = 50.0
    static let newPostAvatarLeadingOffset = 15.0
    //    static let newPostAvatarImageSize = 100.0
    static let newPostUserNameLabelOffset = 20.0
    static let newPostUserNameLabelHeight = 80.0
    static let newPostDividerTopOffset = 15.0
    static let newPostDividerHeight = 1.5
    static let newPostTitleFieldHeight = 50.0
    static let newPostTitleFieldTopOffset = 45.0
    static let newPostTextViewHeight = 120.0
    static let newPostTextViewTopOffset = 15.0
    static let newPostUploadLabelWidth = (UIScreen.main.bounds.width - 30) / 2
    static let newPostUploadLabelHeight = 50.0
    static let newPostUploadImageViewTopOffset = 20.0
    static let newPostUploadImageViewSize = (UIScreen.main.bounds.width - 30) / 4
    static let newPostButtonTopOffset = 25.0
    static let newPostButtonHeight = 50.0
    static let newPostButtonBottomOffset = -120.0
    //    static let trailingStandardOffset = -15.0
    
    
    // Photo gallery
    static let photosCornerRadius = 10.0
    static let photoWidth = 100.0
    static let photoHeight = 100.0
    static let largePhotoTitleImageTopSpacing = 20.0
    static let largePhotoTitleImageLeadingSpacing = 15.0
    static let largePhotoTitleImageSize = 45.0
    static let largePhotoTitleLabelLeadingSpacing = 10.0
    static let largePhotoTitleLabelWidth = UIScreen.main.bounds.width - 85.0
    static let largePhotoTitleLabelHeight = 30.0
    static let largePhotoDividerTopSpacing = 15.0
    static let largePhotoDividerHeight = 1.5
    static let largePhotoImageViewTopSpacing = 15.0
    static let largePhotoImageViewLeadingSpacing = 15.0
    static let largePhotoImageViewTrailingSpacing = -15.0
    static let largePhotoImageViewSize = UIScreen.main.bounds.width
    static let photosCollectionViewLeadingSpacing = 15.0
    static let photosCollectionViewTrailingSpacing = -15.0
    
    
    
    // Followers
    static let followerAvatarTopOffset = 10.0
    static let followerAvatarBorderWidth = 1.0
    static let followerAvatarBorderSize = 50.0
    static let followersCollectionViewSize = 80.0
    static let addFollowerCellAvatarSize = 50.0
    static let addFollowerCellAvatarBorderWidth = 1.0
    static let addFollowerCellTopSpacing = 10.0
    static let addFollowerCellLeadingSpacing = 15.0
    static let addFollowerCellAvatarWidth = 50.0
    static let addFollowerCellAvatarHeight = 50.0
    static let addFollowerCellNameLabelLeadingSpacing = 15.0
    static let addFollowedTitleTopSpacing = 30.0
    
    static let addFollowedTitleTopAnchor = 30.0
    static let addFollowedTitleLeadingAnchor = 30.0
    static let addFollowedTitleWidth = 300.0
    static let addFollowedTitleHeight = 40.0
    
    static let addFollowedDividerTopSpacing = 15.0
    static let addFollowedDividerLeadingTrailingAnchor = 15.0
    static let addFollowedDividerHeight = 1.0
    
    static let addFollowedAlreadyFollowedLabelTopSpacing = 15.0
    static let addFollowedAlreadyFollowedLabelHeight = 50.0
    static let addFollowedLabelLeadingTrailingAnchor = 15.0
    
    static let addFollowedTableViewTopSpacing = 15.0
    
    // General
    static let cloudUploadErrorImage = "xmark.icloud"
    static let avatarImageSize = 50.0
    static let followerNameTopOffset = 20.0
    static let universalCornerRadius = 10.0
    static let socialTextFieldSpacerSize = 10.0
    static let socialTextFieldFontSize = 16.0
    static let socialTextFieldCornerRadius = 10.0
    static let signUpFieldHeight = 50.0
    static let signUpFieldLeadingSpacing = 16.0
    static let signUpFieldTrailingSpacing = -16.0
    static let signUpFieldTopSpacing = 5.0
    static let entryHeaderViewTopSpacing = 50.0
    static let entryHeaderViewSize = 180.0
    static let appNameLabelTopSpacing = 50.0
    static let faceIDImageViewSize = 100.0
    static let faceIDImageViewTopSpacing = 50.0
    
    // ProfileHeaderView
    static let profileStatsLabelFont = 15.0
    static let profileHeaderAvatarSize = 75.0
    static let nameLabelFontSize = 20.0
    static let cityLabelFontSize = 15.0
    static let verticalViewImageViewWidth = 50.0
    static let verticalViewImageViewHeight = 50.0
    static let verticalViewTextLabelTopSpacing = 2.0
    static let verticalViewTextLabelHeight = 20.0
    static let verticalViewTextLabelWidth = 120.0
    
    // Posts
    static let postTextViewFontSize = 15.0
    static let postTextViewPlaceholderLeadingOffset = 10.0
    static let postTextViewPlaceholderHeight = 20.0
    static let postTextViewPlaceholderWidth = 150.0
    static let postAvatarBorderWidth = 0.5
    static let postTitleFontSize = 17.0
    static let postDateFontSize = 14.0
    static let postAuthorFontSize = 14.0
    static let postBodyTextFontSize = 15.0
    static let postTopAnchorSpacing = 15.0
    static let postLeadingAnchorSpacing = 50.0
    static let postTrailingAnchorSpacing = -15.0
    static let postDateTopSpacing = 5.0
    static let postTextTopSpacing = 15.0
    static let postDividerLeadingSpacing = 25.0
    static let postDividerWidth = 4.0
    static let postGreyDividerHeight = 1.0
    static let postStatViewTopSpacing = 5.0
    static let postStatViewHeight = 30.0
    static let postStatViewBottomSpacing = -5.0
    static let likesImageSize = 20.0
    static let likesLabelwidth = 35.0
    static let likesLabelHeight = 20.0
    static let favoritesTapAreaSize = 30.0
    static let likesLabelLeadingOffset = 5.0
    static let saveFavoritesTrailingSpacing = -5.0
    static let saveFavoritesLeadingSpacing = 5.0
    static let saveFavoritesTopSpacing = 5.0
    static let saveFavoritesBottomSpacing = -5.0
    
    // Locations
    
    static let mapTypeImageTopSpacing = 15.0
    static let mapTypeImageHeight = 150.0
    static let mapTypeImageWidth = 150.0
    static let mapTypeLabelTopSpacing = 5.0
    static let mapTypeLabelHeight = 50.0
    static let mapOverlayTopSpacing = 50.0
    static let mapOverlayTrailingSpacing = -10.0
    static let mapTypeOverlaySize = 38.0
    static let routeInfoOverlayLeadingSpacing = 10.0
    static let routeInfoOverlayWidth = 170.0
    static let routeInfoOverlayHeight = 40.0
    static let mapTypeLabelWidthMultiplier = 0.7
    static let mapTypeLabelHeightMultiplier = 0.7
    
    static let mapTypeCollectionTopOffset = 50.0
    static let mapTypeCollectionLeadingOffset = 15.0
    static let mapTypeCollectionTrailingOffset = 15.0
    static let mapTypeCollectionBottomOffset = 100.0
    
    
    // Edit user
    static let editUserAvatarTopSpacing = 50.0
    static let editUserAvatarLeadingSpacing = 15.0
    static let editUserAvatarSize = 100.0
    static let editUserNameLabelLeadingSpacing = 20.0
    static let editUserNameLabelSize = 170.0
    static let editUserDividerTopSpacing = 15.0
    static let editUserDividerHeight = 1.0
    static let editUserGreetingLabelTopSpacing = 15.0
    static let editUserGreetingLabelHeight = 20.0
    static let profileDetailsViewTopSpacing = 10.0
    static let profileDetailsViewHeight = 155.0
    static let proceedButtonHeight = 50.0
    static let proceedButtonTopSpacing = 50.0
    
    
    
    
}
