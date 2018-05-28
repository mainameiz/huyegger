require "huyegger/version"
require "huyegger/logger"

module Huyegger
  DEFAULT_JSON_ENCODER = proc { |obj, *opts| obj.to_json(*opts) }

  class << self
    attr_accessor :json_encoder
  end

  self.json_encoder = DEFAULT_JSON_ENCODER

  def self.stringify_keys(hash)
    Hash.new.tap do |new_hash|
      hash.each do |key, value|
        new_hash[key.to_s] = value
      end
    end
  end
end
