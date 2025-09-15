<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>ScuolaVideo</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>ScuolaVideo</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>CFBundleSignature</key>
	<string>????</string>

	<!-- Deep Linking Schemes -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>academyapp</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb715781717022310</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLIconFile</key>
			<string>GoogleService-Info</string>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.346142227155-30a9drvvvduc0qboegip572sh6e30aeg</string>
			</array>
		</dict>
	</array>

	<!-- Facebook -->
	<key>FacebookAppID</key>
	<string>715781717022310</string>
	<key>FacebookClientToken</key>
	<string>cc041a5342128d416bf5802d2705630a</string>
	<key>FacebookDisplayName</key>
	<string>ScuolaVideo</string>
	<key>FacebookAutoLogAppEventsEnabled</key>
	<false/>

	<!-- Google Sign-In -->
	<key>GIDClientID</key>
	<string>346142227155-30a9drvvvduc0qboegip572sh6e30aeg.apps.googleusercontent.com</string>

	<!-- Permissions (iOS Equivalents of Android Permissions) -->
	<key>NSCameraUsageDescription</key>
	<string>This app requires camera permission for video calls and media sharing.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>This app requires microphone access for audio recording and calls.</string>
	<key>NSCalendarsUsageDescription</key>
	<string>We need access to your calendar to schedule webinars.</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>We need access to your photo library to allow media upload.</string>
	<key>NSSpeechRecognitionUsageDescription</key>
	<string>Used to convert your speech to text for accessibility features.</string>
	<key>NSContactsUsageDescription</key>
	<string>Used to help connect with contacts for webinars.</string>
	<key>NSLocalNetworkUsageDescription</key>
	<string>Used to discover nearby devices (e.g., Chromecast).</string>

	<!-- Chromecast / Bonjour -->
	<key>NSBonjourServices</key>
	<array>
		<string>_googlecast._tcp</string>
	</array>

	<!-- Background Modes -->
	<key>UIBackgroundModes</key>
	<array>
		<string>fetch</string>
		<string>remote-notification</string>
	</array>

	<!-- App Networking -->
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>

	<!-- Facebook & Messenger URLs -->
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbapi</string>
		<string>fb-messenger-share-api</string>
	</array>

	<!-- UI Config -->
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIStatusBarHidden</key>
	<false/>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>

	<!-- Flutter Specific -->
	<key>io.flutter.embedded_views_preview</key>
	<string>YES</string>
	<key>FLTEnableImpeller</key>
	<false/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
</dict>
</plist>