def valid_of?(url)
  begin
    io = open(url, read_timeout: 5)
    [200, 301, 302].include?(io.status.first.to_i)
  rescue Exception => ex
    return [false, ex.message]
  end
end

def get_customer_meta_of(og, meta, sub = nil)
  return nil if og.metadata[meta].blank? || (meta_item = og.metadata[meta].first).blank?
  return meta_item[:_value] unless sub
  return nil if meta_item[sub].blank? || ( sub_item = meta_item[sub].first).blank?
  return sub_item[:_value]
end
