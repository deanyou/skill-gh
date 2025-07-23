# RmBannerItemByName.il

## Purpose/Description
Removes a specific menu item from the Cadence interface banner by name. This utility function helps clean up the user interface by removing previously loaded custom menus.

## Function Signature
```skill
RmBannerItemByName(l_menuName @optional (window_id window(1)))
```

## Parameters
- `l_menuName` - Name of the menu item to remove from the banner
- `window_id` - Window identifier (optional, defaults to `window(1)`)

## Dependencies
- `hiGetBannerMenus()` - Cadence function to get banner menu list
- `hiDeleteBannerMenu()` - Cadence function to delete banner menu
- `fboundp()` - SKILL function to check if function is bound

## Return Values
- No explicit return value
- Side effect: Removes specified menu from the banner

## Usage Examples
```skill
; Load the function
load("RmBannerItemByName.il")

; Remove a custom menu called "MyCustomMenu"
RmBannerItemByName("MyCustomMenu")

; Remove menu from specific window
RmBannerItemByName("DebugMenu" window(2))

; Remove multiple menus
foreach(menuName '("Menu1" "Menu2" "TempMenu")
    RmBannerItemByName(menuName)
)
```

## Notes/Special Considerations
- **Conditional Definition**: Only defines the function if not already bound (`unless(fboundp(...))`)
- **Menu Search**: Uses `member()` to find the menu in the banner list
- **Position Calculation**: Calculates menu position using list length differences
- **Safe Operation**: Only attempts deletion if menu exists in banner
- **Window Context**: Operates on specific window contexts
- **Interface Cleanup**: Useful for removing temporary or debug menus
- **Error Prevention**: Guards against multiple function definitions
- **Menu Management**: Part of dynamic menu management system