require 'json'

class TimelineGen

  # Change date format to work with TimelineJS
  def self.parseDate(date)
    if date != nil
      date.gsub!("-",",")
      date.gsub!(" ",",")
      date.gsub!(":",",")
    end
    date
  end
  
  # Generate JSON for event
  def self.genEvent(startDate, endDate, headline, text)
    JSON.pretty_generate(
                         "startDate" => parseDate(startDate),
                         "endDate" => parseDate(endDate),
                         "headline" => headline,
                         "text" => text
                        )
  end


  # Generates all event JSONs
  def self.parseEvents(file)
    pe = JSON.parse(File.read(file))
    k = pe.length
    event = Array.new
    (1..k-1).each do |i|
      if i > 0
        event[i] = JSON.parse(
                              genEvent(
                                       (pe[i])["date"], 
                                       nil, 
                                       (pe[i])["subject"], 
                                       (pe[i])["body"]
                                       )
                              )
        end
    end
    return event
  end
  
  #Gets the headline
  def self.parseHeadline(file)
    headline = (JSON.parse(File.read(file))[0])["emailheadline"]
  end

  # Generates full timeline JSON
  def self.genTimeline(event, headline)
    JSON.pretty_generate(
                         "timeline" => {
                           "headline" => headline,
                           "type" => "default",
                           "text" => "   ",
                           "date" => event
                         }
                       )
  end
end

