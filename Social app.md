## Social app

is a social network iOS app. It's based on Firebase backend. As of now, it's a full scale app to post, make friends, exchange news and photos. 

# Core functionality

Login

you are able to login with your credentials. If you are already logged and you have given permission for faceID usage, next time your login will go seamless - no need to use login and password.



Sign Up

you are able to sign up as new user. Just enter login and password and repeat password. Firebase requierements are set for password length (not less than 6 symbols).

Optionally you can add info on city, your occupation and full name and upload avatar (for those, who hasn't - standard Social avatar appears).

Posts

here all the posts of followed users are shown. You are able to like their posts or save them in favorites. To like - double tap on post, to save - tap the star icon in the post. 

Also you can add subscribers - just tap on Plus icon and choose your friend.

Profile

Here you can edit your profile info, see you statistics on posts, followers and subscriptions. And sure you can add new posts by yourself.

Locations

press the button and you will see a map with your locations. You can add personal POIs (they are saved in Firebase) and calucalate routes to them. Also the map type can be chosen (standard, satellite).

Gallery

Please feel free to see all images from your posts stored for you in gallery. You can also add new photos by pressing icon on top of the screen


## Structure of Code

Managers
- AuthManager - manages all the authentification in Firebase - log in, log out, getting user credentials
- BiometryManager - the whole face id logic is here - the permissions are checked and the auth triggered
- StorageManager - here manager provides all the back-end storage support - writing docs, fetching docs, updating docs. As well as some convinience methods - to add likes, followers etc
- CloudStorageManager - facilitates all cloud infrastructure requests
- CoreDManager - provides functionality of saving and retrieving posts from favorites

Views
- LoginViewModel - view model to process auth in the app
- PhotosCollectionViewCell - creates cells for Photo gallery
- FollowerAvatarCollectionViewCell - creates cells for follower avatars in PostVC
- SocialTextView - custom text view for post text body
- PostTableViewCell - creates cells for post table in PostVC and ProfileVC
- PostStatisticsView - view in Post - likes and favorites
- VerticalLabelView and VerticalImageLabelView - constructs buttons for new post, locations, gallery functionality
- ProfileStatisticsView - view in Profile header to show statistics of logged user - posts, subscribers, followers
- ProfileHeaderView - constructs the whole header in ProfileVC
- SocialButton - custom Social branded button
- Divider - custom divider
- EntryHeaderView - header view for login screen with Social logo
- SocialTextField - custom Social branded text field
- AvatarImageView - view to show circled avatar
- LogOutButton - custom log out button for UINavigationController
- FollowersView - view in PostsVC to show all followed users
- AddFollowerTableViewCell - cells for followers view
- NoPostLabelView - custom no posts label for PostsVC and ProfileVC
- MapTypeCollectionViewCell - cells for map type VC
- ProfileDetailsEditView - view with additional info on profile

Controllers
- CoreTabVC - core vc in app - draws tabs
- LoginBiometryVC - vc for face id sign in
- LocationsVC - vc to show map and POIs of user
- EditUserVC - vc to edit user info, as well as show followers info
- LargePhotosVC - vc to show enlarged versions of images from gallery
- PhotosVC - vc to show user images gallery
- AddFollowedVC - vc to add followed users with 2 tableviews
- LoginVC - entry to the app, login screen
- SignUpVC - vc to register new users
- PostsVC - vc shows all posts by followed users and enables following another users
- NewPostVC - vc to create new posts
- ProfileVC - vc to show logged user profile, his posts and navigate to new post vc, locations, gallery
- FavoritesVC - vc to save favorite posts in local storage (for logged user)
- MapTypeVC - vc to change map types in locations