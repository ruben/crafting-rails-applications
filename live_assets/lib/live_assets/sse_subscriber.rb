require 'thread'

module LiveAssets
  class SSESubscriber
     def initialize(queue = Queue.new)
       @queue = queue
       LiveAssets.subscribe(@queue)
     end

    def each
      while event = @queue.pop
        yield "event: #{event}\ndata: {}\n\n"
      end
    end
  end
end