require 'rubygems'
require 'net/http'
require 'cgi'
require 'nokogiri'
require 'csv'

dir = File.dirname(__FILE__)


Net::HTTP.start('ratings.food.gov.uk') do |http|
  req = Net::HTTP::Get.new("/OpenDataFiles/FHRS857en-GB.xml") 
  response = http.request(req)
  doc = Nokogiri::XML( response.body )
  
  CSV.open( File.join(dir, "..", "data", "banes-ratings.csv"), "w") do |csv|

    csv << [
      "FHRSID",
      "LocalAuthorityBusinessID",
      "BusinessName",
      "BusinessType",
      "BusinessTypeID",
      "AddressLine1",
      "AddressLine2",
      "AddressLine3",
      "AddressLine4",
      "PostCode",
      "RatingValue",
      "RatingKey",
      "RatingDate",
      "HygieneScore",
      "StructuralScore",
      "ConfidenceInManagementScore",
      "Latitude",
      "Longitude"          
    ]      
    
    doc.xpath("//EstablishmentDetail").each do |place|
      csv << [
        place.at_xpath("FHRSID").text,
        place.at_xpath("LocalAuthorityBusinessID").text,
        place.at_xpath("BusinessName").text,
        place.at_xpath("BusinessType").text,
        place.at_xpath("BusinessTypeID").text,
        place.at_xpath("AddressLine1") ? place.at_xpath("AddressLine1").text : "",
        place.at_xpath("AddressLine2") ? place.at_xpath("AddressLine2").text : "",
        place.at_xpath("AddressLine3") ? place.at_xpath("AddressLine3").text : "",
        place.at_xpath("AddressLine4") ? place.at_xpath("AddressLine4").text : "",
        place.at_xpath("PostCode") ? place.at_xpath("PostCode").text : "",
        place.at_xpath("RatingValue").text,
        place.at_xpath("RatingKey").text,
        place.at_xpath("RatingDate").text,
        place.at_xpath("Scores/Hygiene") ? place.at_xpath("Scores/Hygiene").text : "",
        place.at_xpath("Scores/Structural") ? place.at_xpath("Scores/Structural").text : "",
        place.at_xpath("Scores/ConfidenceInManagement") ? place.at_xpath("Scores/ConfidenceInManagement").text : "",
        place.at_xpath("Geocode/Latitude") ? place.at_xpath("Geocode/Latitude").text : "",
        place.at_xpath("Geocode/Longitude") ? place.at_xpath("Geocode/Latitude").text : ""      
      ]
    end    
  
  end

end
