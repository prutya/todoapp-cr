struct UUID
  def self.from_s?(string : String)
    new(string)
  rescue ArgumentError
    nil
  end
end
