require_relative '../lib/parser'
require 'stringio'
require 'pry'

class ParserTest < Minitest::Test
  attr_reader :client
  def setup
    @client = StringIO.new "GET /to_braille HTTP/1.1\r\nHost: localhost:9294\r\nConnection: keep-alive\r\nAccept-Encoding: gzip, deflate, sdch\r\n\r\n['body']\r\n"
  end

  def test_can_get_the_path_from_a_request
    env = Parser.call(client)
    assert_equal "/to_braille", env["PATH_INFO"]
  end

  def test_header_keys_are_formatted_correctly

  end
end
