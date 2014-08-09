require 'rubygems'
require 'json'
require 'net/http'
require 'cgi'
require 'nokogiri'

dir = File.dirname(__FILE__)


Net::HTTP.start('ratings.food.gov.uk') do |http|
  req = Net::HTTP::Get.new("/OpenDataFiles/FHRS857en-GB.xml") 
  response = http.request(req)
  #xml = File.read( File.join(dir, "..", "data", "FHRS857en-GB.xml") )
  #doc = Nokogiri::XML( xml )
  doc = Nokogiri::XML( response.body )
  output = {
    "establishments" => []
  }
  doc.xpath("//EstablishmentDetail").each do |place|
    output["establishments"] << {
      "FHRSID" => place.at_xpath("FHRSID").text,
      "LocalAuthorityBusinessID" => place.at_xpath("LocalAuthorityBusinessID").text,
      "BusinessName" => place.at_xpath("BusinessName").text,
      "BusinessType" => place.at_xpath("BusinessType").text,
      "BusinessTypeID" => place.at_xpath("BusinessTypeID").text,
      "AddressLine1" => place.at_xpath("AddressLine1") ? place.at_xpath("AddressLine1").text : "",
      "AddressLine2" => place.at_xpath("AddressLine2") ? place.at_xpath("AddressLine2").text : "",
      "AddressLine3" => place.at_xpath("AddressLine3") ? place.at_xpath("AddressLine3").text : "",
      "AddressLine4" => place.at_xpath("AddressLine4") ? place.at_xpath("AddressLine4").text : "",
      "PostCode" => place.at_xpath("PostCode") ? place.at_xpath("PostCode").text : "",
      "RatingValue" => place.at_xpath("RatingValue").text,
      "RatingKey" => place.at_xpath("RatingKey").text,
      "RatingDate" => place.at_xpath("RatingDate").text,
      "HygieneScore" => place.at_xpath("Scores/Hygiene") ? place.at_xpath("Scores/Hygiene").text : "",
      "StructuralScore" => place.at_xpath("Scores/Structural") ? place.at_xpath("Scores/Structural").text : "",
      "ConfidenceInManagementScore" => place.at_xpath("Scores/ConfidenceInManagement") ? place.at_xpath("Scores/ConfidenceInManagement").text : "",
      "Location" => {
        "latitude" => place.at_xpath("Geocode/Latitude") ? place.at_xpath("Geocode/Latitude").text : "",
        "longitude" => place.at_xpath("Geocode/Longitude") ? place.at_xpath("Geocode/Longitude").text : ""
      }      
    }
  end
  File.open( File.join(dir, "..", "data", "banes-ratings.json"), "w") do |file|
    file.puts JSON.pretty_generate(output)
  end
end
