require 'stringio'
 
module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
  ensure
    $stdout = STDOUT
    return out.string.strip
  end
end
