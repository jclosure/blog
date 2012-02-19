require 'test_helper'

class PhotosCellTest < Cell::TestCase
  test "display" do
    invoke :display
    assert_select "p"
  end
  

end
