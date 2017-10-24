class String
  def chunk(value)
    unpack("a#{value}"*((size/value)+((size%value>0)?1:0)))
  end
end
