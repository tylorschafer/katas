require 'test/unit'
require './cosby_speak'

class CosbySpeakTest < Test::Unit::TestCase

    ##########################
    #                        #
    # English to Cosby Speak #
    #                        #
    ##########################

    def test_mark_to_cosby
      c = CosbySpeak.new "Mark"

      assert_equal c.to_cosby, "Nerphippaloo"
    end

    ##########################
    #                        #
    # Cosby Speak to English #
    #                        #
    ##########################

  def test_mark_to_english
      c = CosbySpeak.new "Nerphippaloo"

      assert_equal c.to_english, "Mark"
  end
          
end
