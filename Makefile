DIR = ScrollingBarsTest
WORKSPACE = $(DIR)/ScrollingBarsTest.xcworkspace
SCHEME = ScrollingBarsTest
DESTINATION = platform=iOS Simulator,name=iPhone 6,OS=8.1

clean:
	xcodebuild \
	  -workspace $(WORKSPACE) \
	  -scheme $(SCHEME) \
	  clean

test-setup:
	cd "$(DIR)" && bundle exec pod install

test:
	xcodebuild \
	  -workspace $(WORKSPACE) \
	  -scheme $(SCHEME) \
	  -sdk iphonesimulator \
	  -destination "$(DESTINATION)" \
	  BUILD_ACTIVE_ARCH=NO \
	  test \
	  | xcpretty -s -c && exit $${PIPESTATUS[0]}
