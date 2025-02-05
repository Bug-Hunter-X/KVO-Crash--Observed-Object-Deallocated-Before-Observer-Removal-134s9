The solution involves ensuring that the observer is removed using `removeObserver:forKeyPath:` before the observed object is deallocated. Here's a corrected version:

```objectivec
@interface MyObservedObject : NSObject
@property (nonatomic, strong) NSString *observedProperty;
@end

@implementation MyObservedObject
- (void)dealloc {
    NSLog (@"MyObservedObject deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Observe changes
}

- (void)startObserving:(MyObservedObject *)observedObject {
    [observedObject addObserver:self forKeyPath:@"observedProperty" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)stopObserving:(MyObservedObject *)observedObject {
    [observedObject removeObserver:self forKeyPath:@"observedProperty"];
}

- (void)dealloc {
  // In case the observer is deallocated before the observed object
}
@end

// In your ViewController or other class
- (void)someMethod {
    MyObservedObject *obj = [[MyObservedObject alloc] init];
    MyObserver *observer = [[MyObserver alloc] init];
    [observer startObserving:obj];
    // ... do something ...
    [observer stopObserving:obj];
    obj = nil; // This is important, releasing the observed object 
               // to ensure dealloc is called
}
```
This ensures that the observer is explicitly removed before the observed object is deallocated, preventing the crash.