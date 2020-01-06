struct UUID
  def self.from_s?(string : String)
    UUID.new(string)
  rescue ArgumentError
    nil
  end
end
