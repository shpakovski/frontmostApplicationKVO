@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic, getter = isObserving) BOOL observing;

@end
