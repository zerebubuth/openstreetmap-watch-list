xml.instruct! :xml, :version => "1.0"
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  range_str = @ranges.collect {|r| r.join("-") }.join(",")
  if @changesets.size > 0 then
    max_time = @changesets.collect { |id,time,n| time}.max
  else
    max_time = Time.now()
  end

  xml.title "List of changes (#{range_str})"
  xml.link :href => ROOT_URL, :type => "text/html", :rel => "alternate"
  xml.link :href => "#{ROOT_URL}/feed/#{range_str}.atom", :rel => "self"
  xml.subtitle "Changes for range #{range_str}", :type => "html"
  xml.id "#{ROOT_URL}/feed/#{range_str}.atom"
  xml.updated max_time.xmlschema

  @changesets.each do |id,time,n|
    xml.entry do
      details = @cs2details[id]
      if details.nil? 
	user_name = "unknown"
	xml.title "Changeset #{id}"
      else
	user_name = details[0] 
	xml.title "Changeset #{id} by #{user_name}"
      end
      xml.content(:type => "html") do
        xml.text! "<p>Changeset #{id} by <a href=\"http://www.openstreetmap.org/user/#{user_name}\">#{user_name}</a> covering #{n} tiles"
      	xml.text! ", with comment \"#{details[1]}\"" unless details.nil? or details[1].nil?
      	xml.text! ", using \"#{details[2]}\"" unless details.nil? or details[2].nil?
      	xml.text! ", and tagged as a bot" unless details.nil? or details[3].nil? or details[3] != "t"
      	xml.text! ". View changeset on <a href=\"http://www.openstreetmap.org/browse/changeset/#{id}\">main OSM site</a>.</p>"
      end
      xml.author do
        xml.name user_name
      end
      xml.updated time.xmlschema
      xml.link :href => "#{ROOT_URL}/owl_viewer/tiles/#{id}", :type => "text/html", :rel => "alternate"
      xml.id "http://matt.dev.openstreetmap.org/owl_viewer/tiles/#{id}"
    end
  end
end
