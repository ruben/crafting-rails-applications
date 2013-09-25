require 'test_helper'

class LiveAssetsTest < ActiveSupport::TestCase
  setup do
    FileUtils.mkdir_p "test/tmp"
  end

  teardown do
    FileUtils.rm_f "test/tmp"
  end

  test "can subscribe to listener events" do
    # Create a listener
    thread = LiveAssets.start_listener(:reload, ["test/tmp"])

    # Our subscriber is a simple array
    subscriber = []
    LiveAssets.subscribe(subscriber)

    begin
      while subscriber.empty?
        # Trigger changes in a file until the subscriber gets an event
        File.write("test/tmp/empty", SecureRandom.hex(20))
      end

      # Assert we got the event
      assert_includes subscriber, :reload
    ensure
      # Cleanup
      LiveAssets.unsubscribe(subscriber)
      thread.kill
    end
  end

  test "can subscribe to existing reloadCSS events" do
    subscriber = []
    LiveAssets.subscribe(subscriber)

    begin
      while subscriber.empty?
        FileUtils.touch("test/dummy/app/assets/stylesheets/application.css")
      end
      assert_includes subscriber, :reloadCSS
    ensure
      LiveAssets.unsubscribe(subscriber)
    end
  end

end
