## Requirements
- Show OnboardingView and AuthView in BottomSheet presented from HomeView when clicked on showSheet Button
- Sheet Should not be manually dimissed
- Sheet should automatically resize based on it's current page height
- Onbarding View should contain a `Continue` button and on clicking it should show AuthView as paginated
- AuthView content will vary based on User already has a account or not. If user already has a account it should show Login content and if not then it should show Registration content
- AuthView will contain a CTA which will display Text and performs action based on isAlreadyHavingAccount Bool value

## Components
- HomeView
    - Properties [
        @State showSheet: Bool,
        @State SheetHeight: CGFloat,
        @State SheetFirstPageHeight: CGFloat,
        @State SheetSecondPageHeight: CGFloat,
        @State scrollSheetProgress: CGFloat,
        @State alreadyHavingAccount: CGFloat = false,
        @State email: String,
        @State password: String
    ]
    - UI Elements [VStack, Spacer, showSheet Button, BottomAuthContainerView]
- BottomAuthContainerView
    - Properties [@Binding SheetHeight: CGFloat, ]
    - UI Elements [ScrollViewReader, GeometryReader Size, ScrollView, HStack, OnboardingView, AuthView, Overlay CTA]
- OnboardingView
    - Properties [@Binding sheetFirstPageheight: Bool, @Binding sheetHeight: CGFloat, subTitle: AttributedString Computed]
    - UI Elements [VStack, Title, Subtitle, heightChangePreference]
- AuthView
    - Properties [@Binding email: String, @Binding password: String]
    - UI Elements [Vstack, Title, Email CustomTF, Password CustomTF, heightChangePreference, minXChangePreference]
- CustomTF
    - Properties [ hint: String, isPassword: Bool, @Binding text: String, icon: String]
    - UI Elements [VStack, TF, Divider, Overlay icon [Envelope, lock]]
    
## Helpers
- SizeKey: PreferenceKey, Value: CGSize
- Offsetkey: Preferencekey, Value: CGSize
- View+Extension
    - heightChangePreference(completion: (CGFloat) -> Void)) -> some View
        - [Overlay, GeometryReader size, Color.Clear, SetSizeKeyPreference, OnPreferenceChange(SizeKey) Extract Height and pass in completion]
    - minXChangePreference(completion: (CGFloat) -> Void)) -> some View
        - [Overlay, GeometryReader size, Color.Clear, SetSizeKeyPreference, OnPreferenceChange(Offsetkey) Extract minX and pass in completion]

Notes:
- We use minXChangePreference in AuthView to calculate the scrollSheetProgress and adding the difference height based on progress to sheetHeight
